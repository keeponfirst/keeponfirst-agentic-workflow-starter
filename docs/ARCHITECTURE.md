# 架構演進

這份文件記錄這套 Agentic Workflow 的演進過程。

## 起點：訂閱 Gemini Pro

**2025 年 12 月**，我訂閱了 Gemini Pro，開始系統性研究 Google 生態系的 AI 工具：

- **Antigravity**：Agentic IDE
- **Gemini CLI**：本地終端機整合
- **Jules CLI**：雲端 AI coding assistant

> **重要背景**：本 workflow 的 quota 經驗值（如 Jules 每日任務數、Gemini CLI 產圖上限）皆基於 Gemini Pro 訂閱等級。不同訂閱方案的額度可能不同。

## 第一次嘗試：Antigravity + Gemini CLI

最初的想法很直接：用 Antigravity 做規劃，Gemini CLI 做執行。

**問題：Quota Limit**

```
Error: Rate limit exceeded. Please try again later.
```

即使訂閱了 Gemini Pro，若同時用 Gemini CLI 進行「完整開發 + 大量產圖」，仍然容易觸發 quota 上限。這促使我思考分工策略。

## 轉折點：發現 Jules

Jules 進入公開試用時，我注意到它的定位：

- 每日 100 tasks（此為 Gemini Pro 訂閱）
- 雲端執行，不佔本地資源
- 專注於程式碼任務

這讓我想到：**為什麼要用一個工具做所有事？**

於是我決定將「開發任務」移交給 Jules，Gemini CLI 則**僅保留做產圖**，大幅降低 quota 消耗。

## 解決方案：三角色分工

```
┌─────────────────────────────────────────────────────────┐
│                    Antigravity                          │
│                   (Orchestrator)                        │
│                                                         │
│  • 規劃功能                                              │
│  • 決定什麼任務給誰                                       │
│  • Review 產出                                          │
│  • 做 Release 決策                                       │
└────────────────────────┬────────────────────────────────┘
                         │
         ┌───────────────┴───────────────┐
         ▼                               ▼
┌─────────────────────┐       ┌─────────────────────┐
│     Gemini CLI      │       │       Jules         │
│   (Asset Generator) │       │  (Task Executor)    │
│                     │       │                     │
│ • 產 Icon           │       │ • 實作 UI 元件       │
│ • 產 Empty State    │       │ • 寫商業邏輯         │
│ • 產 Feature Hero   │       │ • 重構程式碼         │
│                     │       │                     │
│ Nano Banana 策略：   │       │ 每日 100 tasks      │
│ 一次只做一張         │       │                     │
└─────────────────────┘       └─────────────────────┘
```

## 使用 Nano Banana 產圖

> **Nano Banana** 是 Google Gemini 的圖像生成模型（Gemini 2.5 Flash Image），專為高效率、低延遲的圖像生成任務設計。

為了控制 Gemini CLI 使用 Nano Banana 產圖時的 quota 消耗，我採用以下策略：

1. **一次只產一張圖**：避免批次產圖耗盡 quota
2. **使用明確、可重複的 prompt 模板**：降低重試成本
3. **佇列化執行（queue-based）**：逐一產生、可中斷、可追溯

## 核心洞察

> **人不一定在場，任務也能前進。**

這套 workflow 的核心價值：

1. **非同步**：Jules 在雲端執行，我可以去做其他事
2. **分散風險**：不依賴單一工具的 quota
3. **可追溯**：所有 prompt 和 task 都有檔案留存
4. **可重現**：任何人都能用同樣的 prompts 重現流程

## 為什麼不用 X？

| 工具 | 為什麼不在這套 workflow 中 |
|------|---------------------------|
| ChatGPT | 有Codex CLI，但產圖能力還是Nano Banana較優 |
| Claude Code | ~~比較貴~~ |
| 其他 IDE 整合 | 這套 workflow 專注 Antigravity + Gemini + Jules |

這不是說其他工具不好，而是這套 workflow 刻意限縮範圍，專注於三個工具的協作。

---

## Orchestrator 層說明

### 概念定義

| 元件 | 角色 | 說明 |
|------|------|------|
| **Antigravity** | Orchestrator Implementation | 負責規劃、決策、Review 的 AI Agent |
| **agent.sh** | Orchestrator Adapter | CLI 層的統一入口，負責準備任務給各 Agent |

### 職責分離

```
┌──────────────────────────────────────────────────────┐
│  Orchestrator Layer                                  │
│  ┌────────────────┐    ┌────────────────┐           │
│  │  Antigravity   │ ←→ │   agent.sh     │           │
│  │ (規劃/決策)    │    │ (任務準備)     │           │
│  └────────────────┘    └────────────────┘           │
└──────────────────────────────────────────────────────┘
                         │
         ┌───────────────┴───────────────┐
         ▼                               ▼
┌─────────────────────┐       ┌─────────────────────┐
│     Gemini CLI      │       │       Jules         │
│   (Executor Agent)  │       │  (Executor Agent)   │
└─────────────────────┘       └─────────────────────┘
```

### Antigravity CLI (agy)

Antigravity 提供 CLI 工具，可透過指令喚醒 agent：

```bash
# 喚醒 Antigravity agent 並傳入 prompt
agy chat --mode agent "請 Review 這次的變更"

# 加入檔案作為 context
agy chat --mode agent --add-file jules/completed/123_completed.md "執行 code review"
```

`agent.sh watch` 命令在 Jules 完成後會自動呼叫：

```bash
agy chat --mode agent --add-file "$review_file" "Jules session 已完成，請進行 code review..."
```

這實現了 **Jules → Antigravity** 的自動化閉環。

### 理論上的可替換性

本 repo 的 Orchestrator 層理論上可以替換為其他工具：

- Cursor（Composer mode）
- Claude Code
- OpenCode
- 其他支援 agentic workflow 的工具

然而，**本 repo 的敘事與範例以 Antigravity 為主**，原因是：

1. Antigravity 有完整的 Orchestrator 功能
2. 與 Gemini CLI、Jules 同屬 Google 生態系
3. 降低跨平台整合的複雜度

如需使用其他 Orchestrator，請自行調整 `prompts/antigravity/` 中的模板格式。

