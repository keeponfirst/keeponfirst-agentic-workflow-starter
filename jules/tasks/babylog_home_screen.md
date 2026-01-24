# Jules Task: BabyLog Home Screen UI 實作

## 任務概述

根據 Stitch 設計產物，實作 BabyLog 首頁 UI 元件。

## Repository

> 注意：此任務為示範範本。實際使用時請替換為你的 BabyLog 專案 repo。

github.com/your-org/babylog-app

## Input Files（設計產物）

以下檔案由 Stitch MCP 自動生成，作為 UI 實作的參考：

```
stitch/designs/babylog/
├── screen_main.png        # UI 截圖（視覺參考）
├── screen_main.html       # HTML 結構（可參考 layout）
└── screen_main.meta.json  # 元資料（projectId, screenId 等）
```

## 設計規格

### 視覺風格
- **背景色**: 暖奶油色 (#F5F1E8)
- **主色**: 柔粉色 (#FFB6C1) 或 柔藍色 (#B0E0E6)
- **強調色**: 暖金色 (#FFD700)
- **文字色**: 柔灰色 (#4A4A4A)
- **卡片**: 白色 (#FFFFFF) 配淺陰影

### 設計原則
- 溫暖、柔軟、手繪風格
- 繪本般的插畫風格
- 大圓角、充足間距
- 單手操作友善（底部重心佈局）
- 大觸控區域（最小 44x44pt）

## 任務內容

### 框架選擇

請根據專案類型選擇對應框架：

- **iOS 原生** → SwiftUI
- **跨平台** → React Native 或 Flutter
- **Web** → React + Tailwind CSS

### 1. 建立色彩系統

```swift
// SwiftUI 範例
extension Color {
    static let warmCream = Color(hex: "#F5F1E8")
    static let softPeach = Color(hex: "#FFE5D4")
    static let gentleBlue = Color(hex: "#D4E8F0")
    static let softGreen = Color(hex: "#E8F5E9")
    static let warmBrown = Color(hex: "#8B6F47")
}
```

### 2. 實作主要元件

#### Header 區塊
- 顯示「Today」或寶寶名字
- 圓潤字體
- 可選：小型手繪插圖

#### Quick Actions Card
- 大型圓角卡片，淺陰影
- 4 個快速動作按鈕：
  - 🍼 Feed（餵食）
  - 👶 Diaper（換尿布）
  - 🌙 Sleep（睡眠）
  - 🧸 Play（玩耍）
- 手繪風格圖示，暖色調

#### Today's Summary Card
- 今日餵食次數
- 今日換尿布次數
- 今日睡眠時長
- 友善圖示配圓潤數字

#### Recent Activity Feed
- 最近活動列表
- 每項：圖示 + 時間 + 描述
- 柔和分隔線，充足留白

#### Bottom Navigation
- Home / Log / Stats / Settings
- 大型圓角圖示
- 暖色強調色

### 3. 實作互動效果

- 按鈕輕柔按下動畫
- 卡片微妙懸浮效果
- 平滑、舒緩的轉場
- 無刺眼動畫或突兀轉場

## 驗收標準

- [ ] 所有顏色使用設計系統定義（Color extension 或 theme）
- [ ] 所有間距符合設計規範
- [ ] 元件可重用
- [ ] 支援 Dynamic Type（iOS）或對應的文字縮放
- [ ] 大觸控區域（最小 44x44pt）
- [ ] 單手操作友善
- [ ] 視覺效果與 `screen_main.png` 一致

## 參考資源

- 設計截圖：`stitch/designs/babylog/screen_main.png`
- HTML 結構參考：`stitch/designs/babylog/screen_main.html`
- 設計元資料：`stitch/designs/babylog/screen_main.meta.json`
- 原始設計需求：`stitch/completed/babylog_home_screen.md`

## 備註

- 此任務為 Workflow 示範，展示 DESIGN → CODE 的交接流程
- 實際專案請根據你的技術棧調整框架選擇
- 圖示可先用 emoji 或 SF Symbols，之後用 Nano Banana 產生自訂圖示
