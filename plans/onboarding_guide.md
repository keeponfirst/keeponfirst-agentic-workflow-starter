# PLAN: Interactive Onboarding Guide

> 為 keeponfirst-agentic-workflow-starter 新增互動式新手引導頁面

## 功能概述

建立一個互動式 Onboarding Guide，讓新使用者可以：
1. 視覺化理解三角色分工（Antigravity / Gemini CLI / Jules）
2. Step-by-step 瞭解 workflow 流程
3. 直接從引導頁面開始使用

---

## 技術設計

### 技術棧
- **框架**：純 HTML + CSS + JavaScript（無需 build）
- **位置**：`docs/onboarding/index.html`
- **特色**：
  - 響應式設計
  - 深色主題（符合開發者偏好）
  - 動畫過場效果
  - 可嵌入 GitHub Pages

### 頁面結構

```
docs/onboarding/
├── index.html          # 主頁面
├── styles.css          # 樣式
├── app.js              # 互動邏輯
└── assets/
    ├── hero.png        # Hero 插圖
    ├── step1.png       # Antigravity 步驟圖
    ├── step2.png       # Gemini CLI 步驟圖
    └── step3.png       # Jules 步驟圖
```

---

## 素材需求（給 Gemini CLI Nano Banana）

| 檔名 | 尺寸 | 用途 | 風格 |
|------|------|------|------|
| hero.png | 800x400 | 首頁 Hero 圖 | 三個機器人協作的插圖 |
| step1_antigravity.png | 400x300 | Antigravity 說明 | 大腦/規劃意象 |
| step2_gemini.png | 400x300 | Gemini CLI 說明 | 圖像生成意象 |
| step3_jules.png | 400x300 | Jules 說明 | 雲端/程式碼意象 |

---

## 程式任務（給 Jules）

### Task 1: 建立 Onboarding 頁面骨架
- 建立 `docs/onboarding/` 目錄結構
- 實作響應式 HTML 結構
- 深色主題 CSS

### Task 2: 實作互動 Step-by-Step 流程
- 3 個步驟的導覽
- 進度指示器
- 前進/後退按鈕
- 動畫過場

### Task 3: 整合圖片與完成細節
- 載入 Nano Banana 產出的圖片
- 加入 CTA 按鈕連結到 README
- 確保 GitHub Pages 可用

---

## 驗收標準

- [x] 頁面可在瀏覽器直接開啟（無需 server）
- [x] 響應式：手機/平板/桌面都正常顯示
- [x] 3 個步驟都有對應插圖
- [x] 有明確的 CTA 引導開始使用
- [x] 深色主題、現代設計感

---

## 時程估計

- 素材產生：4 張圖 × Nano Banana = 約 10 分鐘
- 程式實作：Jules Task 1-3 = 約 15 分鐘
- Review 與調整：約 5 分鐘

---

## 執行記錄

1. ✅ 確認 PLAN
2. ✅ 準備產圖任務 (4 張 Nano Banana)
3. ✅ 準備 Jules Task (session 16534805096214313985)
4. ✅ 提交 Jules 並監控
5. ✅ Review 並 Release (commit a44f056)
