---
name: keeponfirst-agentic-workflow
description: "KeepOnFirst multi-agent development workflow (Antigravity + Gemini CLI + Jules). Use ONLY when user explicitly mentions: 'KOF workflow', 'KOF agentic', 'keeponfirst workflow', 'keeponfirst agentic', or '/kof'. This is a specific workflow methodology, not a generic agentic pattern."
---

# Agentic Workflow Skill

A 5-phase development workflow that coordinates multiple AI agents to deliver complete features.

## Agent Roles

| Agent | Role | Tool |
|-------|------|------|
| **Antigravity** | Orchestrator - plans, reviews, releases | This AI |
| **Gemini CLI** | Asset Generator (Nano Banana) - creates images | `gemini` CLI |
| **Jules** | Cloud Coder - implements code in background | `jules` CLI |

## Prerequisites Check

Before starting, verify CLI tools are installed and authenticated:

```bash
# Check Jules
jules --version && jules remote list

# Check Gemini CLI  
gemini --version
```

**If auth fails**: Ask user to run `jules auth login` or `gemini auth login`.

## 5-Phase Workflow

### Phase 1: PLAN

Create a plan file with:
- Feature overview
- Technical design
- Asset requirements (for Gemini CLI)
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

   ## Nano Banana Command
   /generate "<prompt>" --styles="photorealistic" --count=1

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

2. **Notify user** that prompts are ready for generation

**Prompt Design Principles**:
- Explicit, detailed descriptions
- Include style, mood, and color guidance
- Specify exact dimensions and format
- Define acceptance criteria upfront

---

### PAUSE: External Image Generation

> ⚠️ **ASYNC STEP**: Antigravity pauses here. User generates images externally.

**Option 1: Gemini CLI + Nano Banana** (when quota available)
```bash
source .env
gemini -y -e nanobanana "$(cat nanobanana/queue/hero-image.prompt.md)"
```

**Option 2: Nano Banana Web Tool**
1. Visit https://nano-banana.ai
2. Copy prompt content from `.prompt.md` file
3. Download generated image to `assets/generated/`

**Option 3: Alternative AI Tools**
- Midjourney, DALL-E, Stable Diffusion, Adobe Firefly

**To resume workflow**, tell Antigravity:
- "圖產好了，繼續 Phase 2B"
- "/kof resume"

---

### Phase 2B: ASSET VALIDATION (Antigravity)

When user reports images are ready:

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
   - [x] hero-image.png - Generated via Nano Banana
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
| PAUSE | Generate images externally | User / Nano Banana |
| 2B: VALIDATE | Verify assets | Antigravity |
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

After external image generation, resume with:
- "/kof resume"
- "圖產好了"
- "圖產好了，繼續 Phase 2B"
- "assets ready"

## Important Notes

- Never skip phases
- Phase 2 (ASSETS) is optional for code-only features
- Phase 2A → PAUSE → 2B is an async workflow (user generates images externally)
- Update plan file status after each phase
- Watch command runs in background - returns immediately

