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

> 目標：在呼叫 Stitch 之前，先建立絕對的設計基準。

1. **分析需求**：解構使用者的產品構想
2. **定義 Design DNA** (存入 `design_dna.json`)：
   - `visual_vibe`: 風格關鍵字 (e.g., "Soft Warmth", "Organic Modernism")
   - `color_palette`: 精確 HEX Code (Primary, Secondary, Background, Surface) + **禁用色 (Negative Constraints)**
   - `components`: 圓角 (Radius)、陰影 (Shadows)、字體 (Typography)
3. **產出 Master Prompt**：包含所有 DNA 的全域描述
4. **產出 Screen Prompts**：每個畫面獨立 Prompt，強制繼承 Design DNA

> **Vibe Design alternative**: If you have a clear visual direction from INSIGHTS, use Stitch Vibe Design — describe business goals and desired feeling (e.g., "premium and minimalist, like Stripe") to generate design directions directly.

### Phase 2.5-B: Visual Audit & QA

> 目標：Stitch 產出後，對照 Design DNA 進行視覺審查。

**一致性檢查 (Consistency)**：
- Navigation Bar：所有畫面 Tab Bar 樣式是否相同？(Icon 風格、背景色、高度)
- Status Bar：是否留出 Safe Area？

**色彩準確度 (Color Accuracy)**：
- 背景色是否為指定 HEX？(例：是否變成純白而非米色)
- 是否出現未定義顏色？

**元件完整性 (Component Integrity)**：
- 按鈕對比度足夠？文字清晰可讀？
- 插畫風格統一？(避免混用 3D/2D)

### Phase 2.5-C: Refinement Loop

> 目標：若審查發現問題，自動生成修正指令，直到通過為止。

```
IF Pass → Final Output (進入 Phase 3)
IF Fail → Refinement Loop：
  1. 列出具體錯誤 (e.g., "History screen nav bar ≠ Dashboard")
  2. 生成 Refinement Prompt (使用強指令：FORCE REPLACE, RESET BACKGROUND, UNIFY ICONS)
  3. 重新呼叫 Stitch
  4. 返回 Phase 2.5-B 再次審查
```

**Code Export**: Stitch now exports HTML/CSS, React, Vue.js, Angular, Flutter, SwiftUI. Phase 3 CODE can use exports as starting point.

**Artifacts**: `design_dna.json`, `master_prompt.md`, `screen_*.png`, `screen_*.html`, `audit_log.md`

**Final Checklist**: Design DNA 符合 ✓, 一致性通過 ✓, CTA hierarchy ✓, Empty/Error states ✓

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
