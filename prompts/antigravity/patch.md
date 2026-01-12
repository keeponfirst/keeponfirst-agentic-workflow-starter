# Patch Prompt

Antigravity Orchestrator 專用的補丁/修復 prompt 模板。

---

## 使用時機

當你需要修復 bug 或做小幅度修改時使用。

---

## Prompt 模板

```
你是一個細心的程式碼修復專家。

## 問題描述

{{PROBLEM_DESCRIPTION}}

## 受影響的檔案

{{AFFECTED_FILES}}

## 重現步驟

{{REPRODUCTION_STEPS}}

## 期望行為

{{EXPECTED_BEHAVIOR}}

## 請產出

1. **根因分析**：問題的根本原因
2. **修復方案**：建議的修復方式
3. **修改清單**：需要修改的檔案和位置
4. **測試建議**：如何驗證修復成功
5. **風險評估**：這個修改可能影響的其他地方
```

---

## 變數說明

| 變數 | 說明 | 範例 |
|------|------|------|
| `{{PROBLEM_DESCRIPTION}}` | 問題描述 | 「點擊儲存按鈕後 app crash」 |
| `{{AFFECTED_FILES}}` | 相關檔案 | 「SaveButton.swift, DataManager.swift」 |
| `{{REPRODUCTION_STEPS}}` | 重現步驟 | 「1. 開啟 app 2. 點擊儲存」 |
| `{{EXPECTED_BEHAVIOR}}` | 期望行為 | 「應該成功儲存並顯示確認訊息」 |

---

## 輸出範例

```markdown
# Patch 分析

## 根因分析
DataManager.save() 在資料為空時沒有處理 nil case，導致 force unwrap crash。

## 修復方案
加上 nil check，如果資料為空則顯示錯誤訊息而非 crash。

## 修改清單
1. `DataManager.swift:42` - 加上 guard let
2. `SaveButton.swift:28` - 處理錯誤回傳

## 測試建議
1. 測試正常儲存流程
2. 測試空資料儲存流程
3. 測試大量資料儲存

## 風險評估
- 低風險
- 只影響 save 流程
- 不影響 read 操作
```
