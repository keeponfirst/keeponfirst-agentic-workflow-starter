# 貢獻指南

感謝你有興趣為這個專案做出貢獻！

## 如何貢獻

### 貢獻 Prompts

1. **Antigravity Prompts** (`prompts/antigravity/`)
   - 確保模板有清楚的輸入/輸出定義
   - 使用 `{{變數名稱}}` 標記需要替換的部分
   - 附上使用範例

2. **Gemini CLI Prompts** (`prompts/gemini-cli/nanobanana/`)
   - 遵循 Nano Banana 策略：一次只產一張圖
   - 標明建議的輸出路徑
   - 說明產圖用途

3. **Jules Tasks** (`prompts/jules/`)
   - 明確定義輸入檔案和輸出檔案
   - 步驟要具體可執行
   - 包含驗收標準

### 貢獻 Examples

在 `examples/` 下新增資料夾：

```
examples/你的範例/
├── SPEC.md              # 功能規格
├── jules_task.md        # Jules 任務
├── nanobanana_prompts/  # 產圖 prompts
└── EXPECTED_OUTPUT.md   # 預期產出
```

### 提交 PR

1. Fork 這個 repo
2. 建立你的 feature branch (`git checkout -b feature/amazing-prompt`)
3. Commit 你的修改 (`git commit -m 'Add amazing prompt'`)
4. Push 到 branch (`git push origin feature/amazing-prompt`)
5. 開一個 Pull Request

## 命名規範

- 檔案名稱使用 **snake_case**
- Prompt 模板使用 `.md` 副檔名
- 變數使用 `{{VARIABLE_NAME}}` 格式

## 提交訊息格式

```
類型: 簡短描述

- 詳細說明（如需要）
```

類型：
- `feat`: 新增 prompt 或 example
- `fix`: 修正現有內容
- `docs`: 文件更新
- `chore`: 維護性修改

## 問題回報

使用 GitHub Issues，並選擇適當的模板：
- Bug Report：報告問題
- Feature Request：建議新功能或 prompt

## 測試你的貢獻

提交 PR 前，請確保通過以下驗證：

```bash
# 驗證專案結構
./scripts/agent.sh verify

# 檢查敏感資訊
./scripts/check_secrets.sh
```

如果有新增 example，請確認：
- `SPEC.md` 清楚描述功能
- `jules_task.md` 可直接使用
- `nanobanana_prompts/` 有對應的產圖 prompt
- `EXPECTED_OUTPUT.md` 說明預期產出

