# PLAN: GitHub Pages 配置

> 新增 GitHub Pages 配置檔，讓 docs/ 可以直接作為靜態網站部署

## 功能概述

建立 GitHub Pages 所需的配置檔案：
1. `_config.yml` - Jekyll 配置
2. 確保 404.html 和 onboarding/ 可正確訪問

---

## 技術設計

### 檔案結構

```
docs/
├── _config.yml       # 新增：GitHub Pages 配置
├── 404.html          # 已存在
└── onboarding/       # 已存在
```

### _config.yml 內容

```yaml
title: Agentic Workflow Starter
description: 人不一定在場，任務也能前進
theme: null
include:
  - onboarding
  - 404.html
```

---

## 素材需求

無需產圖

---

## 程式任務（給 Jules）

### Task: 建立 GitHub Pages 配置
- 建立 `docs/_config.yml`
- 設定 title 和 description
- 確保靜態檔案可正確存取

---

## 驗收標準

- [ ] _config.yml 存在且格式正確
- [ ] 無 Jekyll 錯誤

---

## 執行記錄

1. ⬜ 確認 PLAN
2. ⬜ 提交 Jules Task
3. ⬜ Watch 並 Review
4. ⬜ Release
