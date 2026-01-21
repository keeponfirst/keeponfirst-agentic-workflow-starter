---
name: keeponfirst-agentic-workflow
description: "KeepOnFirst multi-agent development workflow (Antigravity + Nano Banana + Jules). Use ONLY when user explicitly mentions: 'KOF workflow', 'KOF agentic', 'keeponfirst workflow', 'keeponfirst agentic', or '/kof'. This is a specific workflow methodology, not a generic agentic pattern."
---

# Agentic Workflow Skill

A 5-phase development workflow that coordinates multiple AI agents to deliver complete features.

## Agent Roles

| Agent | Role | Tool |
|-------|------|------|
| **Antigravity** | Orchestrator - plans, reviews, releases | This AI |
| **Nano Banana** | Asset Generator - creates images | External Tool |
| **Jules** | Cloud Coder - implements code in background | `jules` CLI |

## Prerequisites Check

Before starting, verify CLI tools are installed and authenticated:

```bash
# Check Jules
jules --version && jules remote list
```

**If auth fails**: Ask user to run `jules auth login`.

## 5-Phase Workflow

### Phase 1: PLAN

Create a plan file with:
- Feature overview
- Technical design
- Asset requirements (for Nano Banana)
- Code tasks (for Jules)
- Acceptance criteria

```markdown
# plans/<feature_name>.md

## Feature Overview
[What this feature does]

## Technical Design
[How it will be implemented]

## Asset Requirements (Nano Banana)
| Filename | Size | Purpose |
|----------|------|---------|

## Code Tasks (Jules)
1. [Task 1]
2. [Task 2]

## Acceptance Criteria
- [ ] Criterion 1
- [ ] Criterion 2
```

**Wait for user approval before proceeding.**

---

### Phase 2A: PROMPT DESIGN (Antigravity)

If assets are needed, Antigravity creates detailed prompts for Nano Banana:

1. **Create prompt files** in `nanobanana/queue/`:
   ```markdown
   # nanobanana/queue/<asset-name>.prompt.md

   ## Asset Information
   - **Filename**: hero-illustration.png
   - **Size**: 1200x630
   - **Purpose**: Landing page hero image
   - **Target**: assets/generated/heroes/

   ## Prompt
   A modern, minimalist illustration showing [detailed description].
   The color palette should use [specific colors].
   Style: [specific style instructions].
   Mood: [emotional tone].

   ## Acceptance Criteria
   - [ ] High resolution, no artifacts
   - [ ] Matches brand colors
   - [ ] Works on light/dark backgrounds
   ```

2. **Proceed to Phase 2B** for browser-based generation

**Prompt Design Principles**:
- Explicit, detailed descriptions
- Include style, mood, and color guidance
- Specify exact dimensions and format
- Define acceptance criteria upfront

---

### Phase 2B: BROWSER GENERATION (Antigravity + Gemini Web)

> 🌐 **Hybrid Flow**: Antigravity automates Gemini web UI for image generation

**Pre-requisite**: **Interactive Login Required**. Since Antigravity starts a fresh browser instance, you may need to log in to Google within that window on the first run.

1. **Open Gemini in browser**:
   ```
   browser_subagent → Navigate to gemini.google.com
   ```

2. **Check login status**:
   - If logged in → Continue to step 3
   - **If NOT logged in** → Antigravity pauses. User logs in manually in the open window. Then resume.

3. **Submit prompt**:
   - Read prompt from `nanobanana/queue/*.md`
   - Type prompt in Gemini chat input
   - Wait for image generation (30-60 seconds)

4. **Save generated image**:
   - Use `capture_browser_screenshot` with element targeting to capture the image
   - Copy captured image to `assets/generated/` directory
   - Note: Direct URL download (curl) doesn't work due to 403/CORS restrictions

5. **Handle errors**:
   - If generation fails → Retry with modified prompt
   - If timeout → Notify user

**Fallback**: If browser automation fails, revert to manual:
- User copies prompt to Gemini manually
- Downloads image to `assets/generated/`
- Tells Antigravity: "圖產好了" or "/kof resume"

---

### Phase 2C: ASSET VALIDATION (Antigravity)

After images are generated:

1. **Verify images exist**:
   ```bash
   ls -la assets/generated/
   ```

2. **Validate file integrity**:
   - File size > 0
   - Correct format (PNG/JPEG)
   - Dimensions match spec

3. **Update prompt status**:
   ```bash
   mv nanobanana/queue/<asset>.prompt.md nanobanana/completed/
   ```

4. **Record in plan file**:
   ```markdown
   ## Phase 2 ASSETS ✓
   - [x] hero-image.png - Generated via Gemini (Browser)
   - [x] app-icon.png - Generated via [tool used]
   ```

5. **Proceed to Phase 3**

**Skip Phase 2 entirely if no assets needed.**

---

### Phase 3: CODE (Jules)

1. **Create task file**:
   ```bash
   # jules/tasks/<task_name>.md
   ```

2. **Submit to Jules**:
   ```bash
   jules new --repo <owner/repo> "$(cat jules/tasks/<task>.md)"
   ```
   Note the session ID from output.

3. **Start background watcher** (see [watcher.md](references/watcher.md)):
   ```bash
   ./scripts/agent.sh watch <session_id>
   ```
   This monitors Jules and auto-notifies when complete.

4. **Wait for completion** - watcher will ping when done.

5. **Handle failures**: If Jules produces empty files, use retry mechanism.

---

### Phase 4: REVIEW

1. Check changes:
   ```bash
   git diff
   ```

2. Verify UI in browser (if applicable)

3. Confirm acceptance criteria are met

4. If issues found, return to Phase 3

---

### Phase 5: RELEASE

1. Stage changes:
   ```bash
   git add -A && git status
   ```

2. Commit with workflow metadata:
   ```bash
   git commit -m "feat: <feature name>
   
   ## Workflow Executed
   - Phase 1 PLAN: plans/<feature>.md
   - Phase 2 ASSETS: <assets created or N/A>
   - Phase 3 CODE: Jules session <ID>
   - Phase 4 REVIEW: Verified
   - Phase 5 RELEASE: This commit"
   ```

3. Push:
   ```bash
   git push
   ```

---

## Quick Reference

| Phase | Action | Agent |
|-------|--------|-------|
| PLAN | Create spec, get approval | Antigravity |
| 2A: PROMPT | Design image prompts | Antigravity |
| 2B: BROWSER | Generate images via Gemini web | Antigravity + User |
| 2C: VALIDATE | Verify assets | Antigravity |
| CODE | Submit task, monitor | Jules |
| REVIEW | Verify changes | Antigravity |
| RELEASE | Commit and push | Antigravity |

## Trigger Keywords

Activate this workflow ONLY when user says:
- "/kof"
- "KOF workflow"
- "KOF agentic"
- "keeponfirst workflow"
- "keeponfirst agentic"
- "用 KOF 開發..."

## Resume Keywords

If browser automation fails and user completes generation manually:
- "/kof resume"
- "圖產好了"
- "圖產好了，繼續 Phase 2C"
- "assets ready"

## Important Notes

- Never skip phases
- Phase 2 (ASSETS) is optional for code-only features
- Phase 2B requires Google login (one-time setup)
- If browser automation fails, fallback to manual mode
- Update plan file status after each phase
- Watch command runs in background - returns immediately

