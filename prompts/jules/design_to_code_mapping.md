# Design to Code Mapping Prompt

Jules 專用的設計轉程式碼對應 prompt 模板。

---

## 使用時機

當你有設計稿（Figma、Sketch 或截圖），需要 Jules 轉換成程式碼時使用。

---

## Prompt 模板

```
# Design to Code Mapping Task

## Task Overview
將設計稿轉換成可運行的程式碼

## Design Reference

### Screenshot / Design Link
{{DESIGN_REFERENCE}}

### Design Breakdown
{{DESIGN_BREAKDOWN}}

## Component Mapping

| Design Element | Code Component | Notes |
|----------------|----------------|-------|
{{COMPONENT_MAPPING_TABLE}}

## Style Tokens

### Colors
{{COLOR_TOKENS}}

### Typography
{{TYPOGRAPHY_TOKENS}}

### Spacing
{{SPACING_TOKENS}}

## Output Files
{{OUTPUT_FILES}}

## Technical Specifications
- Framework: {{FRAMEWORK}}
- Design system: {{DESIGN_SYSTEM}}
- Responsive: {{RESPONSIVE_REQUIREMENTS}}

## Pixel Perfect vs Semantic

請優先考慮：
1. 語意正確（accessibility）
2. 響應式（不同螢幕尺寸）
3. 最後才是 pixel perfect

## Acceptance Criteria
{{ACCEPTANCE_CRITERIA}}
```

---

## 變數說明

| 變數 | 說明 |
|------|------|
| `{{DESIGN_REFERENCE}}` | 設計稿連結或截圖位置 |
| `{{DESIGN_BREAKDOWN}}` | 設計分解說明 |
| `{{COMPONENT_MAPPING_TABLE}}` | 設計元素與程式碼的對應表 |
| `{{COLOR_TOKENS}}` | 顏色 tokens |
| `{{TYPOGRAPHY_TOKENS}}` | 字型 tokens |
| `{{SPACING_TOKENS}}` | 間距 tokens |
| `{{OUTPUT_FILES}}` | 產出檔案 |
| `{{FRAMEWORK}}` | 使用框架 |
| `{{DESIGN_SYSTEM}}` | 設計系統 |
| `{{RESPONSIVE_REQUIREMENTS}}` | 響應式需求 |
| `{{ACCEPTANCE_CRITERIA}}` | 驗收條件 |

---

## 使用範例

```markdown
# Design to Code Mapping Task

## Task Overview
將標籤選擇器設計稿轉換成 SwiftUI 程式碼

## Design Reference

### Screenshot
See: `designs/tag_selector_v2.png`

### Design Breakdown
```
┌────────────────────────────────────┐
│ [icon] Select Tags        [+]     │  ← Header
├────────────────────────────────────┤
│ ┌─────┐ ┌─────┐ ┌─────┐           │
│ │work │ │personal│ │idea│ ...     │  ← Chip Row
│ └─────┘ └─────┘ └─────┘           │
└────────────────────────────────────┘
```

## Component Mapping

| Design Element | Code Component | Notes |
|----------------|----------------|-------|
| Header bar | `TagSelectorHeader` | HStack with icon, title, button |
| Tag chip | `TagChipView` | Capsule shape button |
| Chip container | `TagChipContainer` | Horizontal ScrollView |
| Add button | `AddTagButton` | SF Symbol "plus.circle" |

## Style Tokens

### Colors
- Primary: `#007AFF` (selected chip)
- Secondary: `#E5E5EA` (unselected chip)
- Text Primary: `#000000` / `#FFFFFF` (dark mode)
- Text Secondary: `#8E8E93`

### Typography
- Header title: SF Pro, 17pt, semibold
- Chip text: SF Pro, 14pt, regular

### Spacing
- Header padding: 16pt horizontal, 12pt vertical
- Chip spacing: 8pt
- Chip padding: 12pt horizontal, 6pt vertical

## Output Files
- `Views/TagSelector/TagSelectorView.swift` [CREATE]
- `Views/TagSelector/TagChipView.swift` [CREATE]
- `Views/TagSelector/TagSelectorHeader.swift` [CREATE]

## Technical Specifications
- Framework: SwiftUI, iOS 16+
- Design system: Use existing `Theme` module
- Responsive: Support all iPhone sizes, compact height in landscape

## Acceptance Criteria
- [ ] 視覺上與設計稿匹配（允許 2pt 誤差）
- [ ] 支援 Dark Mode
- [ ] 支援 Dynamic Type
- [ ] VoiceOver accessible
- [ ] 動畫流暢
```

---

## 設計稿準備建議

為了讓 Jules 更好地理解設計：

1. **標註尺寸**：在設計稿上標明關鍵尺寸
2. **列出顏色**：用 hex code 列出所有顏色
3. **分層截圖**：如果設計複雜，分層截圖
4. **互動說明**：用文字描述互動行為
