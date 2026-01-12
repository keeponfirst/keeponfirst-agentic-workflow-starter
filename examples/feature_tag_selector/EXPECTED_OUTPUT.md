# 預期產出

此功能完成後，預期會得到以下檔案：

## 素材（Gemini CLI 產出）

```
assets/generated/
├── icons/
│   └── tag_icon.png          # 24x24 標籤 icon
└── illustrations/
    └── tags_empty_state.png  # 200x200 empty state 插圖
```

## 程式碼（Jules 產出）

```
Sources/
├── Models/
│   └── Tag.swift
├── ViewModels/
│   └── TagSelectorViewModel.swift
└── Views/
    └── TagSelector/
        ├── TagSelectorView.swift
        ├── TagSelectorHeader.swift
        └── TagChipView.swift
```

## 各檔案說明

### Tag.swift

```swift
// Tag model
struct Tag: Identifiable, Codable {
    let id: UUID
    var name: String
    var color: String // hex color
    var createdAt: Date
}
```

### TagSelectorViewModel.swift

```swift
// ViewModel 管理 tags 和 selection state
@Observable
class TagSelectorViewModel {
    var tags: [Tag] = []
    var selectedTags: Set<UUID> = []
    
    func toggle(_ tag: Tag) { ... }
    func showAddTag() { ... }
}
```

### TagSelectorView.swift

主要容器 View，組合 Header + Chips 或 EmptyState。

### TagChipView.swift

單一 tag chip 元件，支援選取狀態。

### TagSelectorHeader.swift

標題列，包含 icon、標題文字、新增按鈕。

---

## 驗證方式

1. **Build Test**：確認可以編譯
2. **Preview Test**：在 Xcode Preview 中確認 UI
3. **互動測試**：
   - 點擊 chip 可切換選取
   - Empty state 正確顯示
4. **Dark Mode**：切換 Dark Mode 確認配色

## 後續任務

完成此功能後，可繼續：

1. 新增標籤 Sheet（新的 Jules task）
2. 標籤編輯功能（新的 Jules task）
3. 標籤 Repository（資料持久化）
