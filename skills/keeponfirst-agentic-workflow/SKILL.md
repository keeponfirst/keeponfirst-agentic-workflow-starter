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

### Phase 2: ASSETS (Nano Banana)

If assets are needed:

1. **Create prompt files** in `nanobanana/queue/`:
   ```markdown
   # nanobanana/queue/hero-image.md
   A modern, minimalist illustration of...
   ```

2. **Generate with Gemini CLI** (one at a time):
   ```bash
   # Check Gemini CLI is authenticated
   gemini --version
   
   # Generate each image
   gemini -p "$(cat nanobanana/queue/hero-image.md)" > assets/generated/hero-image.png
   ```

3. **Verify quality** and move to target location

**Nano Banana Principles**:
- One image at a time (avoid quota spikes)
- Explicit, detailed prompts
- Verify quality immediately
- Move completed prompts to `nanobanana/completed/`

**If Gemini CLI auth fails**: Run `gemini auth login`

**Skip this phase if no assets needed.**

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
| ASSETS | Generate images | Gemini CLI |
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

## Important Notes

- Never skip phases
- Phase 2 (ASSETS) is optional for code-only features
- Update plan file status after each phase
- Watch command runs in background - returns immediately
