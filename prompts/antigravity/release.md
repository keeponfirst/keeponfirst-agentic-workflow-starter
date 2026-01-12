# Release Prompt

Antigravity Orchestrator 專用的 Release 準備 prompt 模板。

---

## 使用時機

當功能完成、code review 通過後，用這個 prompt 準備 release。

---

## Prompt 模板

```
你是一個注重細節的 Release Manager。

## 本次變更

{{CHANGES_SUMMARY}}

## 相關 PRs / Commits

{{PR_LIST}}

## 當前版本

{{CURRENT_VERSION}}

## 請產出

### 1. 版本號建議
根據 Semantic Versioning：
- MAJOR: 有 breaking changes
- MINOR: 新增功能
- PATCH: bug 修復

建議新版本號：x.y.z

### 2. Release Notes
對使用者友善的更新說明，包含：
- 新功能
- 改進
- Bug 修復
- 已知問題（如有）

### 3. 技術變更摘要
給開發者看的變更摘要：
- 新增的 APIs
- Deprecated 的 APIs
- 資料庫變更（如有）
- 依賴更新（如有）

### 4. 發布前檢查清單
- [ ] 所有 tests 通過
- [ ] 文件已更新
- [ ] CHANGELOG 已更新
- [ ] 已在 staging 測試
- [ ] 沒有 blocking issues

### 5. 回滾計畫
如果發布後出問題：
- 如何回滾
- 需要注意的事項
```

---

## 變數說明

| 變數 | 說明 |
|------|------|
| `{{CHANGES_SUMMARY}}` | 本次變更摘要 |
| `{{PR_LIST}}` | 相關 PR 列表 |
| `{{CURRENT_VERSION}}` | 當前版本號 |

---

## 輸出範例

```markdown
# Release Preparation: v1.2.0

## 版本號建議
**v1.2.0** (MINOR - 新增功能)

## Release Notes

### 🚀 新功能
- **標籤選擇器**：現在可以為筆記新增多個標籤

### 💪 改進
- 改善載入速度
- 優化記憶體使用

### 🐛 Bug 修復
- 修復儲存時偶爾 crash 的問題

---

## 技術變更摘要

### 新增
- `TagSelectorView`
- `TagRepository`
- `Tag` Core Data entity

### 資料庫
- 新增 `Tag` table
- 新增 `note_tags` 關聯 table

---

## 發布前檢查清單
- [x] 所有 tests 通過
- [x] 文件已更新
- [x] CHANGELOG 已更新
- [ ] 已在 staging 測試
- [ ] 沒有 blocking issues

---

## 回滾計畫

如需回滾：
1. 將版本退回 v1.1.x
2. 執行 migration down script
3. 注意：新建立的 tags 會遺失
```
