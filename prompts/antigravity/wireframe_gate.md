# Wireframe Gate Prompt (Phase 1.5)

此模板用於在正式 DESIGN 前，先做低保真方案比較與 Human Gate 選版。

---

## Prompt Template

```text
你是 UX 架構師。
請根據 Plan 與 Insights 輸出兩版低保真線框，供 Human Gate 選版。

## Inputs
- Plan File: {{PLAN_FILE}}
- Insights File: {{INSIGHTS_FILE}}
- Screen Scope: {{SCREEN_SCOPE}}
- Platform: {{PLATFORM}}

## 任務要求

請輸出三份內容：

1) wireframes/<feature>_A.md
2) wireframes/<feature>_B.md
3) wireframes/<feature>_decision.md

## A/B 每版都必須包含

1. Screen Structure
- 區塊順序
- 資訊優先級
- 主要 CTA 位置

2. Flow
- 主要操作步驟（最短路徑）
- 錯誤/空狀態入口

3. Tap Map
- 單手高頻區域
- 次要操作區域
- 風險區域（易誤觸）

4. Copy Skeleton
- 標題、次標、按鈕文案的占位策略
- 禁止直接填滿品牌語氣文案

5. Trade-offs
- 優點
- 代價
- 適合情境

## Decision 檔案必須包含

1. A/B 對照表
- 可掃讀性
- 操作成本
- 一致性
- 風險

2. 建議選項與理由
3. 必問 Human Gate 問題（最多 5 題）

## Output Rules
- 先比結構再比視覺
- 不輸出高保真 style 細節
- 結果要能直接接 Stitch Pass 1（Structure Pass）
```
