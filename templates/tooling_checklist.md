# Tooling Checklist

每次開始新功能前填寫，確認工具鏈狀態。

---

## 檢查項目

| 項目 | 狀態 | 最後確認時間 |
|------|------|--------------|
| 必要 CLI / SDK 已安裝 | ✅ / ❌ | `YYYY-MM-DD HH:MM` |
| 必要 MCP 可用（若使用） | ✅ / ❌ / N/A | `YYYY-MM-DD HH:MM` |
| 主要設定檔最後更新時間 | — | `YYYY-MM-DD HH:MM` |
| 依賴版本鎖定方式已確認 | ✅ / ❌ | `YYYY-MM-DD HH:MM` |

---

## 詳細檢查

### CLI / SDK

```bash
# Jules CLI
jules --version && jules remote list

# Stitch MCP
cd stitch/mcp-server && npm list

# Gemini CLI (if used)
gemini --version
```

### MCP Server

```bash
# 確認 .mcp.json 存在且格式正確
cat .mcp.json | jq .

# 確認 gcloud 已登入
gcloud auth application-default print-access-token > /dev/null && echo "✅ gcloud OK"
```

### 設定檔

- `.mcp.json`
- `.env` / `.env.example`
- `stitch/mcp-server/package.json`

---

## 範例填寫

| 項目 | 狀態 | 最後確認時間 |
|------|------|--------------|
| 必要 CLI / SDK 已安裝 | ✅ | 2026-02-04 09:45 |
| 必要 MCP 可用（若使用） | ✅ | 2026-02-04 09:45 |
| 主要設定檔最後更新時間 | — | 2026-02-03 14:30 |
| 依賴版本鎖定方式已確認 | ✅ | 2026-02-04 09:45 |
