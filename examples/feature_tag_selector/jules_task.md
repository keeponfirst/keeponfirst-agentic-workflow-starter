# Jules Task：實作標籤選擇器

這是給 Jules 的任務範例。

> **注意**：本範例中的路徑（如 `Sources/Views/`、`Sources/ViewModels/`）是假設的專案結構。請依據你自己的專案實際目錄進行調整。

---

## Task Overview

實作標籤選擇器 UI 元件，包含選擇標籤、新增標籤、Empty State 顯示。

## Target Files

### Input Files (Read Only)
- `examples/feature_tag_selector/SPEC.md` - 功能規格
- `assets/generated/icons/tag_icon.png` - 標籤 icon
- `assets/generated/illustrations/tags_empty_state.png` - Empty state 插圖

### Output Files (Create)
- `Sources/Views/TagSelector/TagSelectorView.swift`
- `Sources/Views/TagSelector/TagChipView.swift`
- `Sources/Views/TagSelector/TagSelectorHeader.swift`
- `Sources/ViewModels/TagSelectorViewModel.swift`
- `Sources/Models/Tag.swift`

## Technical Requirements

- Framework: SwiftUI (iOS 16+)
- State management: @Observable (iOS 17) 或 @ObservableObject
- 命名規範: View 結尾、ViewModel 結尾

## Implementation Details

### TagSelectorView

主要容器，組合 Header 和 Chips：

```swift
struct TagSelectorView: View {
    @State private var viewModel = TagSelectorViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            TagSelectorHeader(onAdd: viewModel.showAddTag)
            
            if viewModel.tags.isEmpty {
                EmptyStateView()
            } else {
                ChipContainer(tags: viewModel.tags, 
                              selected: $viewModel.selectedTags)
            }
        }
    }
}
```

### TagChipView

單一標籤 chip：

```swift
struct TagChipView: View {
    let tag: Tag
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Text(tag.name)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(isSelected ? tag.color : Color.secondary.opacity(0.2))
            .foregroundColor(isSelected ? .white : .primary)
            .clipShape(Capsule())
            .onTapGesture(perform: onTap)
    }
}
```

## Acceptance Criteria

- [ ] TagSelectorView 正確顯示標籤
- [ ] 點擊標籤可切換選取
- [ ] 無標籤時顯示 empty state
- [ ] 支援 Dark Mode
- [ ] 可編譯通過
- [ ] 有基本的 Preview

## Out of Scope

- 標籤的 CRUD API
- 資料持久化
- 單元測試（另一個 task）
