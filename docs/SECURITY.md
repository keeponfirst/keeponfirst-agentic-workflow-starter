# 安全實踐

這份文件說明如何安全管理 API Keys 和敏感資訊。

---

## 核心原則

> **永遠不要把 API Key commit 到 Git。**

一旦 key 被 commit，即使之後刪除，也可能被從歷史記錄中挖出。

---

## API Key 管理

### 使用 .env 檔案

```bash
# .env（絕對不要 commit）
GEMINI_API_KEY=your_actual_key_here
```

### 使用 .env.example

提供範例給其他人知道需要設定什麼：

```bash
# .env.example（可以 commit）
GEMINI_API_KEY=your_gemini_api_key_here
```

### .gitignore 設定

確保 `.gitignore` 包含：

```
.env
.env.local
.env.*.local
```

---

## 初始化流程

### bootstrap.sh 做的事

```bash
# 複製範例檔
cp .env.example .env

# 提醒使用者
echo "請編輯 .env 填入你的 API Keys"
```

### 使用者需要做的事

1. 取得 Gemini API Key：https://aistudio.google.com/apikey
2. 編輯 `.env` 填入 key
3. 確認 `.env` 不在 git 追蹤中

---

## 敏感資訊掃描

### check_secrets.sh

這個腳本會掃描常見的 key pattern：

```bash
# 掃描的 pattern 包括
- API key patterns (AIza...)
- Secret key patterns
- Token patterns
- Password patterns
```

### 在本地執行

```bash
./scripts/check_secrets.sh
```

### 在 CI 執行

建議在 CI pipeline 中執行 `./scripts/check_secrets.sh`，於每次 PR 時自動掃描敏感資訊。

---

## 常見錯誤

### ❌ 直接寫在程式碼裡

```javascript
// 錯誤！
const API_KEY = "your-api-key-here";
```

### ❌ 用變數但忘記 .gitignore

```bash
# .env 沒加到 .gitignore
# commit 後就來不及了
```

### ❌ 在 log 中印出 key

```python
# 錯誤！
print(f"Using API key: {api_key}")
```

---

## 最佳實踐

### ✅ 使用環境變數

```python
import os
api_key = os.environ.get("GEMINI_API_KEY")
```

### ✅ 驗證 key 存在但不印出

```python
if not api_key:
    raise ValueError("GEMINI_API_KEY not set")
# 不要印出 key 的值
```

### ✅ 定期輪換 key

即使沒有洩漏，也建議定期更換 API key。

### ✅ 使用 key 權限控制

如果服務支援，限制 key 的權限範圍。

---

## 如果 Key 洩漏了

1. **立即撤銷**：到對應服務後台撤銷該 key
2. **產生新 key**
3. **檢查使用記錄**：確認是否有異常使用
4. **清理 Git 歷史**（如果 key 被 commit）：
   ```bash
   # 這很複雜，建議用 BFG Repo-Cleaner
   # https://rtyley.github.io/bfg-repo-cleaner/
   ```
5. **通知團隊**：如果是共用的 key

---

## 安全檢查清單

在 push 之前確認：

- [ ] `.env` 沒有被追蹤
- [ ] 沒有 hardcode 的 key
- [ ] 執行過 `./scripts/check_secrets.sh`
- [ ] 沒有在 log 中印出敏感資訊
