# Empty State 生成 Prompt

Gemini CLI (Nano Banana) 專用的 Empty State 插圖生成 prompt 模板。

---

## 輸出規範

| 項目 | 規範 |
|------|------|
| 輸出路徑 | `assets/generated/illustrations/` |
| 檔名格式 | `{{FEATURE_NAME}}_empty_state.png` |
| 尺寸 | 建議 200x200 或 300x300 |
| 格式 | PNG with transparency |

---

## Prompt 模板

```
Generate a single empty state illustration with the following specifications:

## Illustration Description
{{ILLUSTRATION_DESCRIPTION}}

## Emotional Tone
- Mood: {{MOOD}} (e.g., friendly, encouraging, neutral)
- Message conveyed: {{MESSAGE}}

## Style Guidelines
- Style: {{STYLE}} (e.g., flat illustration, line art, minimal)
- Color palette: {{COLOR_PALETTE}}
- Background: Transparent
- Size: {{SIZE}}x{{SIZE}} pixels

## Technical Requirements
- Export as PNG with transparency
- Clean, simple shapes
- Centered composition
- Not too complex (should load fast)

## Context
- App/Feature: {{APP_CONTEXT}}
- When shown: {{SHOWN_WHEN}}
- Accompanying text: {{ACCOMPANYING_TEXT}}
```

---

## 變數說明

| 變數 | 說明 | 範例 |
|------|------|------|
| `{{FEATURE_NAME}}` | 功能名稱 | `tags`, `notes`, `search` |
| `{{ILLUSTRATION_DESCRIPTION}}` | 插圖描述 | 「一個空的標籤盒子」 |
| `{{MOOD}}` | 情緒 | `friendly`, `encouraging` |
| `{{MESSAGE}}` | 傳達的訊息 | 「這裡還沒有東西」 |
| `{{STYLE}}` | 風格 | `flat illustration` |
| `{{COLOR_PALETTE}}` | 配色 | `Soft pastels with blue accent` |
| `{{SIZE}}` | 尺寸 | `200`, `300` |
| `{{APP_CONTEXT}}` | App 情境 | `Notes app` |
| `{{SHOWN_WHEN}}` | 顯示時機 | `When user has no tags yet` |
| `{{ACCOMPANYING_TEXT}}` | 搭配文字 | 「尚無標籤，點擊新增」 |

---

## 使用範例

### 範例：無標籤 Empty State

```
Generate a single empty state illustration with the following specifications:

## Illustration Description
An empty tag box or label holder, looking friendly and inviting

## Emotional Tone
- Mood: friendly and encouraging
- Message conveyed: "Nothing here yet, but it's easy to start!"

## Style Guidelines
- Style: flat illustration with soft shadows
- Color palette: Soft blue and gray with white accents
- Background: Transparent
- Size: 200x200 pixels

## Technical Requirements
- Export as PNG with transparency
- Clean, simple shapes
- Centered composition
- Not too complex

## Context
- App/Feature: Notes app, Tag selector
- When shown: When user has not created any tags yet
- Accompanying text: "尚無標籤，點擊右上角新增"
```

**輸出檔案**：`assets/generated/illustrations/tags_empty_state.png`

---

## Prompt 留存規範

執行完成後，在檔案底部加上：

```markdown
---
## 執行結果
- 執行時間：2024-01-15 14:30
- 產出檔案：assets/generated/illustrations/tags_empty_state.png
- 狀態：成功
- 備註：顏色可能需要微調配合 app 主色
```
