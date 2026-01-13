# Jules Task: Favicon 連結

## 任務概述

為 docs/onboarding/ 和 docs/404.html 加入 favicon 連結。

## Repository

github.com/keeponfirst/keeponfirst-agentic-workflow-starter

## 任務內容

請在 `docs/onboarding/index.html` 和 `docs/404.html` 的 `<head>` 區塊加入 favicon 連結：

```html
<link rel="icon" type="image/svg+xml" href="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 100 100'><text y='.9em' font-size='90'>🤖</text></svg>">
```

這個 inline SVG favicon 使用機器人 emoji，不需要額外圖片檔案。

### 需要修改的檔案

1. `docs/onboarding/index.html` - 在 `<head>` 內加入 favicon link
2. `docs/404.html` - 在 `<head>` 內加入 favicon link

## 驗收標準

- [ ] 兩個 HTML 檔案都有 favicon link
- [ ] 瀏覽器 tab 顯示機器人 emoji
