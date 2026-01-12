# Feature Hero 生成 Prompt

Gemini CLI (Nano Banana) 專用的 Feature Hero 圖片生成 prompt 模板。

---

## 輸出規範

| 項目 | 規範 |
|------|------|
| 輸出路徑 | `assets/generated/heroes/` |
| 檔名格式 | `{{FEATURE_NAME}}_hero.png` |
| 尺寸 | 建議 1200x630 (OG image) 或 800x400 |
| 格式 | PNG 或 JPG |

---

## Prompt 模板

```
Generate a single feature hero image with the following specifications:

## Feature Description
{{FEATURE_DESCRIPTION}}

## Visual Concept
{{VISUAL_CONCEPT}}

## Style Guidelines
- Style: {{STYLE}} (e.g., modern tech, minimal, vibrant)
- Color palette: {{COLOR_PALETTE}}
- Composition: {{COMPOSITION}}
- Size: {{WIDTH}}x{{HEIGHT}} pixels

## Branding Elements
- Include: {{BRANDING_ELEMENTS}}
- Avoid: {{AVOID_ELEMENTS}}

## Technical Requirements
- High resolution
- Optimized for web
- Include safe zone for text overlay (if needed)

## Context
- Platform: {{PLATFORM}} (e.g., website, app store, social media)
- Purpose: {{PURPOSE}}
```

---

## 變數說明

| 變數 | 說明 | 範例 |
|------|------|------|
| `{{FEATURE_NAME}}` | 功能名稱 | `tag_selector` |
| `{{FEATURE_DESCRIPTION}}` | 功能描述 | 「強大的標籤管理功能」 |
| `{{VISUAL_CONCEPT}}` | 視覺概念 | 「排列整齊的彩色標籤」 |
| `{{STYLE}}` | 風格 | `modern tech` |
| `{{COLOR_PALETTE}}` | 配色 | `Brand blue with gradient` |
| `{{COMPOSITION}}` | 構圖 | `Centered with space for text on left` |
| `{{WIDTH}}` | 寬度 | `1200` |
| `{{HEIGHT}}` | 高度 | `630` |
| `{{BRANDING_ELEMENTS}}` | 需要的元素 | `App icon in corner` |
| `{{AVOID_ELEMENTS}}` | 避免的元素 | `Text (will be added later)` |
| `{{PLATFORM}}` | 平台 | `Website, Twitter` |
| `{{PURPOSE}}` | 用途 | `Announce new feature` |

---

## 使用範例

### 範例：標籤選擇器 Hero

```
Generate a single feature hero image with the following specifications:

## Feature Description
A powerful tag management feature that helps users organize their notes

## Visual Concept
Multiple colorful tags floating and organizing themselves, suggesting 
order from chaos, with a clean modern aesthetic

## Style Guidelines
- Style: modern tech with subtle 3D elements
- Color palette: Gradient from #007AFF to #5856D6, with white tags
- Composition: Tags flowing from left to right, space on left for text
- Size: 1200x630 pixels

## Branding Elements
- Include: Soft glow effects, depth shadows
- Avoid: Actual text on image, complex patterns

## Technical Requirements
- High resolution
- Optimized for web
- Safe zone on left 40% for text overlay

## Context
- Platform: Website header, Twitter share
- Purpose: Announce the new tag selector feature
```

**輸出檔案**：`assets/generated/heroes/tag_selector_hero.png`

---

## Prompt 留存規範

執行完成後，在檔案底部加上：

```markdown
---
## 執行結果
- 執行時間：2024-01-15 15:00
- 產出檔案：assets/generated/heroes/tag_selector_hero.png
- 狀態：成功
- 備註：可能需要用 Figma 加上文字標題
```
