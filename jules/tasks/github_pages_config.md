# Jules Task: GitHub Pages 配置

## 任務概述

為 keeponfirst-agentic-workflow-starter 建立 GitHub Pages 配置檔。

## Repository

github.com/keeponfirst/keeponfirst-agentic-workflow-starter

## 任務內容

請建立 `docs/_config.yml`，這是 GitHub Pages (Jekyll) 的配置檔案：

### 配置內容

```yaml
# GitHub Pages configuration for Agentic Workflow Starter
title: Agentic Workflow Starter
description: 人不一定在場，任務也能前進。Antigravity + Gemini CLI + Jules 的 Agentic Workflow 起手式。

# Disable Jekyll theme (we use custom HTML)
theme: null

# Include static files
include:
  - onboarding
  - 404.html

# Exclude unnecessary files
exclude:
  - README.md
  - LICENSE

# Encoding
encoding: UTF-8
```

## 驗收標準

- [ ] docs/_config.yml 檔案存在
- [ ] YAML 格式正確
- [ ] 包含 title 和 description
