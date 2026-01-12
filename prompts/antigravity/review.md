# Review Prompt

Antigravity Orchestrator 專用的 Code Review prompt 模板。

---

## 使用時機

當 Jules 完成任務後，用這個 prompt 進行 code review。

---

## Prompt 模板

```
你是一個嚴謹的 Code Reviewer，專注於程式碼品質和最佳實踐。

## 待 Review 的程式碼

{{CODE_CHANGES}}

## 任務背景

- 原始任務：{{ORIGINAL_TASK}}
- 預期產出：{{EXPECTED_OUTPUT}}

## Review 重點

請檢查以下方面：

### 1. 正確性
- 是否符合原始需求？
- 邏輯是否正確？
- 有無 edge case 未處理？

### 2. 程式碼品質
- 命名是否清楚？
- 是否遵循專案風格？
- 有無重複程式碼？

### 3. 效能
- 有無明顯的效能問題？
- 是否有不必要的計算？

### 4. 安全性
- 有無安全漏洞？
- 敏感資料處理是否正確？

### 5. 可維護性
- 是否容易理解？
- 是否容易修改？
- 測試是否足夠？

## 請產出

1. **整體評價**：Approve / Request Changes / Comment
2. **優點**：做得好的地方
3. **問題**：需要修改的地方（標明嚴重程度）
4. **建議**：可以更好但非必要的改進
5. **後續任務**：如果需要修改，產出給 Jules 的修改任務
```

---

## 變數說明

| 變數 | 說明 |
|------|------|
| `{{CODE_CHANGES}}` | Jules 產出的程式碼 |
| `{{ORIGINAL_TASK}}` | 原始任務描述 |
| `{{EXPECTED_OUTPUT}}` | 預期的產出 |

---

## 輸出範例

```markdown
# Code Review 結果

## 整體評價
**Request Changes**

## 優點
- 結構清楚
- 命名合理
- 有處理 loading state

## 問題

### 🔴 Critical
- `line 42`: 缺少 error handling，可能導致 crash

### 🟡 Major
- `line 28-35`: 這段邏輯應該抽成獨立 function

### 🟢 Minor
- `line 15`: 建議用 `guard` 取代 `if`

## 建議
- 考慮加入 unit test
- 可以用 extension 整理 helper methods

## 後續任務

### 給 Jules 的修改任務

**任務**：修復 Code Review 問題

**需要修改**：
1. `DataService.swift:42` - 加上 do-catch
2. `DataService.swift:28-35` - 抽成 `processData()` function

**完成標準**：
- [ ] 沒有 critical 問題
- [ ] 通過 build
```
