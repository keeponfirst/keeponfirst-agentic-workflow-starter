"""
debug_stitch.py

Admin/Debug utility to interact with the Stitch MCP server directly via stdio.
Useful for:
1. Verifying connectivity and authentication.
2. Discovering tool schemas (tools/list) which are often hidden from Agent context.
3. Manually invoking generation when Agent integration is blocked.

Usage:
  python3 scripts/debug_stitch.py > stitch_debug.log
"""
import subprocess
import json
import sys
import os

STITCH_CMD = ["npx", "-y", "@keeponfirst/kof-stitch-mcp"]

PROJECT_ENV = {"GOOGLE_CLOUD_PROJECT": "imposing-medium-485207-a8", "PATH": os.environ["PATH"]}

def run_rpc(process, method, params=None):
    request = {
        "jsonrpc": "2.0",
        "id": 1,
        "method": method
    }
    if params:
        request["params"] = params
    
    request_str = json.dumps(request) + "\n"
    process.stdin.write(request_str)
    process.stdin.flush()
    
    while True:
        line = process.stdout.readline()
        if not line:
            break
        try:
            response = json.loads(line)
            # Match logs to filter out initialization messages
            if response.get("id") == 1:
                return response
        except json.JSONDecodeError:
            # print(f"Log: {line.strip()}")
            continue

def main():
    print("Starting Stitch MCP for Discovery...")
    process = subprocess.Popen(
        STITCH_CMD,
        stdin=subprocess.PIPE,
        stdout=subprocess.PIPE,
        stderr=sys.stderr,
        text=True,
        env=PROJECT_ENV
    )

    try:
        # HARDCODED PROJECT ID
        target_project_name = "projects/8869703306699496608"
        target_project_id = "8869703306699496608" # Strip 'projects/' based on schema description
        
        print(f"Using Project: {target_project_id}")
        
        # 2. Generate Screen
        prompt = "Design a mobile app for BabyLog, a premium baby tracking app for new parents. The visual language is warm, soft, hand-drawn, and picture-book inspired."
        
        print("Generating screen...")
        
        # Schema requires 'projectId' and 'prompt'
        gen_resp = run_rpc(process, "tools/call", {
            "name": "generate_screen_from_text",
            "arguments": {
                "projectId": target_project_id, 
                "prompt": prompt,
                "deviceType": "MOBILE"
            }
        })
             
        if gen_resp and "result" in gen_resp and not gen_resp.get("error"):
            print("Generation successful. Listing screens to find new asset...")
            
            # 4. List Screens to find the latest ID
            list_scr_resp = run_rpc(process, "tools/call", {
                "name": "list_screens",
                "arguments": {
                    "projectId": target_project_id
                }
            })
            
            # Parse screens
            # Structure: result -> content -> [ { text: JSON_STRING? } ] or result -> screens ??
            # Wait, `list_projects` returned "content" list with "text" field containing JSON string.
            # But the schema for list_projects outputSchema said it returns an object with "projects" array.
            # So the MCP tool *execution* result structure is standard.
            # If the tool returns an object, the MCP server might wrap it in "content": [{"type":"text", "text": json.dumps(obj)}]
            # Let's handle both cases (object direct or stringified in text).
            
            latest_screen_id = None
            
            if "content" in list_scr_resp.get("result", {}):
                 content = list_scr_resp["result"]["content"]
                 if content and content[0]["type"] == "text":
                     try:
                        # Try parsing text as JSON
                        data = json.loads(content[0]["text"])
                        screens = data.get("screens", [])
                     except:
                        # Maybe it's just the dict directly if the server returns structured content?
                        # Usually stdio MCP returns text.
                        print("Could not parse content text as JSON, usually this means the tool returned plain text or error.")
                        screens = []
            elif "screens" in list_scr_resp.get("result", {}):
                 # Direct object return (unlikely for MCP stdio but possible)
                 screens = list_scr_resp["result"]["screens"]
            else:
                 # The result might be the tool output directly?
                 # No, standard MCP envelope.
                 # Let's assume the previous `list_projects` logic:
                 # content[0].text contained the JSON.
                 screens = []

            # Re-implement robust parsing from text content
            try:
                content_text = list_scr_resp["result"]["content"][0]["text"]
                # Sometimes the text "is" the JSON.
                data = json.loads(content_text)
                screens = data.get("screens", [])
            except Exception:
                screens = []

            if screens:
                # Find latest? 
                # Assuming the last one or we check IDs.
                # Let's simpler: take the first one found that looks new.
                # Or just take the last one in the list (often appended).
                screen = screens[0] 
                if "name" in screen:
                     # name: projects/.../screens/ID
                     latest_screen_id = screen["name"].split("/")[-1]
            
            if latest_screen_id:
                print(f"Found Latest Screen ID: {latest_screen_id}")
                print("Fetching screen code...")
                
                code_resp = run_rpc(process, "tools/call", {
                    "name": "fetch_screen_code",
                    "arguments": {
                        "projectId": target_project_id,
                        "screenId": latest_screen_id
                    }
                })
                
                if code_resp and "result" in code_resp:
                    content_list = code_resp["result"].get("content", [])
                    if content_list and content_list[0]["type"] == "text":
                        html_code = content_list[0]["text"]
                        
                        output_path = "stitch/designs/babylog_generated.html"
                        os.makedirs(os.path.dirname(output_path), exist_ok=True)
                        with open(output_path, "w") as f:
                            f.write(html_code)
                        print(f"Saved generated code to {output_path}")
                else:
                    print(f"Error fetching code: {code_resp}")
            else:
                print("No screens found in project.")
        
    except Exception as e:
        print(f"Exception: {e}")
    finally:
        process.stdin.close()
        process.wait()

if __name__ == "__main__":
    main()
