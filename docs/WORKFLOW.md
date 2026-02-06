# Standard Workflow (v2)

此版本在原本主幹 `PLAN → ASSETS → DESIGN → CODE → REVIEW → RELEASE` 之外，
新增兩個前置品質閘門，避免 UI 結果過於模板化：

1. `Phase 0: INSIGHTS`（市場洞察與視覺方向收斂）
2. `Phase 1.5: WIREFRAME GATE`（低保真線框確認）

---

## Pipeline

```text
INSIGHTS(0) → PLAN(1) → WIREFRAME GATE(1.5) → ASSETS(2) → DESIGN(2.5) → CODE(3) → REVIEW(4) → RELEASE(5)
```

說明：

- UI 任務：必須走完整流程。
- 非 UI 任務：可跳過 `0`, `1.5` 與 `2.5`，但需在 PLAN 註明原因。
- 每個階段都要有可追溯產物（artifact）。

---

## Global Rules

1. 不可跳 Phase。
2. 不可跨過 Human Gate。
3. REVIEW 僅修 bug 與偏差，不得偷偷擴 scope。
4. 所有決策都需回寫到 `plans/<feature>.md`。
5. Stitch 輸出採兩段式（Two-Pass），不做 one-shot 定稿。

---

## Toolchain Readiness Checklist (在 Phase 0 前完成)

- [ ] Git 狀態可用（branch 與變更狀態清楚）
- [ ] Orchestrator 可用（Antigravity / Codex）
- [ ] 設計工具可用（Stitch MCP）
- [ ] 資產工具可用（Nano Banana MCP）
- [ ] Code Executor 決定（Jules 或 Codex）
- [ ] 專案執行命令已確認（build/test/lint 任一最小可驗證命令）
- [ ] 若有雲端工具，登入與權限已確認

---

## Phase 0: INSIGHTS

執行者：Orchestrator  
輸入：需求描述、目標使用者、平台限制  
輸出：`research/<feature>.md`

> **Note**: 純邏輯任務（無 UI）可跳過此階段，但需在 PLAN 註明。

必含內容：

1. 使用情境與痛點（Jobs-to-be-done）
2. 類似產品觀察（interaction pattern，不抄品牌）
3. 反模式清單（這次要避免）
4. 三種視覺方向（A/B/C）
5. 建議採用方向與理由

Human Gate：

- [ ] 同意主問題定義
- [ ] 同意視覺方向候選集合（A/B/C）

---

## Phase 1: PLAN

執行者：Orchestrator  
輸入：需求 + `research/<feature>.md`（若有）  
輸出：`plans/<feature>.md`

必含內容：

1. 功能範圍（In/Out）
2. 技術設計（資料流、模組、介面）
3. 任務拆解（可執行）
4. 驗收標準（可測試）
5. 風險與替代方案
6. Decision Snapshot

Human Gate：

- [ ] Scope
- [ ] Data Model
- [ ] Risk/Compliance
- [ ] 是否進入 Wireframe Gate（UI 任務必須）

---

## Phase 1.5: WIREFRAME GATE

執行者：Orchestrator（可搭配 Stitch 低保真輸出）  
輸入：`plans/<feature>.md` + `research/<feature>.md`  
輸出：

- `wireframes/<feature>_A.md`
- `wireframes/<feature>_B.md`
- `wireframes/<feature>_decision.md`

> **Note**: 純邏輯任務可跳過此階段。

規則：

1. 先比結構，不比視覺皮膚。
2. 每版需標示資訊階層與主要操作路徑。
3. 明確列出「單手操作區域」與「關鍵 CTA」。

Human Gate：

- [ ] 選擇 A/B（或要求重做）
- [ ] 確認不可缺少的關鍵互動

---

## Phase 2: ASSETS

執行者：Nano Banana MCP  
輸入：Plan 的資產清單 + Wireframe 決策  
輸出：`assets/generated/<feature>/...`

> **⚠️ 注意：Gemini API Free Tier 不支援產圖，需使用付費 API Key。**

規則：

1. 僅產生情緒資產與插圖，不主導版面結構。
2. 命名固定，避免 CODE 找不到檔案。
3. 每張圖要有用途說明與尺寸。

MCP 呼叫：
```javascript
nanobanana_generate_image({
  prompt: "...",
  output_path: "assets/generated/<feature>/hero.png",
  model: "gemini-2.5-flash-image",
  aspect_ratio: "16:9"
})
```

---

## Phase 2.5: DESIGN (Stitch Default)

執行者：Stitch MCP  
輸入：Wireframe 決策 + Assets + Plan  
輸出：`stitch/designs/<feature>/`

必要檔案：

- `tokens.json`
- `screen_main.png`
- `screen_main.html`
- `screen_main.meta.json`

### Stitch Two-Pass Strategy

**Pass 1（Structure Pass）**：
- 只描述資訊架構、版面區塊、元件關係
- 禁止加入大量風格形容詞
- Prompt 範例：
  ```
  Create a mobile screen layout for a baby feeding tracker.
  Structure: Header with baby name, main content area with feeding log list,
  floating action button for quick add. Information hierarchy: time > amount > type.
  Do NOT add decorative elements or brand colors yet.
  ```

**Pass 2（Style Pass）**：
- 在 Pass 1 穩定後再注入品牌語彙、色彩、字體、細節
- 至少產出 2 版供比較
- Prompt 範例：
  ```
  Apply a soft, nurturing visual style to the existing structure.
  Use pastel colors (soft pink, mint green), rounded corners (16px),
  friendly sans-serif typography. Add subtle shadows for depth.
  ```

### Design Verified Checklist

- [ ] 主要流程可掃讀
- [ ] CTA 層級清楚
- [ ] 空狀態與錯誤狀態有定義
- [ ] Light/Dark（若產品需要）
- [ ] Out-of-scope 元件列入刪除清單

---

## Phase 3: CODE

執行者：Jules（預設）或 Codex  
輸入：Plan + Design Artifacts + Assets  
輸出：可執行程式碼變更

規則：

1. 任務檔必列 Input Files（含 design/asset 實際路徑）
2. 未經核准不得擴 scope
3. 每次提交都需可編譯或最小可驗證

---

## Phase 4: REVIEW

執行者：Orchestrator  
輸入：Code Diff + 驗證結果  
輸出：Review 結論與修正單

規則：

1. 先列 findings，再給摘要
2. 僅處理缺陷與偏差
3. Scope 變更必須退回 PLAN

Review 結果標記：
- ✅ 修正完成
- ⚠️ 未解決（記錄原因）
- 🔴 遺留風險（需追蹤）

---

## Phase 5: RELEASE

執行者：Orchestrator  
輸入：Review 已通過  
輸出：Commit / Release Snapshot / 文件更新

必要內容：

- Release Snapshot（完成項、未完成項、已知限制、後續）
- 更新 `plans/<feature>.md` 狀態
- 文件同步（README/docs）

---

## Human Gate Minimum Set

每個功能至少要有以下核准：

1. Scope Gate（Phase 1）
2. Wireframe Gate（Phase 1.5，UI 任務必須）
3. Design Gate（Phase 2.5）
4. Release Readiness Gate（Phase 5）
