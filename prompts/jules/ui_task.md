# UI Task Prompt

Jules 專用的 UI 實作任務 prompt 模板。

---

## 使用時機

當你需要 Jules 實作 UI 元件或畫面時使用。

---

## Prompt 模板

```
# UI Implementation Task

## Task Overview
{{TASK_OVERVIEW}}

## Target Files

### Input Files (Read Only)
{{INPUT_FILES}}

### Output Files (Create/Modify)
{{OUTPUT_FILES}}

## UI Specification

### Component Structure
{{COMPONENT_STRUCTURE}}

### Visual Design
- Layout: {{LAYOUT}}
- Colors: {{COLORS}}
- Typography: {{TYPOGRAPHY}}
- Spacing: {{SPACING}}

### Assets
{{ASSETS_LIST}}

### Interactions
{{INTERACTIONS}}

## Technical Requirements
- Framework: {{FRAMEWORK}}
- State management: {{STATE_MANAGEMENT}}
- Naming conventions: {{NAMING_CONVENTIONS}}

## Acceptance Criteria
{{ACCEPTANCE_CRITERIA}}

## Out of Scope
{{OUT_OF_SCOPE}}
```

---

## 變數說明

| 變數 | 說明 |
|------|------|
| `{{TASK_OVERVIEW}}` | 任務概述 |
| `{{INPUT_FILES}}` | 需要讀取的檔案 |
| `{{OUTPUT_FILES}}` | 需要產出的檔案 |
| `{{COMPONENT_STRUCTURE}}` | 元件結構 |
| `{{LAYOUT}}` | 佈局說明 |
| `{{COLORS}}` | 顏色規範 |
| `{{TYPOGRAPHY}}` | 字型規範 |
| `{{SPACING}}` | 間距規範 |
| `{{ASSETS_LIST}}` | 使用的素材 |
| `{{INTERACTIONS}}` | 互動行為 |
| `{{FRAMEWORK}}` | 使用的框架 |
| `{{STATE_MANAGEMENT}}` | 狀態管理方式 |
| `{{NAMING_CONVENTIONS}}` | 命名規範 |
| `{{ACCEPTANCE_CRITERIA}}` | 驗收條件 |
| `{{OUT_OF_SCOPE}}` | 不在範圍內的事項 |

---

## 使用範例

```markdown
# UI Implementation Task

## Task Overview
實作標籤選擇器元件（TagSelectorView）

## Target Files

### Input Files (Read Only)
- `Models/Tag.swift` - Tag model definition
- `Theme/Colors.swift` - Color constants
- `assets/generated/icons/tag_icon.png` - Tag icon asset

### Output Files (Create/Modify)
- `Views/TagSelector/TagSelectorView.swift` [CREATE]
- `Views/TagSelector/TagChipView.swift` [CREATE]
- `ViewModels/TagSelectorViewModel.swift` [CREATE]

## UI Specification

### Component Structure
```
TagSelectorView
├── Header (Title + Add button)
├── ChipContainer (horizontal scroll)
│   └── TagChipView (repeating)
└── EmptyState (when no tags)
```

### Visual Design
- Layout: Horizontal scrolling chips
- Colors: Use `Theme.Colors.primary` for selected, `.secondary` for unselected
- Typography: System font, 14pt for chips, 17pt for header
- Spacing: 8pt between chips, 16pt padding

### Assets
- `tag_icon.png` - Header icon
- `tags_empty_state.png` - Empty state illustration

### Interactions
- Tap chip → toggle selection
- Long press chip → show edit menu
- Tap add button → show add tag sheet

## Technical Requirements
- Framework: SwiftUI (iOS 16+)
- State management: @Observable (iOS 17) or @ObservableObject
- Naming conventions: Use View suffix for views, ViewModel suffix for view models

## Acceptance Criteria
- [ ] 可以顯示標籤清單
- [ ] 可以選擇/取消選擇多個標籤
- [ ] 無標籤時顯示 empty state
- [ ] 支援 Dynamic Type
- [ ] 支援 Dark Mode

## Out of Scope
- 標籤的 CRUD 操作（另一個 task）
- 資料持久化（由 Repository 處理）
```

---

## 輸出檔案規範

Jules 完成後，確認：

1. 所有 Output Files 都已產生
2. 程式碼可以編譯
3. 符合驗收條件
