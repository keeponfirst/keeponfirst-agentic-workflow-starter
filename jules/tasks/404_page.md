# Jules Task: 404 Error Page

## 任務概述

為 keeponfirst-agentic-workflow-starter 建立自訂 404 頁面。

## Repository

github.com/keeponfirst/keeponfirst-agentic-workflow-starter

## 任務內容

請建立 `docs/404.html`，這是一個自訂的 404 錯誤頁面：

### 設計要求

1. **深色主題**：與 `docs/onboarding/` 風格一致
   - 背景色: #0f0f1a 或 #1a1a2e
   - 文字色: #e0e0e0
   - 強調色: #4a4af5

2. **內容結構**：
   - 大標題: "404"
   - 副標題: "找不到頁面"
   - 說明文字: "看起來你迷路了！這個頁面不存在。"
   - 機器人插圖: `onboarding/assets/404_robot.png`
   - 返回連結按鈕

3. **返回連結**：
   - "回到首頁" → `../README.md`
   - "查看新手引導" → `onboarding/index.html`

4. **樣式**：
   - 置中對齊
   - 響應式設計
   - 可用 inline CSS 或 link 到 onboarding/styles.css

### 範例 HTML 結構

```html
<!DOCTYPE html>
<html lang="zh-TW">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>404 - 找不到頁面</title>
    <style>
        /* 深色主題樣式 */
    </style>
</head>
<body>
    <div class="container">
        <img src="onboarding/assets/404_robot.png" alt="迷路的機器人">
        <h1>404</h1>
        <h2>找不到頁面</h2>
        <p>看起來你迷路了！這個頁面不存在。</p>
        <div class="buttons">
            <a href="../README.md">回到首頁</a>
            <a href="onboarding/index.html">查看新手引導</a>
        </div>
    </div>
</body>
</html>
```

## 驗收標準

- [ ] 頁面可在瀏覽器直接開啟
- [ ] 深色主題，與 Onboarding 一致
- [ ] 顯示機器人插圖
- [ ] 有兩個返回連結按鈕
- [ ] 響應式設計
