#!/usr/bin/env python3
import json
import os
import subprocess
import sys
from pathlib import Path

# Configuration
MCP_CONFIG_PATH = Path(os.path.expanduser("~/.gemini/antigravity/mcp_config.json"))
STITCH_MCP_URL = "https://stitch.googleapis.com/mcp"

def check_gcloud_installed():
    """Check if gcloud CLI is installed."""
    if subprocess.call(["which", "gcloud"], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL) != 0:
        print("Error: gcloud CLI is not installed.")
        print("Please install it: https://cloud.google.com/sdk/docs/install")
        sys.exit(1)

def get_gcloud_token():
    """Get a fresh access token from gcloud."""
    try:
        # Check if logged in first to avoid hanging on prompt
        # We can check account list. If empty, not logged in.
        # But `auth print-access-token` usually errors if not logged in.
        result = subprocess.run(
            ["gcloud", "auth", "print-access-token"],
            capture_output=True,
            text=True,
            check=True
        )
        return result.stdout.strip()
    except subprocess.CalledProcessError as e:
        print(f"Error getting gcloud token: {e.stderr}")
        print("Please run 'gcloud auth login' and 'gcloud auth application-default login' first.")
        sys.exit(1)

def get_project_id():
    """Get the current Google Cloud Project ID."""
    try:
        result = subprocess.run(
            ["gcloud", "config", "get-value", "project"],
            capture_output=True,
            text=True,
            check=True
        )
        project_id = result.stdout.strip()
        if not project_id:
            print("Error: No Google Cloud Project set.")
            print("Please run 'gcloud config set project <PROJECT_ID>'")
            sys.exit(1)
        return project_id
    except subprocess.CalledProcessError as e:
        print(f"Error getting project ID: {e.stderr}")
        sys.exit(1)

def update_mcp_config(token, project_id):
    """Update the MCP configuration file with Stitch settings."""
    if not MCP_CONFIG_PATH.exists():
        print(f"Error: MCP config not found at {MCP_CONFIG_PATH}")
        sys.exit(1)

    try:
        with open(MCP_CONFIG_PATH, 'r') as f:
            config = json.load(f)

        # Initialize mcpServers if missing
        if "mcpServers" not in config:
            config["mcpServers"] = {}

        # Update or Add Stitch configuration
        config["mcpServers"]["stitch"] = {
            "url": STITCH_MCP_URL,
            "headers": {
                "Authorization": f"Bearer {token}",
                "X-Goog-User-Project": project_id
            }
        }

        with open(MCP_CONFIG_PATH, 'w') as f:
            json.dump(config, f, indent=4)

        # Set restrictive file permissions (owner read/write only)
        os.chmod(MCP_CONFIG_PATH, 0o600)

        print(f"✓ Updated Stitch MCP config in {MCP_CONFIG_PATH}")
        print(f"  Project: {project_id}")
        print(f"  File permissions: 600 (owner read/write only)")
        
    except Exception as e:
        print(f"Error updating config: {e}")
        sys.exit(1)

def main():
    print("Stitch MCP Authentication Setup")
    print("-------------------------------")
    
    check_gcloud_installed()
    
    print("Getting access token...")
    token = get_gcloud_token()
    
    print("Getting project ID...")
    project_id = get_project_id()
    
    print(f"Updating configuration for project: {project_id}")
    update_mcp_config(token, project_id)
    
    print("\n" + "="*50)
    print("Setup complete! You can now use Stitch MCP tools.")
    print("="*50)
    print("\n⚠️  Security Notes:")
    print("  - The access token is stored in plain text in the config file")
    print("  - File permissions have been set to 600 (owner only)")
    print("  - Token expires in ~1 hour - run this script again when it expires")
    print("  - Do NOT commit the config file to version control")

if __name__ == "__main__":
    main()
