# Plan Prompt

Antigravity Orchestrator 專用的規劃 prompt 模板。

---

## 使用時機

當你要開始一個新功能或專案時，用這個 prompt 產生結構化的計畫。

---

## Prompt 模板

```
你是一個資深軟體架構師，擅長將模糊的需求轉換成清楚的執行計畫。

## 功能需求

{{FEATURE_DESCRIPTION}}

## 專案背景

- 技術棧：{{TECH_STACK}}
- 現有架構：{{EXISTING_ARCHITECTURE}}

## 請產出

請產出一份 PLAN.md，包含以下章節：

### 1. 功能概述
- 一句話描述
- 使用者價值

### 2. 技術設計
- 需要的元件
- 資料流
- API 設計（如適用）

### 3. 素材需求（給 Gemini CLI）
列出需要產生的圖片素材，包含：
- 檔名
- 尺寸
- 用途
- Prompt 建議

### 4. 程式任務（給 Jules）
列出需要 Jules 執行的任務，每個任務包含：
- 任務名稱
- 輸入
- 輸出
- 驗收條件

### 5. 驗收標準
- 功能驗收條件
- 品質標準

### 6. 時程估計
- 各階段預估時間
```

---

## 變數說明

| 變數 | 說明 | 範例 |
|------|------|------|
| `{{FEATURE_DESCRIPTION}}` | 功能描述 | 「新增標籤選擇器，讓使用者可以選擇多個標籤」 |
| `{{TECH_STACK}}` | 使用的技術 | 「SwiftUI, Combine, Core Data」 |
| `{{EXISTING_ARCHITECTURE}}` | 現有架構 | 「MVVM，使用 Repository pattern」 |

---

## 輸出範例

```markdown
# PLAN: 標籤選擇器功能

## 1. 功能概述
- **一句話描述**：讓使用者可以為筆記新增多個標籤
- **使用者價值**：更靈活的筆記分類方式

## 2. 技術設計
- TagSelectorView（SwiftUI 元件）
- TagRepository（資料層）
- Tag model（Core Data entity）

## 3. 素材需求
| 檔名 | 尺寸 | 用途 |
|------|------|------|
| tag_icon.png | 24x24 | 標籤 icon |
| empty_tags.png | 200x200 | 無標籤時的插圖 |

## 4. 程式任務
1. 建立 Tag Core Data entity
2. 實作 TagRepository
3. 實作 TagSelectorView
4. 整合到 NoteDetailView

## 5. 驗收標準
- [ ] 使用者可以選擇多個標籤
- [ ] 標籤顯示正確
- [ ] 資料正確儲存

## 6. 時程估計
- 素材產生：1 天
- 程式實作：2 天
- 測試整合：1 天
```
