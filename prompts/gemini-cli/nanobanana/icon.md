# Icon 生成 Prompt

Gemini CLI (Nano Banana) 專用的 Icon 生成 prompt 模板。

---

## 輸出規範

| 項目 | 規範 |
|------|------|
| 輸出路徑 | `assets/generated/icons/` |
| 檔名格式 | `{{ICON_NAME}}_icon.png` |
| 尺寸 | 建議 24x24, 48x48, 或 96x96 |
| 格式 | PNG with transparency |

---

## Prompt 模板

```
Generate a single icon with the following specifications:

## Icon Description
{{ICON_DESCRIPTION}}

## Style Guidelines
- Style: {{STYLE}} (e.g., flat, outlined, filled, gradient)
- Color: {{COLOR_SCHEME}}
- Background: Transparent
- Size: {{SIZE}}x{{SIZE}} pixels

## Technical Requirements
- Export as PNG with transparency
- Clean edges, no artifacts
- Centered within canvas
- Consistent line weight (if outlined)

## Context
This icon will be used for: {{USAGE_CONTEXT}}
```

---

## 變數說明

| 變數 | 說明 | 範例 |
|------|------|------|
| `{{ICON_NAME}}` | Icon 檔名 | `tag`, `home`, `settings` |
| `{{ICON_DESCRIPTION}}` | Icon 描述 | 「一個價格標籤的圖示」 |
| `{{STYLE}}` | 風格 | `flat`, `outlined`, `filled` |
| `{{COLOR_SCHEME}}` | 配色 | `#007AFF (Apple Blue)` |
| `{{SIZE}}` | 尺寸 | `24`, `48`, `96` |
| `{{USAGE_CONTEXT}}` | 使用情境 | 「標籤選擇器的標題 icon」 |

---

## 使用範例

### 範例 1：標籤 Icon

```
Generate a single icon with the following specifications:

## Icon Description
A price tag icon, simple and recognizable

## Style Guidelines
- Style: filled
- Color: #007AFF (Apple Blue)
- Background: Transparent
- Size: 24x24 pixels

## Technical Requirements
- Export as PNG with transparency
- Clean edges, no artifacts
- Centered within canvas
- Consistent line weight

## Context
This icon will be used for: Tag selector button in a notes app
```

**輸出檔案**：`assets/generated/icons/tag_icon.png`

---

## Prompt 留存規範

執行完成後：

1. 將此 prompt 從 `nanobanana/queue/` 移動到 `nanobanana/completed/`
2. 在檔名加上日期：`2024-01-15_icon_tag.md`
3. 在檔案底部加上產出結果：

```markdown
---
## 執行結果
- 執行時間：2024-01-15 14:30
- 產出檔案：assets/generated/icons/tag_icon.png
- 狀態：成功 / 需重試
- 備註：（如有）
```
