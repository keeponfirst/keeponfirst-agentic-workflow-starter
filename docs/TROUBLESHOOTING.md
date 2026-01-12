# 常見問題排除

本文件收錄使用此 workflow 時常見的問題與解決方式。

---

## Gemini CLI 相關

### Quota 用完時

**症狀**：執行 Gemini CLI 時出現 `Rate limit exceeded` 或 `Quota exceeded` 錯誤。

**處理方式**：

1. **等待額度刷新**：免費額度通常每日刷新
2. **降低任務頻率**：遵循 Nano Banana 策略，一次只產一張圖
3. **檢查任務佇列**：確認 `nanobanana/queue/` 中沒有重複的任務
4. **考慮付費升級**：如需大量產圖，考慮升級 Gemini API 方案

**預防措施**：

建議產圖前先檢視 [Google AI Studio 後台](https://aistudio.google.com/) 確認剩餘額度。

### 圖片產出品質不佳

**處理方式**：

1. **優化 prompt**：參考 `prompts/gemini-cli/nanobanana/` 中的模板
2. **調整尺寸**：較小尺寸通常品質較穩定
3. **重新執行**：修改 prompt 後重新產圖

---

## Jules 相關

### 任務失敗或無回應

**症狀**：提交任務給 Jules 後，長時間沒有回應或任務失敗。

**處理方式**：

1. **確認任務格式**
   - 任務描述是否清楚？
   - 輸入/輸出檔案是否明確？
   - 是否包含驗收條件？

2. **檢查任務複雜度**
   - 拆分過大的任務
   - 一個 task 專注做一件事

3. **重新產生任務**
   ```bash
   # 修改 prompts/jules/ 中的模板
   # 重新執行
   ./scripts/agent.sh jules
   ```

4. **檢查 Jules 服務狀態**
   - 確認 Jules 服務是否正常運作
   - 查看是否有系統公告

### 任務達到每日上限

**症狀**：Jules 回應已達每日 100 tasks 上限。

**處理方式**：

1. **等待隔日**：額度每日刷新
2. **合併任務**：把相關的小任務合併成一個
3. **優先處理**：先做重要任務，次要任務延後

---

## 一般問題

### 如何重試任務

**Gemini CLI 任務**：

```bash
# 1. 編輯 nanobanana/queue/ 中的 prompt
vim nanobanana/queue/20240115_icon.md

# 2. 使用 Gemini CLI 重新執行
gemini generate -i nanobanana/queue/20240115_icon.md
```

**Jules 任務**：

```bash
# 1. 編輯 jules/tasks/ 中的任務
vim jules/tasks/20240115_ui_task.md

# 2. 複製內容重新提交給 Jules
```

### bootstrap.sh 執行失敗

**可能原因**：

1. **權限不足**
   ```bash
   chmod +x scripts/*.sh
   ```

2. **Shell 不相容**
   - 確認使用 bash（非 sh）
   ```bash
   bash scripts/bootstrap.sh
   ```

### agent.sh verify 失敗

**處理方式**：

1. 執行 `./scripts/bootstrap.sh` 確保目錄結構完整
2. 確認 `.env.example` 存在
3. 檢查是否有敏感資訊被追蹤：`./scripts/check_secrets.sh`

---

## 取得協助

如果以上方法無法解決問題：

1. 查看 [GitHub Issues](https://github.com/你的帳號/keeponfirst-agentic-workflow-starter/issues)
2. 提交新 Issue，並附上：
   - 執行的指令
   - 完整錯誤訊息
   - 你的環境資訊（OS、Shell 版本）
