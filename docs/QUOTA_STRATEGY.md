# Quota 控制策略

這份文件說明如何控制各工具的 quota 消耗，避免「用到一半額度沒了」的窘境。

---

## Gemini CLI Quota

### 現況

Gemini CLI 的額度會受 **Google 訂閱等級影響**，但即使訂閱 Gemini Pro，若同時進行大量開發與產圖，仍可能觸發上限。這正是本 workflow 將「開發任務」分配給 Jules 的原因。

### Nano Banana 模型

> **Nano Banana** 是 Google Gemini 的圖像生成模型（Gemini 2.5 Flash Image），專為高效率、低延遲的圖像生成任務設計。

核心原則：**一次只產一張圖**

#### 使用策略

1. **一次只產一張圖**：避免批次產圖耗盡 quota
2. **使用明確、可重複的 prompt 模板**：降低重試成本
3. **佇列化執行（queue-based）**：逐一產生、可中斷、可追溯

#### 實作方式

```bash
# ❌ 錯誤：一次產多張
gemini generate "產生 5 張 icons"

# ✅ 正確：分開產
gemini generate "產生 1 張 home icon"
# 確認品質
gemini generate "產生 1 張 settings icon"  
# 確認品質
# ...
```

#### 佇列化執行

1. Prompt 放入 `nanobanana/queue/`
2. 逐一執行
3. 產出放入 `assets/generated/`
4. 確認後刪除 queue 中的 prompt

### 每日配額監控

Gemini CLI 目前沒有標準的 Quota 查詢指令，最準確的方式是：

1. 開啟 [Google AI Studio](https://aistudio.google.com/)
2. 在 Settings 或 Dashboard 查看 API 使用量

### 降級策略

當 quota 快用完時：

1. **暫停產圖任務**：等到明天額度刷新
2. **降低品質**：使用較低解析度
3. **使用快取**：確認是否有已產過的類似圖

---

## Jules Task 上限

### 現況

Jules 的每日任務上限與 **Google 訂閱等級直接相關**。

> **參考值**：在 Gemini Pro 訂閱下，作者實際經驗約為每日 100 tasks。此數字僅供參考，並非官方保證值，可能隨訂閱方案或政策調整而變動。

### 節流策略

#### 1. 任務合併

把相關的小任務合併成一個：

```markdown
# ❌ 5 個 tasks
- Task 1: 建立 Button component
- Task 2: 建立 Input component  
- Task 3: 建立 Card component
- Task 4: 建立 Modal component
- Task 5: 建立 Toast component

# ✅ 1 個 task
- Task 1: 建立 UI 元件庫（Button, Input, Card, Modal, Toast）
```

#### 2. 批次提交

把一天要做的任務集中在早上提交，讓 Jules 有一整天執行。

#### 3. 品質把關

避免「提交 → 發現問題 → 重新提交」的循環：

- 任務描述要清楚
- 包含驗收條件
- 提供足夠的 context

### 任務優先級

```
High   ─┬─ 阻礙進度的 bugfix
        │
Medium ─┼─ 新功能實作
        │
Low    ─┴─ 重構、優化
```

先做 High，quota 有剩再做 Low。

### 監控與預警

建議建立簡單的追蹤：

```bash
# jules/tasks_log.md
## 2024-01-15
- [x] UI 元件庫 (1 task)
- [x] API 整合 (1 task)
- [ ] 測試 (pending)
Daily total: 2/100
```

---

## 整體策略

### 每日節奏建議

| 時間 | 動作 |
|------|------|
| 早上 | 確認 quota，提交 Jules tasks |
| 午間 | Gemini CLI 產圖（Nano Banana） |
| 傍晚 | Review Jules 產出 |
| 晚上 | 規劃明日任務 |

### 週間節奏建議

| 日 | 重點 |
|----|------|
| 週一 | 規劃本週任務，大量提交 |
| 週二-四 | 執行與迭代 |
| 週五 | Review、Release |
| 週末 | 休息（讓 quota 刷新） |

### 緊急情況

如果 quota 真的不夠：

1. **付費升級**：最直接的解法
2. **延後非緊急任務**
3. **手動執行**：自己寫 code 代替 AI

---

## 配額追蹤模板

```markdown
# Quota Tracker

## Gemini CLI
- Daily limit: ~30 images (估計)
- Today used: 5
- Remaining: ~25

## Jules
- Daily limit: 100 tasks
- Today used: 12
- Remaining: 88

## Notes
- 週三可能需要產 20 張 icon，提前保留 quota
```

把這個模板放在專案根目錄，每日更新。
