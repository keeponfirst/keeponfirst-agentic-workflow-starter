---
name: keeponfirst-agentic-workflow
description: "KeepOnFirst multi-agent development workflow v2 (Antigravity + Nano Banana + Stitch + Jules). Includes INSIGHTS and WIREFRAME GATE phases for UI quality. Use ONLY when user explicitly mentions: 'KOF workflow', 'KOF agentic', 'keeponfirst workflow', 'keeponfirst agentic', or '/kof'."
---

# Agentic Workflow Skill (v2)

An 8-phase development workflow that coordinates multiple AI agents to deliver high-quality features, with enhanced UI quality controls.

## Pipeline

```
INSIGHTS(0) → PLAN(1) → WIREFRAME GATE(1.5) → ASSETS(2) → DESIGN(2.5) → CODE(3) → REVIEW(4) → RELEASE(5)
```

- **UI Tasks**: Full pipeline required
- **Logic-only Tasks**: Skip phases 0, 1.5, 2.5 (note in PLAN)

## Agent Roles

| Agent | Role | Tool |
|-------|------|------|
| **Antigravity** | Orchestrator - plans, reviews, releases | This AI |
| **Nano Banana** | Asset Generator - creates images | MCP |
| **Stitch** | UI Designer - generates screens | MCP |
| **Jules** | Cloud Coder - implements in background | CLI |

---

## Phase 0: INSIGHTS

**Output**: `research/<feature>.md`

> Skip for logic-only tasks (note in PLAN).

Required content:
1. User pain points (Jobs-to-be-done)
2. Similar patterns (3-5 examples)
3. Anti-patterns to avoid
4. Visual direction candidates (A/B/C)
5. Recommendation

**Human Gate**: Problem definition ✓, Visual direction (A/B/C) ✓

---

## Phase 1: PLAN

**Output**: `plans/<feature>.md`

Required content:
1. Scope (In/Out)
2. Technical Design
3. Task breakdown
4. Acceptance Criteria
5. Decision Snapshot

**Human Gate**: Scope ✓, Data Model ✓, Risk ✓, Enter Wireframe? ✓

---

## Phase 1.5: WIREFRAME GATE

**Output**: `wireframes/<feature>_A.md`, `wireframes/<feature>_B.md`, `wireframes/<feature>_decision.md`

> Skip for logic-only tasks.

Compare structure before style. Each version must include:
- Screen structure & info hierarchy
- Primary flow (shortest path)
- Tap map (thumb-zone analysis)

**Human Gate**: Select A/B/Redo ✓, Critical interactions ✓

---

## Phase 2: ASSETS (Nano Banana MCP)

**Output**: `assets/generated/<feature>/`

> ⚠️ Gemini API Free Tier does NOT support image generation. Paid key required.

```javascript
nanobanana_generate_image({
  prompt: "...",
  output_path: "assets/generated/<feature>/hero.png",
  model: "gemini-2.5-flash-image",
  aspect_ratio: "16:9"
})
```

---

## Phase 2.5: DESIGN (Stitch MCP)

**Output**: `stitch/designs/<feature>/`

### Stitch Two-Pass Strategy

**Pass 1 (Structure)**: Information architecture only. No decorative elements.

**Pass 2 (Style)**: Inject brand colors, typography, visual polish. Generate 2+ variants.

**Artifacts**: `tokens.json`, `screen_main.png`, `screen_main.html`, `screen_main.meta.json`

**Checklist**: CTA hierarchy ✓, Empty/Error states ✓, Light/Dark ✓

---

## Phase 3: CODE

**Default**: Jules CLI | **Optional**: Codex

1. Create task in `jules/tasks/`
2. Submit: `jules new --repo ... "$(cat task.md)"`
3. Watch: `./scripts/agent.sh watch <session_id>`

Input files must include design/asset paths.

---

## Phase 4: REVIEW

> Bug fixes & deviations ONLY. Scope changes → back to PLAN.

1. `git diff` to check changes
2. Verify UI in browser
3. Mark results: ✅ Fixed | ⚠️ Unresolved | 🔴 Risk

---

## Phase 5: RELEASE

1. `git add -A`
2. Commit with workflow metadata
3. `git push`

Include Release Snapshot: Completed items, Known limitations, Next steps.

---

## Quick Reference

| Phase | Action | Agent |
|-------|--------|-------|
| 0 INSIGHTS | Market research, visual direction | Orchestrator |
| 1 PLAN | Create spec, get approval | Orchestrator |
| 1.5 WIREFRAME | Low-fi comparison, select | Orchestrator |
| 2 ASSETS | Generate images | Nano Banana MCP |
| 2.5 DESIGN | Two-pass UI generation | Stitch MCP |
| 3 CODE | Submit task, monitor | Jules CLI |
| 4 REVIEW | Verify changes | Orchestrator |
| 5 RELEASE | Commit and push | Orchestrator |

## Trigger Keywords

- "/kof", "/workflow"
- "KOF workflow", "KOF agentic"
- "keeponfirst workflow"
- "用 KOF 開發..."

## Resume Keywords

- "/kof resume"
- "圖產好了"
- "assets ready"
