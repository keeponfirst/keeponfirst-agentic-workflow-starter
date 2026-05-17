# OpenSpec + Superpowers 對照映射

本文件將 keeponfirst-agentic-workflow-starter 的 8-phase pipeline 對照至 OpenSpec 命令與 Superpowers 技能，供跨 repo 參考使用。

## Pipeline 對照表

| Phase | Workflow 階段 | OpenSpec 命令 | Superpowers 技能 | 產出物 |
|-------|--------------|---------------|-----------------|--------|
| 0 | INSIGHTS | `/opsx:explore` | `brainstorming` | `research/<feature>.md` |
| 1 | PLAN | `/opsx:new` | `writing-plans` | `proposal.md` + `specs/` + `design.md` |
| 1.5 | WIREFRAME GATE | — | `brainstorming` | `wireframes/<feature>_*.md` |
| 2 | ASSETS | — | — | `assets/generated/<feature>/` |
| 2.5 | DESIGN | — | — | `stitch/designs/<feature>/` |
| 3 | CODE | `/opsx:apply` | `executing-plans`, `test-driven-development`, `systematic-debugging` | 程式碼變更 |
| 4 | REVIEW | `/opsx:verify` | `verification-before-completion`, `requesting-code-review`, `receiving-code-review` | Review 結論 |
| 5 | RELEASE | `/opsx:archive` | `finishing-a-development-branch` | Commit + Release Snapshot |

## 詳細對應

### Phase 0: INSIGHTS → `/opsx:explore`

- OpenSpec 的 `explore` 命令可掃描現有 specs 和 changes，為新功能提供脈絡
- Superpowers 的 `brainstorming` 技能提供結構化腦力激盪框架
- **差異**：Workflow INSIGHTS 強調市場洞察與視覺方向；OpenSpec explore 偏向技術規格探索

### Phase 1: PLAN → `/opsx:new`

- `/opsx:new` 建立完整的 change 結構：`proposal.md` → `specs/` → `design.md` → `tasks.md`
- 對應 Workflow PLAN 的必含內容：
  - 功能範圍 ↔ proposal.md
  - 技術設計 ↔ design.md
  - 任務拆解 ↔ tasks.md
  - 驗收標準 ↔ specs/
  - 風險與替代方案 ↔ design.md（備選方案段落）
- Superpowers `writing-plans` 提供計畫撰寫的紀律

### Phase 1.5–2.5: 設計階段（無 OpenSpec 對應）

- 這些階段著重 UI/UX 設計，OpenSpec 不直接覆蓋
- 可在 OpenSpec specs/ 中以 spec 形式記錄設計決策
- Superpowers 無專門設計技能，但 `brainstorming` 可用於方案比較

### Phase 3: CODE → `/opsx:apply`

- `/opsx:apply` 根據 `tasks.md` 逐步執行實作
- Superpowers 提供三個核心技能：
  - `executing-plans`：確保按計畫步驟進行
  - `test-driven-development`：先寫測試，再實作
  - `systematic-debugging`：遇到問題時系統化除錯
- 對應 Workflow CODE 的規則：「每次提交都需可編譯或最小可驗證」

### Phase 4: REVIEW → `/opsx:verify`

- `/opsx:verify` 對照 specs 驗證實作完整性
- Superpowers 提供：
  - `verification-before-completion`：完成前的系統化驗證
  - `requesting-code-review` / `receiving-code-review`：PR review 流程紀律
- 對應 Workflow REVIEW 的規則：「僅處理缺陷與偏差，scope 變更退回 PLAN」

### Phase 5: RELEASE → `/opsx:archive`

- `/opsx:archive` 歸檔已完成的 change，產出永久紀錄
- Superpowers `finishing-a-development-branch` 確保分支完成流程
- 對應 Workflow RELEASE 的必要內容：Release Snapshot + 文件同步

## 適用場景

| 任務類型 | 建議流程 |
|---------|---------|
| 純邏輯功能（無 UI） | Phase 1 → 3 → 4 → 5（跳過 0, 1.5, 2, 2.5），全程使用 OpenSpec |
| UI 功能 | 完整 8 phase，Phase 1 用 OpenSpec，Phase 1.5–2.5 用 Stitch/設計工具 |
| Bug fix | `/opsx:ff`（Fast-forward）直接建 change + 修復 + 歸檔 |
| 規格定義（無實作） | `/opsx:new` 只撰寫 proposal + specs，不進入 apply |

## Human Gate 與 OpenSpec 的關係

Workflow 定義 4 個必要 Human Gate：
1. **Scope Gate**（Phase 1）→ 對應 OpenSpec proposal.md 審核
2. **Wireframe Gate**（Phase 1.5）→ OpenSpec 不覆蓋
3. **Design Gate**（Phase 2.5）→ OpenSpec 不覆蓋
4. **Release Readiness**（Phase 5）→ 對應 `/opsx:verify` + `/opsx:archive`
