# Pencil MCP 進階應用指南

## 🎨 Pencil 可以做什麼？

### 1. 設計轉換為程式碼

Pencil 可以將你的設計直接轉換為生產級程式碼：

#### 支援的框架（根據專案類型）

**移動 App（如 BabyLog）**：
- **SwiftUI** (iOS) - 原生 iOS 開發
- **React Native** - 跨平台移動開發
- **Flutter** - 跨平台移動開發
- **Kotlin Compose** (Android) - 原生 Android 開發

**Web App**：
- **React** (TypeScript/JavaScript)
- **Vue**
- **Next.js**
- **Tailwind CSS v4**

#### 轉換流程

```
.pen 設計檔案
    ↓
Pencil MCP 分析設計
    ↓
根據專案框架生成程式碼
    ↓
SwiftUI / React Native / Flutter / React 等
    ↓
可直接使用的程式碼
```

> **重要**：Pencil 會根據你的專案類型自動選擇合適的框架。如果是移動 app，會生成 SwiftUI 或 React Native 程式碼，而不是 web 框架。

### 2. 與本 Workflow 整合

Pencil 可以完美整合到你的 Agentic Workflow：

#### Phase 2.5: DESIGN（新增階段）

```
PLAN → ASSETS → DESIGN → CODE → REVIEW → RELEASE
                      ↑
                   Pencil 設計
```

**使用場景**：
1. **Antigravity 規劃** → 產生功能規格
2. **Pencil 設計** → 將規格轉換為視覺設計
3. **Pencil 轉碼** → 將設計轉換為對應框架的程式碼（SwiftUI/React Native/Flutter）
4. **Jules 實作** → 使用生成的元件進行整合

### 3. 實際應用案例

#### 案例 1：快速原型設計

```bash
# 1. 在 Pencil 中設計 UI
# 2. 使用 MCP 轉換為程式碼
# 3. 直接整合到專案中
```

#### 案例 2：設計系統建立

```bash
# 1. 在 Pencil 中建立設計系統（顏色、字體、元件）
# 2. 轉換為 CSS Variables 和 React Components
# 3. 在整個專案中重用
```

#### 案例 3：響應式設計

```bash
# 1. 設計多個斷點（mobile, tablet, desktop）
# 2. 轉換為響應式 React 元件
# 3. 自動適配不同螢幕尺寸
```

## 🛠 實際操作範例

### 範例 1：將 BabyLog 設計轉換為 SwiftUI（iOS App）

#### 步驟 1：讀取設計變數

```javascript
// 使用 Pencil MCP 獲取設計變數
get_variables() → {
  colors: {
    warmCream: "#FFF8F0",
    softPeach: "#FFE5D4",
    gentleBlue: "#D4E8F0",
    // ...
  }
}
```

#### 步驟 2：生成 SwiftUI Color Extension

```swift
// Theme/Colors.swift
import SwiftUI

extension Color {
    static let warmCream = Color(hex: "#FFF8F0")
    static let softPeach = Color(hex: "#FFE5D4")
    static let gentleBlue = Color(hex: "#D4E8F0")
    static let softGreen = Color(hex: "#E8F5E9")
    static let warmBrown = Color(hex: "#8B6F47")
}
```

#### 步驟 3：生成 SwiftUI View

```swift
// Views/HomeScreen.swift
import SwiftUI

struct HomeScreen: View {
    var body: some View {
        VStack(spacing: 0) {
            HeaderView()
            ScrollView {
                VStack(spacing: 24) {
                    QuickLogCard()
                    TodayStatsCard()
                    RecentActivityCard()
                }
                .padding(.horizontal, 28)
                .padding(.top, 24)
                .padding(.bottom, 100)
            }
            BottomNavigation()
        }
        .background(Color.warmCream)
    }
}
```

### 範例 1b：將 BabyLog 設計轉換為 React Native（跨平台）

#### 生成 React Native 元件

```tsx
// components/BabyLog/HomeScreen.tsx
import { View, ScrollView, StyleSheet } from 'react-native';

export function HomeScreen() {
  return (
    <View style={styles.container}>
      <Header />
      <ScrollView style={styles.scrollView}>
        <QuickLogCard />
        <TodayStatsCard />
        <RecentActivityCard />
      </ScrollView>
      <BottomNavigation />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#FFF8F0',
  },
  scrollView: {
    flex: 1,
    paddingHorizontal: 28,
    paddingTop: 24,
    paddingBottom: 100,
  },
});
```

