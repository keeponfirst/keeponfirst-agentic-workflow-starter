# PLAN: 404 Error Page

> 為 keeponfirst-agentic-workflow-starter 新增自訂 404 錯誤頁面

## 功能概述

建立一個視覺一致的 404 頁面：
1. 延續 Onboarding 的深色主題
2. 友善的錯誤訊息
3. 返回首頁/Onboarding 的連結

---

## 技術設計

### 技術棧
- **框架**：純 HTML + CSS（無需 JS）
- **位置**：`docs/404.html`（GitHub Pages 會自動使用）
- **特色**：
  - 深色主題
  - 簡潔設計
  - 機器人 404 插圖

### 檔案結構

```
docs/
├── 404.html          # 404 頁面
└── onboarding/       # 已存在
```

---

## 素材需求（給 Gemini CLI Nano Banana）

| 檔名 | 尺寸 | 用途 | 風格 |
|------|------|------|------|
| 404_robot.png | 400x400 | 迷路機器人插圖 | 可愛風格，困惑表情 |

---

## 程式任務（給 Jules）

### Task: 建立 404 頁面
- 建立 `docs/404.html`
- 深色主題 CSS（inline 或 link to onboarding styles）
- 包含：
  - 404 標題
  - 錯誤訊息
  - 返回連結
  - 機器人插圖位置

---

## 驗收標準

- [ ] 頁面可在瀏覽器直接開啟
- [ ] 深色主題，與 Onboarding 一致
- [ ] 有返回連結
- [ ] 有插圖

---

## 執行記錄

1. ⬜ 確認 PLAN
2. ⬜ 產生 404 機器人插圖
3. ⬜ 提交 Jules Task
4. ⬜ Watch 並 Review
5. ⬜ Release
