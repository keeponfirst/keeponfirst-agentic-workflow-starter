# Changelog

All notable changes to this workflow are documented here.

## v2.4 — 2026-05-17

| Enhancement | Description |
|-------------|-------------|
| **Stitch Vibe Design** | Phase 2.5 integrates Stitch's new Vibe Design mode for feeling-first UI generation |
| **Stitch Mode Guidance** | Flash Mode (ideation) vs Thinking Mode (final) documented |
| **Stitch Code Export** | Phase 3 can directly use Stitch's code export (React, Vue, Flutter, etc.) |
| **Parallel Jules Tasks** | Phase 3 CODE supports `--parallel` for concurrent sessions |
| **Jules Auto Repo Inference** | `--repo` flag optional when in repo directory |
| **Updated CLI Syntax** | `jules remote new` replaces `jules new` |
| **Updated Gemini Models** | `gemini-3.1-flash-image-preview` (default), `gemini-3-pro-image-preview` (paid) |
| **Free Tier Guidance** | Updated Nano Banana free tier limitations (April 2026 changes) |
| **Repo Cleanup** | BabyLog demo moved to `examples/`, experimental files cleaned |
| **MCP Config** | `.mcp.json.example` now includes both Stitch and Nano Banana |

## v2.3 — 2026-02-07

| Enhancement | Description |
|-------------|-------------|
| **Stitch 3-Phase Workflow** | Design DNA → Visual Audit → Refinement Loop |
| **Design DNA Contract** | `design_dna.json` with color palette, components, negative constraints |
| **Visual Audit & QA** | Consistency check, color accuracy, component integrity |
| **Refinement Loop** | Auto-generated correction prompts until pass |

## v2.2 — 2026-02-06

| Enhancement | Description |
|-------------|-------------|
| **Phase 0: INSIGHTS** | Market research & visual direction before planning |
| **Phase 1.5: WIREFRAME GATE** | Low-fidelity wireframe comparison before design |
| **Phase 2 ASSETS refactor** | Prompt files are now default; Nano Banana MCP is optional |
| **New directories** | `research/`, `wireframes/` for new phase outputs |
| **Prompt templates** | `prompts/antigravity/*.md` for insights, plan, wireframe_gate |

## v2.1 — 2026-02-05

| Enhancement | Description |
|-------------|-------------|
| **Documentation Sync** | Phase 5 RELEASE now includes documentation sync step |

## v2.0 — Core Checkpoints

| Enhancement | Description |
|-------------|-------------|
| **Decision Snapshot** | PLAN phase summary with approved scope & open questions |
| **Human Gate Template** | Structured approval (scope/style/data model/risk) |
| **Design Verified Checklist** | Light/Dark mode, core components, out-of-scope elements |
| **tokens.json Contract** | Design system tokens (colors, typography, spacing, cornerRadius) |
| **Stitch Clean Room** | Element deletion list + HTML vs. screenshot conflict notes |
| **REVIEW Scope Rule** | Bug fixes and deviation corrections only; scope changes return to PLAN |
| **Release Snapshot** | Acceptance items, known limitations, next steps |

## v1.0 — Initial Release

- PLAN → ASSETS → CODE → REVIEW → RELEASE pipeline
- Antigravity (orchestrator) + Nano Banana (assets) + Jules CLI (cloud coding)
- `agent.sh` task-preparation adapter with safe dry-run design
