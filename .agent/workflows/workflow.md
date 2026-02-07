---
description: 使用 Agentic Workflow 開發新功能（INSIGHTS → PLAN → WIREFRAME → ASSETS → DESIGN → CODE → REVIEW → RELEASE）。v2 版本強化 UI 品質控制。
---

# Agentic Workflow 開發流程 (v2)

當用戶要求開發新功能時，請按照以下 Pipeline 執行：

```
INSIGHTS(0) → PLAN(1) → WIREFRAME GATE(1.5) → ASSETS(2) → DESIGN(2.5) → CODE(3) → REVIEW(4) → RELEASE(5)
```

**說明**：
- UI 任務：必須走完整流程
- 非 UI 任務：可跳過 Phase 0, 1.5, 2.5，但需在 PLAN 註明原因

---

## Toolchain Readiness Checklist (Phase 0 前)

- [ ] Git 狀態可用
- [ ] Orchestrator 可用（Antigravity / Codex）
- [ ] 設計工具可用（Stitch MCP）
- [ ] 資產工具可用（Nano Banana MCP）
- [ ] Code Executor 決定（Jules 或 Codex）
- [ ] 專案執行命令已確認

---

## Phase 0: INSIGHTS

執行者：Orchestrator  
輸出：`research/<feature>.md`

> 純邏輯任務可跳過，但需在 PLAN 註明。

必含：
1. 使用情境與痛點
2. 類似產品觀察
3. 反模式清單
4. 三種視覺方向（A/B/C）
5. 建議採用方向

Human Gate：
- [ ] 同意主問題定義
- [ ] 同意視覺方向（A/B/C）

---

## Phase 1: PLAN

執行者：Orchestrator  
輸出：`plans/<feature>.md`

必含：
1. 功能範圍（In/Out）
2. 技術設計
3. 任務拆解
4. 驗收標準
5. Decision Snapshot

Human Gate：
- [ ] Scope
- [ ] Data Model
- [ ] Risk/Compliance
- [ ] 是否進入 Wireframe Gate

---

## Phase 1.5: WIREFRAME GATE

執行者：Orchestrator  
輸出：
- `wireframes/<feature>_A.md`
- `wireframes/<feature>_B.md`
- `wireframes/<feature>_decision.md`

> 純邏輯任務可跳過。

Human Gate：
- [ ] 選擇 A/B（或要求重做）
- [ ] 確認關鍵互動

---

## Phase 2: ASSETS

執行者：Orchestrator  
輸出：`assets/generated/<feature>/...`

### 選項 A：產生 Prompt 檔案（預設）

在 `nanobanana/queue/` 建立 `.prompt.md` 檔案，供手動或瀏覽器自動化執行：
```markdown
---
output_path: assets/generated/<feature>/hero.png
aspect_ratio: 16:9
---

# Hero Image

Create a modern illustration showing...
```

### 選項 B：使用 Nano Banana MCP（可選）

> ⚠️ Gemini API Free Tier 不支援產圖，需付費 Key。

```javascript
nanobanana_generate_image({
  prompt: "...",
  output_path: "assets/generated/<feature>/hero.png",
  model: "gemini-2.5-flash-image",
  aspect_ratio: "16:9"
})
```

---

## Phase 2.5: DESIGN (Stitch)

執行者：Stitch MCP  
輸出：`stitch/designs/<feature>/`

### Phase 2.5-A: Structured Prompt Generation

> 目標：在呼叫 Stitch 之前，先建立絕對的設計基準。

1. **分析需求**：解構使用者的產品構想
2. **定義 Design DNA** (存入 `design_dna.json`)：
   - `visual_vibe`: 風格關鍵字 (e.g., "Soft Warmth", "Organic Modernism")
   - `color_palette`: 精確 HEX Code (Primary, Secondary, Background, Surface) + **禁用色 (Negative Constraints)**
   - `components`: 圓角 (Radius)、陰影 (Shadows)、字體 (Typography)
3. **產出 Master Prompt**：包含所有 DNA 的全域描述
4. **產出 Screen Prompts**：每個畫面獨立 Prompt，強制繼承 Design DNA

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

**Artifacts**: `design_dna.json`, `master_prompt.md`, `screen_*.png`, `screen_*.html`, `audit_log.md`

Design Verified Checklist：
- [ ] Design DNA 符合
- [ ] 一致性通過
- [ ] CTA 層級清楚
- [ ] 空狀態與錯誤狀態有定義

---

## Phase 3: CODE

執行者：Jules（預設）或 Codex

// turbo
1. 在 `jules/tasks/` 建立任務檔案

// turbo
2. 使用 `jules new --repo <repo> "$(cat jules/tasks/<task>.md)"` 提交

// turbo
3. 執行 `./scripts/agent.sh watch <session_id>` 監控

4. 等待完成後進入 REVIEW

---

## Phase 4: REVIEW

執行者：Orchestrator

> ⚠️ REVIEW 只做「bug/偏差修正」，新功能回 PLAN。

1. `git diff` 檢查變更
2. 瀏覽器驗證 UI
3. 確認符合驗收標準

Review 結果標記：
- ✅ 修正完成
- ⚠️ 未解決
- 🔴 遺留風險

---

## Phase 5: RELEASE

// turbo
1. `git add -A && git status`

// turbo
2. Commit with workflow metadata:

```bash
git commit -m "feat: <功能名稱>

## Workflow Executed
- Phase 0 INSIGHTS: research/<feature>.md
- Phase 1 PLAN: plans/<feature>.md
- Phase 1.5 WIREFRAME: wireframes/<feature>_decision.md
- Phase 2 ASSETS: assets/generated/<feature>/
- Phase 2.5 DESIGN: stitch/designs/<feature>/
- Phase 3 CODE: Jules <ID>
- Phase 4 REVIEW: Verified
- Phase 5 RELEASE: This commit"
```

// turbo
3. `git push`

---

## 觸發關鍵字

- 「/workflow」
- 「按照 agentic workflow...」
- 「使用 workflow 開發...」
- 「幫我規劃並實作...」

## Resume Keywords

- "/kof resume"
- "圖產好了"
- "assets ready"
