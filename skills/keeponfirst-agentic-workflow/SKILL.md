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

1. Create `plans/<feature_name>.md`
2. Define:
   - Feature Overview
   - Technical Design
   - Asset Requirements (for Nano Banana)
   - Code Tasks (for Jules)
   - Acceptance Criteria
3. **Wait for user approval.**

#### Decision Snapshot
Mandatory at the end of every `plans/<feature>.md`:

```markdown
## Decision Snapshot

| Item | Content |
|------|---------|
| Feature Name | `<feature_name>` |
| Decision Time | `YYYY-MM-DD HH:MM` |
| Approved Scope | 1. ... 2. ... |
| Rejected Items | - ... |
| Human Gate Results | ✅ Scope / ✅ Style / ... |
| Open Questions | ⚠️ Cannot proceed if any |
```

#### Human Gate Template
User approval must use the fixed template (`templates/human_gate_template.md`):
- [ ] **Scope**: Agree/Disagree
- [ ] **Visual Style**: Agree/Disagree
- [ ] **Data Model**: Agree/Disagree
- [ ] **Risk/Compliance**: Agree/Disagree

---

### Phase 2: ASSETS (Browser Generation)

**Agent**: Nano Banana (via Gemini CLI / Browser)

1. Create prompt files in `nanobanana/queue/`
2. **Hybrid Flow**:
   - Antigravity opens Gemini Web in browser
   - Checks login (pauses if not logged in)
   - Submits prompt & captures screenshot to `assets/generated/`
3. Validate assets and move prompt to `nanobanana/completed/`

**Fallback**: If automation fails, user generates manually and says "/kof resume".

---

### Phase 2.5: DESIGN (Optional)

**Default**: Stitch (Google Ecosystem)
**Optional**: Pencil (Mobile Apps)

#### Option A: Stitch (Default)
1. Create design task in `stitch/queue/<feature>.md`
2. Use Stitch MCP tools (`generate_screen_from_text`) to create UI
3. **Artifact Contract**: Save to `stitch/designs/<feature>/`
   - `tokens.json` (Required: colors, typography, spacing, cornerRadius)
   - `screen_main.png`
   - `screen_main.html`
   - `screen_main.meta.json`
4. **Stitch Clean Room**:
   - List elements to delete/ignore (e.g., FAB, extra cards)
   - Rule: HTML structure > Screenshot visual (unless flagged)

#### Design Verified Checklist
Before moving to CODE:
- [ ] Light/Dark Mode variants exist (if applicable)
- [ ] Core components ready (headers, cards, empty states)
- [ ] Out-of-scope elements listed for deletion

---

### Phase 3: CODE

**Default**: Jules CLI (Google Ecosystem, Cloud Async)
**Optional**: Codex App & CLI (Local)

#### Input Handover
If Phase 2.5 used, explicitly list design artifacts in `jules/tasks/<task>.md` Inputs.

#### Option A: Jules CLI (Default)
1. Create task file in `jules/tasks/`
2. Submit: `jules new --repo ... "$(cat task.md)"`
3. **Watch**: `./scripts/agent.sh watch <session_id>`
   - Auto-polls status
   - Auto-applies changes
   - Auto-wakes Antigravity for Review

#### Option B: Codex App & CLI (Optional)
1. Prepare task file
2. Execute: `codex execute --task "jules/tasks/<task>.md"`
3. Codex modifies local files directly

---

### Phase 4: REVIEW

> **Rule**: Bug fixes & deviations ONLY. Scope changes must return to Phase 1.

1. `git diff` to check changes
2. Verify UI in browser
3. Check Acceptance Criteria
4. **Review Results**:
   - ✅ Fixed
   - ⚠️ Unresolved (Reason)
   - 🔴 Residual Risk

---

### Phase 5: RELEASE

#### Release Snapshot
Mandatory before commit:

```markdown
## Release Snapshot

| Item | Status |
|------|--------|
| Completed Items | 1. ... |
| Uncompleted Items | - ... (Reason) |
| Known Limitations | - ... |
| Next Steps | - ... |
```

#### Execute Release
1. `git add -A`
2. Commit with workflow metadata:
   ```bash
   git commit -m "feat: <feature>

   ## Workflow Executed
   - Phase 1 PLAN: plans/<feature>.md
   - Phase 2 ASSETS: ...
   - Phase 2.5 DESIGN: Stitch/Pencil
   - Phase 3 CODE: Jules <ID>
   - Phase 4 REVIEW: Verified
   - Phase 5 RELEASE: Snapshot included"
   ```
3. `git push`

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

