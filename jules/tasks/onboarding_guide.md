# Jules Task: Interactive Onboarding Guide

## 任務概述

為 keeponfirst-agentic-workflow-starter 建立互動式新手引導頁面。

## Repository

github.com/keeponfirst/keeponfirst-agentic-workflow-starter

## 任務內容

請在 `docs/onboarding/` 目錄建立一個互動式 Onboarding Guide：

### 1. 建立目錄結構

```
docs/onboarding/
├── index.html
├── styles.css
├── app.js
└── assets/
    └── .gitkeep
```

### 2. 實作 index.html

- 響應式 HTML5 結構
- 包含 3 個步驟的 section
- Hero section 在最上方
- 底部有 CTA 按鈕連結到 README

### 3. 實作 styles.css

- 深色主題背景 (#0f0f1a 或類似)
- 現代化設計，使用 CSS variables
- 響應式：手機/平板/桌面
- 動畫過場效果
- 步驟卡片有 hover 效果
- 進度指示器樣式

### 4. 實作 app.js

- Step-by-step 導覽邏輯
- 前進/後退按鈕
- 進度指示器更新
- 簡單的淡入淡出動畫

### 5. 內容

**Hero Section**:
- 標題: "Agentic Workflow Starter"
- 副標題: "人不一定在場，任務也能前進"

**Step 1 - Antigravity (Orchestrator)**:
- 標題: "規劃與決策"
- 說明: Antigravity 是你的大腦延伸，負責規劃功能、決策和 Review

**Step 2 - Gemini CLI (Asset Generator)**:
- 標題: "圖像生成"
- 說明: 使用 Nano Banana 策略，一次產一張圖，避免 quota 耗盡

**Step 3 - Jules (Task Executor)**:
- 標題: "雲端執行"
- 說明: Jules 在雲端執行程式任務，你可以去做其他事

**CTA**:
- 按鈕文字: "開始使用"
- 連結到: ../../README.md

## 驗收標準

- [ ] 頁面可直接用瀏覽器開啟（無需 server）
- [ ] 3 個步驟可前進/後退
- [ ] 響應式設計正常運作
- [ ] 深色主題、現代設計感
- [ ] 有進度指示器
- [ ] CTA 按鈕連結正確

## 備註

- 圖片暫時用 placeholder（之後用 Nano Banana 產圖替換）
- 圖片位置：`assets/hero.png`, `assets/step1_antigravity.png` 等
- 可用 CSS 漸層或 SVG 作為暫時 placeholder
