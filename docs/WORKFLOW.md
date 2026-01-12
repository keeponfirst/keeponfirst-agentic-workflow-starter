# 標準工作流程

這份文件描述從「一個功能想法」到「完成交付」的標準流程。

> **設計背景**：本 workflow 源自 Gemini Pro 訂閱與 Google 工具鏈的實戰經驗。核心差異在於：Jules 提供雲端非同步的程式任務執行（每日 100 tasks），而 Gemini CLI 提供本地化的圖像生成能力（需控制 quota）。這兩者的互補性是本 workflow 的設計出發點。

## Feature Pipeline 總覽

```
┌─────────┐   ┌─────────┐   ┌─────────┐   ┌─────────┐   ┌─────────┐
│  PLAN   │ → │ ASSETS  │ → │  CODE   │ → │ REVIEW  │ → │ RELEASE │
└─────────┘   └─────────┘   └─────────┘   └─────────┘   └─────────┘
     │             │             │             │             │
     ▼             ▼             ▼             ▼             ▼
 Antigravity  Gemini CLI     Jules      Antigravity   Antigravity
```

---

## Phase 1: PLAN

**執行者**：Antigravity  
**輸入**：功能需求（口語描述或 Issue）  
**輸出**：`PLAN.md`

### 步驟

1. 使用 `prompts/antigravity/plan.md` 模板
2. 描述功能需求
3. Antigravity 產出結構化的 `PLAN.md`

### PLAN.md 內容

- 功能概述
- 需要的素材清單（給 Gemini CLI）
- 需要的程式任務（給 Jules）
- 驗收標準

---

## Phase 2: ASSETS

**執行者**：Gemini CLI (Nano Banana)  
**輸入**：`PLAN.md` 中的素材清單  
**輸出**：`assets/generated/` 中的圖片

### 步驟

1. 執行 `./scripts/agent.sh assets`
2. 腳本會把 prompts 複製到 `nanobanana/queue/`
3. 逐一用 Gemini CLI 執行每個 prompt
4. 圖片產出到 `assets/generated/`

### Nano Banana 原則

- **一次一張**：不要批次產圖
- **明確描述**：prompt 要具體
- **立即確認**：產完一張就確認品質

---

## Phase 3: CODE

**執行者**：Jules  
**輸入**：`PLAN.md` 中的程式任務 + 素材  
**輸出**：程式碼 PR 或 patch

### 步驟

1. 執行 `./scripts/agent.sh jules`
2. 腳本會產出任務到 `jules/tasks/`
3. 使用 Jules CLI 建立 session：`jules new "task description"`
4. **自動化流程**：執行 `./scripts/agent.sh watch <session_id>`
   - 自動輪詢 Jules 狀態
   - 完成後自動拉取並套用 patch
   - 喚醒 Antigravity agent 進行 Review

### 任務拆分原則

- **單一職責**：一個 task 做一件事
- **明確輸入輸出**：清楚說明用到哪些檔案
- **可驗證**：包含驗收條件

---

## Phase 4: REVIEW

**執行者**：Antigravity  
**輸入**：Jules 的產出  
**輸出**：Review 意見或 Approval

### 自動化 Review（使用 watch）

當使用 `./scripts/agent.sh watch` 時，Jules 完成後會自動：

1. 執行 `jules remote pull --apply` 拉取並套用變更
2. 使用 `agy chat --mode agent` 喚醒 Antigravity
3. Antigravity 自動執行 `git diff` 並進行 code review

### 手動 Review

1. 使用 `prompts/antigravity/review.md` 模板
2. 提供 Jules 產出的程式碼
3. Antigravity 進行 code review
4. 如有問題，產生修正任務回到 Phase 3

---

## Phase 5: RELEASE

**執行者**：Antigravity  
**輸入**：已 review 的程式碼  
**輸出**：Release notes、版本 tag

### 步驟

1. 使用 `prompts/antigravity/release.md` 模板
2. 彙整本次變更
3. 產出 release notes
4. 打 tag、發布

---

## 流程圖

```
User Idea
    │
    ▼
┌─────────────────┐
│  Antigravity    │
│  plan.md        │──────────────────────────────────────┐
└────────┬────────┘                                      │
         │                                               │
         ▼                                               │
    PLAN.md                                              │
         │                                               │
    ┌────┴────┐                                          │
    ▼         ▼                                          │
素材需求    程式需求                                       │
    │         │                                          │
    ▼         ▼                                          │
┌─────────┐ ┌─────────┐                                  │
│Gemini   │ │ Jules   │                                  │
│CLI      │ │         │                                  │
└────┬────┘ └────┬────┘                                  │
     │           │                                       │
     ▼           ▼                                       │
  assets/     程式碼                                      │
     │           │                                       │
     └─────┬─────┘                                       │
           │                                             │
           ▼                                             │
    ┌─────────────────┐                                  │
    │  Antigravity    │◄─────────────────────────────────┘
    │  review.md      │
    └────────┬────────┘
             │
             ▼
    ┌─────────────────┐
    │  Antigravity    │
    │  release.md     │
    └────────┬────────┘
             │
             ▼
        Release!
```

---

## 常見情境

### 情境 A：純 UI 功能

1. PLAN → 定義 UI 規格
2. ASSETS → 產 icon、empty state
3. CODE → Jules 實作 SwiftUI/React 元件
4. REVIEW → 確認樣式與互動
5. RELEASE

### 情境 B：純邏輯功能

1. PLAN → 定義邏輯規格
2. ASSETS → 跳過
3. CODE → Jules 實作
4. REVIEW
5. RELEASE

### 情境 C：重構

1. PLAN → 定義重構目標
2. ASSETS → 跳過
3. CODE → Jules 執行重構
4. REVIEW → 重點檢查 breaking changes
5. RELEASE
