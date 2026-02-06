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

## Phase 2: ASSETS (Nano Banana MCP)

執行者：Nano Banana MCP  
輸出：`assets/generated/<feature>/...`

> ⚠️ Gemini API Free Tier 不支援產圖，需付費 Key。

使用：
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

### Stitch Two-Pass Strategy

**Pass 1（Structure）**：
- 只描述資訊架構、版面區塊
- 禁止加入風格形容詞

**Pass 2（Style）**：
- 注入品牌語彙、色彩、字體
- 至少產出 2 版比較

Design Verified Checklist：
- [ ] CTA 層級清楚
- [ ] 空狀態與錯誤狀態有定義
- [ ] Light/Dark（若需要）

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