### 範例 2：與 Jules 任務整合

#### 在 Jules 任務中使用 Pencil 設計（iOS App）

```markdown
# Jules Task: 實作 BabyLog Home Screen

## Input Files
- `designs/babylog-home.pen` (Pencil 設計檔案)
- `Views/HomeScreen.swift` (目標檔案)

## Task
使用 Pencil 設計檔案生成 SwiftUI View：
1. 讀取 `.pen` 檔案中的設計變數
2. 轉換為 SwiftUI Color 和 Spacing
3. 實作所有 UI 元件（使用 SwiftUI）
4. 確保支援 Dynamic Type 和 Dark Mode

## Technical Requirements
- Framework: SwiftUI (iOS 16+)
- State management: @Observable (iOS 17)
- 命名規範: View 結尾

## Acceptance Criteria
- [ ] 所有顏色使用 Color extension
- [ ] 所有間距符合設計規範
- [ ] 元件可重用
- [ ] 支援 Dynamic Type
- [ ] 支援 Dark Mode
- [ ] 單手操作友好（大按鈕、易觸及）
```

### 範例 3：設計系統建立

#### 建立可重用的設計元件

```javascript
// 在 Pencil 中建立設計系統
// 1. 定義顏色系統
// 2. 定義字體系統
// 3. 定義間距系統
// 4. 建立可重用元件（Button, Card, Input 等）

// 轉換為程式碼
// → 生成 Design System 文件
// → 生成 React Components
// → 生成 Tailwind Config
```

## 🎯 與本 Workflow 的整合方式

### 方式 1：作為 ASSETS 階段的補充

```
PLAN → ASSETS (Gemini CLI 產圖) + DESIGN (Pencil 設計) → CODE
```

**使用時機**：
- 需要複雜 UI 設計時
- 需要設計系統時
- 需要響應式設計時

### 方式 2：作為獨立的 DESIGN 階段

```
PLAN → ASSETS → DESIGN (Pencil) → CODE → REVIEW → RELEASE
```

**使用時機**：
- 完整的功能開發流程
- 需要視覺設計和程式碼生成

### 方式 3：快速原型

```
IDEA → Pencil 設計 → 轉碼 → 測試
```

**使用時機**：
- 快速驗證想法
- 建立 MVP
- 展示給客戶

## 📋 實用工作流程

### 工作流程 1：從設計到程式碼

```bash
# 1. 在 Pencil 中設計
# 2. 使用 MCP 讀取設計
mcp_highagency_pencildev-extension-pencil_get_editor_state

# 3. 獲取設計變數
mcp_highagency_pencildev-extension-pencil_get_variables

# 4. 生成程式碼（手動或使用 AI）
# 5. 整合到專案
```

### 工作流程 2：設計迭代

```bash
# 1. 設計初版
# 2. 獲取截圖檢查
mcp_highagency_pencildev-extension-pencil_get_screenshot

# 3. 調整設計
mcp_highagency_pencildev-extension-pencil_batch_design

# 4. 再次檢查
# 5. 滿意後轉碼
```

### 工作流程 3：元件庫建立

```bash
# 1. 設計基礎元件（Button, Input, Card）
# 2. 建立可重用元件
# 3. 轉換為 React Components
# 4. 在專案中重用
```

## 🚀 進階功能

### 1. 批量設計操作

```javascript
// 一次操作多個元素
mcp_highagency_pencildev-extension-pencil_batch_design({
  operations: [
    "frame1=I(...)",
    "frame2=I(...)",
    "U(frame1, {...})",
    // ...最多 25 個操作
  ]
})
```

### 2. 設計系統變數管理

```javascript
// 獲取設計變數
mcp_highagency_pencildev-extension-pencil_get_variables()

// 更新設計變數
mcp_highagency_pencildev-extension-pencil_set_variables({
  variables: {
    colors: {
      primary: "#8B6F47"
    }
  }
})
```

### 3. 設計搜尋與篩選

```javascript
// 搜尋特定類型的元件
mcp_highagency_pencildev-extension-pencil_batch_get({
  patterns: [
    { type: "frame", reusable: true }
  ]
})
```

### 4. 佈局驗證

```javascript
// 檢查佈局問題
mcp_highagency_pencildev-extension-pencil_snapshot_layout({
  problemsOnly: true
})
```

## 💡 最佳實踐

### 1. 設計優先，程式碼其次

- 先完成設計，再轉換為程式碼
- 確保設計符合需求
- 避免在程式碼階段大幅修改設計

