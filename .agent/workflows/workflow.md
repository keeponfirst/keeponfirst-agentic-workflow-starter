---
description: 使用 Agentic Workflow 開發新功能（PLAN → ASSETS → CODE → REVIEW → RELEASE）
---

# Agentic Workflow 開發流程

當用戶要求開發新功能時，請按照以下 5 個 Phase 執行：

## Phase 1: PLAN

1. 建立 `plans/<feature_name>.md` 規劃文件
2. 內容包含：
   - 功能概述
   - 技術設計
   - 素材需求（給 Gemini CLI Nano Banana）
   - 程式任務（給 Jules）
   - 驗收標準
3. 請用戶確認規劃

## Phase 2: ASSETS (Nano Banana)

如果有圖片需求：

1. 在 `nanobanana/queue/` 建立 prompt 檔案
2. 使用 `generate_image` tool 一張一張產生圖片
3. 將圖片複製到目標位置（如 `docs/xxx/assets/`）

**Nano Banana 原則**：
- 一次一張圖
- 明確描述
- 立即確認品質

## Phase 3: CODE (Jules)

// turbo
1. 在 `jules/tasks/` 建立任務檔案

// turbo
2. 使用 `jules new --repo <repo> "$(cat jules/tasks/<task>.md)"` 提交任務

// turbo
3. 執行 `./scripts/agent.sh watch <session_id>` 啟動背景監控

4. 等待 Jules 完成（監控會自動喚醒 Antigravity 進行 Review）

5. 如果 Jules 產出空檔案，使用 retry 機制重新提交

## Phase 4: REVIEW

1. 執行 `git diff` 檢查變更內容
2. 在瀏覽器中驗證 UI（如適用）
3. 確認符合驗收標準
4. 如有問題，回到 Phase 3 修正

## Phase 5: RELEASE

// turbo
1. `git add -A && git status` 確認變更

// turbo
2. 使用描述性 commit message：

```bash
git commit -m "feat: <功能名稱>

## Workflow Executed
- Phase 1 PLAN: <plan file>
- Phase 2 ASSETS: <assets created>
- Phase 3 CODE: Jules session ID
- Phase 4 REVIEW: Verified
- Phase 5 RELEASE: This commit"
```

// turbo
3. `git push`

---

## 觸發關鍵字

用戶說以下詞彙時，啟動此 workflow：

- "按照 agentic workflow..."
- "使用 workflow 開發..."
- "/workflow"
- "幫我規劃並實作..."

## 注意事項

- 不要跳過任何 Phase
- Phase 2 可能不需要（純邏輯功能）
- 每個 Phase 完成後更新 plans/<feature>.md 的狀態
- watch 命令會在背景執行，立即返回
