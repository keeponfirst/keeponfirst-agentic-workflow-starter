---
name: keeponfirst-agentic-workflow
description: "KeepOnFirst multi-agent development workflow v2.4 (Antigravity + Nano Banana + Stitch + Jules). Includes INSIGHTS, WIREFRAME GATE, Stitch Vibe Design, and parallel Jules tasks. Use ONLY when user explicitly mentions: 'KOF workflow', 'KOF agentic', 'keeponfirst workflow', 'keeponfirst agentic', or '/kof'."
---

# Agentic Workflow Skill (v2.4)

An 8-phase development workflow that coordinates multiple AI agents to deliver high-quality features, with enhanced UI quality controls and updated toolchain integration.

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
| **Nano Banana** | Asset Generator - creates images | MCP / Prompt Files |
| **Stitch** | UI Designer - generates screens (Vibe Design / Infinite Canvas) | MCP / Web |
| **Jules** | Cloud Coder - implements in background (parallel supported) | CLI |

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

## Phase 2: ASSETS

**Output**: `assets/generated/<feature>/`

### Option A: Generate Prompt Files (Default)

Create `.prompt.md` files in `nanobanana/queue/` for manual or browser-automated execution:
```markdown
---
output_path: assets/generated/<feature>/hero.png
aspect_ratio: 16:9
---

# Hero Image

Create a modern illustration showing...
```

### Option B: Use Nano Banana MCP (Optional)

> ⚠️ Gemini API Free Tier has strict quotas. Pro models are paid-only. Flash models may be available with rate limits.

```javascript
nanobanana_generate_image({
  prompt: "...",
  output_path: "assets/generated/<feature>/hero.png",
  model: "gemini-3.1-flash-image-preview",
  aspect_ratio: "16:9"
})
```

> **Models**: `gemini-3.1-flash-image-preview` (default, fast) | `gemini-3-pro-image-preview` (high quality, paid)

---

## Phase 2.5: DESIGN (Stitch)

**Output**: `stitch/designs/<feature>/`

> **Stitch Modes**: Flash Mode (fast iteration) | Thinking Mode (deep reasoning, final) | Vibe Design (describe feeling, not structure)

### Phase 2.5-A: Structured Prompt Generation

> Goal: establish an absolute design baseline BEFORE calling Stitch.

1. **Analyze requirements**: deconstruct the user's product concept
2. **Define the Design DNA** (save to `design_dna.json`):
   - `visual_vibe`: style keywords (e.g., "Soft Warmth", "Organic Modernism")
   - `color_palette`: exact HEX codes (Primary, Secondary, Background, Surface) + **forbidden colors (Negative Constraints)**
   - `components`: corner radius, shadows, typography
3. **Produce a Master Prompt**: a global description containing the full DNA
4. **Produce Screen Prompts**: one prompt per screen, each forced to inherit the Design DNA

> **Vibe Design alternative**: If you have a clear visual direction from INSIGHTS, use Stitch Vibe Design — describe business goals and desired feeling (e.g., "premium and minimalist, like Stripe") to generate design directions directly.

### Phase 2.5-B: Visual Audit & QA

> Goal: after Stitch produces output, audit it against the Design DNA.

**Consistency**:
- Navigation Bar: is the tab bar identical across all screens? (icon style, background color, height)
- Status Bar: is the safe area respected?

**Color Accuracy**:
- Is the background the exact specified HEX? (e.g., did beige silently become pure white?)
- Do any undefined colors appear?

**Component Integrity**:
- Sufficient button contrast? Text clearly readable?
- Illustration style unified? (no mixing 3D/2D)

### Phase 2.5-C: Refinement Loop

> Goal: when the audit finds problems, auto-generate correction prompts until it passes.

```
IF Pass → Final Output (proceed to Phase 3)
IF Fail → Refinement Loop:
  1. List concrete errors (e.g., "History screen nav bar ≠ Dashboard")
  2. Generate a Refinement Prompt (use strong directives: FORCE REPLACE, RESET BACKGROUND, UNIFY ICONS)
  3. Call Stitch again
  4. Return to Phase 2.5-B and re-audit
```

**Code Export**: Stitch now exports HTML/CSS, React, Vue.js, Angular, Flutter, SwiftUI. Phase 3 CODE can use exports as starting point.

**Artifacts**: `design_dna.json`, `master_prompt.md`, `screen_*.png`, `screen_*.html`, `audit_log.md`

**Final Checklist**: Design DNA compliance ✓, Consistency pass ✓, CTA hierarchy ✓, Empty/Error states ✓

---

## Phase 3: CODE

**Default**: Jules CLI (supports `--parallel` for concurrent sessions) | **Optional**: Codex

1. Create task in `jules/tasks/`
2. Submit: `jules remote new --repo ... "$(cat task.md)"` (omit `--repo` if in repo dir)
3. Watch: `./scripts/agent.sh watch <session_id>`
4. If Stitch produced code exports, reference them as Input Files

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
| 2 ASSETS | Generate images | Nano Banana MCP / Prompt Files |
| 2.5 DESIGN | Design DNA → Audit → Refine (Vibe Design optional) | Stitch MCP / Web |
| 3 CODE | Submit task, monitor (parallel supported) | Jules CLI |
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