### 2. 建立設計系統

- 定義顏色、字體、間距系統
- 建立可重用元件
- 保持一致性

### 3. 響應式設計

- 設計多個斷點
- 測試不同螢幕尺寸
- 確保單手操作友好

### 4. 與團隊協作

- 使用 Git 版本控制設計檔案
- 設計檔案與程式碼同步
- 建立設計文檔

## 🎨 設計轉碼範例

### 完整範例：BabyLog Quick Log Card

#### 設計（Pencil）
- 3 個按鈕：Feed, Diaper, Sleep
- 圓角：20px
- 顏色：柔和桃色、藍色、綠色
- 間距：16px gap

#### 程式碼（SwiftUI - iOS App）

```swift
// Views/QuickLogCard.swift
import SwiftUI

struct QuickLogCard: View {
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 16) {
                QuickLogButton(
                    icon: "🍼",
                    label: "Feed",
                    color: .softPeach
                )
                QuickLogButton(
                    icon: "👶",
                    label: "Diaper",
                    color: .gentleBlue
                )
                QuickLogButton(
                    icon: "🌙",
                    label: "Sleep",
                    color: .softGreen
                )
            }
        }
        .padding(24)
        .background(Color.white)
        .cornerRadius(28)
    }
}

struct QuickLogButton: View {
    let icon: String
    let label: String
    let color: Color
    
    var body: some View {
        Button(action: {}) {
            VStack(spacing: 8) {
                Text(icon)
                    .font(.system(size: 40))
                Text(label)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.warmBrown)
            }
            .frame(maxWidth: .infinity)
            .padding(20)
            .background(color)
            .cornerRadius(20)
        }
    }
}
```

#### 程式碼（React Native - 跨平台）

```tsx
// components/BabyLog/QuickLogCard.tsx
import { View, Text, TouchableOpacity, StyleSheet } from 'react-native';

export function QuickLogCard() {
  return (
    <View style={styles.container}>
      <View style={styles.buttonRow}>
        <QuickLogButton icon="🍼" label="Feed" color="#FFE5D4" />
        <QuickLogButton icon="👶" label="Diaper" color="#D4E8F0" />
        <QuickLogButton icon="🌙" label="Sleep" color="#E8F5E9" />
      </View>
    </View>
  );
}

function QuickLogButton({ icon, label, color }) {
  return (
    <TouchableOpacity style={[styles.button, { backgroundColor: color }]}>
      <Text style={styles.icon}>{icon}</Text>
      <Text style={styles.label}>{label}</Text>
    </TouchableOpacity>
  );
}

const styles = StyleSheet.create({
  container: {
    width: '100%',
    backgroundColor: '#FFFFFF',
    borderRadius: 28,
    padding: 24,
  },
  buttonRow: {
    flexDirection: 'row',
    gap: 16,
  },
  button: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    padding: 20,
    borderRadius: 20,
    gap: 8,
  },
  icon: {
    fontSize: 40,
  },
  label: {
    fontSize: 16,
    fontWeight: '500',
    color: '#8B6F47',
  },
});
```

## 🔗 相關資源

- [Pencil.dev 官方網站](https://pencil.dev)
- [Pencil MCP 文檔](https://docs.pencil.dev)
- [Tailwind CSS v4 文檔](https://tailwindcss.com)
- [React 文檔](https://react.dev)

## 📝 下一步建議

1. **嘗試轉換 BabyLog 設計**：將剛才建立的設計轉換為 SwiftUI 或 React Native 元件
2. **建立設計系統**：定義完整的顏色、字體、間距系統（移動 app 適用的格式）
3. **整合到 Workflow**：將 Pencil 設計階段加入你的開發流程
4. **建立元件庫**：設計可重用的 UI 元件並轉換為移動 app 程式碼

## ⚠️ 重要提醒

**Pencil 會根據你的專案類型自動選擇框架**：
- 如果專案是 iOS app → 生成 **SwiftUI** 程式碼
- 如果專案是 React Native → 生成 **React Native** 程式碼
- 如果專案是 Flutter → 生成 **Flutter** 程式碼
- 如果專案是 Web → 生成 **React/Tailwind** 程式碼

**BabyLog 是移動 app，應該使用**：
- ✅ SwiftUI（如果只做 iOS）
- ✅ React Native（如果要跨平台）
- ✅ Flutter（如果要跨平台）
- ❌ React/Tailwind（這是 web 技術，不適用）
