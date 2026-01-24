# Pencil Extension 自動 MCP 配置說明

## 核心概念

**「Pencil Extension 自動提供 MCP 功能」** 的意思是：

### 傳統 MCP 配置方式（需要手動配置）

對於**獨立的 MCP server**（如 `penpot-local`），你需要在 `~/.cursor/mcp.json` 中**手動配置**：

```json
{
  "mcpServers": {
    "penpot-local": {
      "type": "sse",
      "url": "http://localhost:4401/sse"
    }
  }
}
```

**為什麼需要手動配置？**
- 這些是**外部服務**，Cursor 不知道它們的存在
- 需要告訴 Cursor：「有一個 MCP server 在 `http://localhost:4401/sse`，請連接它」
- 如果配置錯誤或服務未啟動，MCP 就無法使用

### Pencil Extension 自動配置方式（無需手動配置）

對於 **Cursor Extension**（如 Pencil），**不需要**在 `mcp.json` 中配置：

```json
{
  "mcpServers": {
    "penpot-local": {
      "type": "sse",
      "url": "http://localhost:4401/sse"
    }
    // ❌ 不需要添加 pencil 配置
  }
}
```

**為什麼不需要手動配置？**
- Extension **內建 MCP server**（`mcp-server-darwin-arm64`）
- Extension 在啟動時（`onStartupFinished`）**自動註冊** MCP 功能
- Cursor 會**自動發現**並連接 Extension 提供的 MCP server
- 就像 Extension 提供的其他功能（命令、視圖等）一樣，MCP 也是自動可用的

## 技術細節

### Extension 如何自動註冊 MCP？

1. **Extension 啟動時**
   ```json
   "activationEvents": ["onStartupFinished"]
   ```
   - Extension 在 Cursor 啟動完成後自動啟動

2. **Extension 內建 MCP Server**
   ```
   ~/.cursor/extensions/highagency.pencildev-0.6.10-universal/out/mcp-server-darwin-arm64
   ```
   - Extension 包含編譯好的 MCP server 執行檔
   - 不需要外部服務或網路連接

3. **自動註冊機制**
   - Extension 通過 Cursor 的 Extension API 自動註冊 MCP server
   - Cursor 會自動管理連接和生命週期
   - 不需要手動配置檔案

### 對比圖

```
┌─────────────────────────────────────────────────────────┐
│                    Cursor                               │
│                                                         │
│  ┌──────────────────┐      ┌──────────────────┐         │
│  │  Extension API   │      │   MCP Config    │         │
│  │  (自動註冊)      │      │  (手動配置)      │         │
│  └────────┬─────────┘      └────────┬─────────┘       │
│           │                          │                  │
│           │                          │                  │
│  ┌────────▼─────────┐      ┌────────▼─────────┐       │
│  │  Pencil          │      │  penpot-local    │       │
│  │  Extension       │      │  (外部服務)       │       │
│  │                  │      │                  │       │
│  │  ✅ 自動連接      │      │  ⚠️ 需手動配置    │       │
│  │  ✅ 內建 server   │      │  ⚠️ 需外部服務   │       │
│  │  ✅ 無需配置      │      │  ⚠️ 需網路連接   │       │
│  └──────────────────┘      └──────────────────┘       │
└─────────────────────────────────────────────────────────┘
```

## 實際測試結果

### 測試 1：檢查 MCP 配置
```bash
cat ~/.cursor/mcp.json
```
**結果**：只有 `penpot-local`，**沒有** `pencil` 配置

### 測試 2：使用 Pencil MCP
```javascript
// 成功創建設計
mcp_highagency_pencildev-extension-pencil_batch_design(...)
```
**結果**：✅ **完全可用**，無需任何配置

### 結論

Pencil Extension 的 MCP 功能是**自動可用**的，因為：
1. Extension 內建 MCP server
2. Extension 自動註冊到 Cursor
3. 不需要手動配置 `mcp.json`

## 常見問題

### Q: 為什麼我之前添加的 pencil 配置被移除了？

**A**: 因為不需要！Extension 會自動處理，手動配置反而可能造成衝突。

### Q: 如果 Extension 更新了，MCP 會自動更新嗎？

**A**: 是的。Extension 更新時，新的 MCP server 會自動替換舊的。

### Q: 我可以同時使用 Extension 和手動配置的 MCP 嗎？

**A**: 可以。Extension 的 MCP 和手動配置的 MCP（如 `penpot-local`）可以並存。

### Q: 如何確認 Pencil MCP 是否正常工作？

**A**: 直接使用即可。如果 Extension 已安裝並啟用，MCP 功能應該立即可用。

## 總結

| 特性 | 手動配置的 MCP | Extension 自動 MCP |
|------|---------------|-------------------|
| 配置方式 | 需編輯 `mcp.json` | 無需配置 |
| 服務來源 | 外部服務/應用 | Extension 內建 |
| 連接方式 | 手動指定 URL/命令 | 自動註冊 |
| 維護成本 | 需手動更新配置 | 自動更新 |
| 範例 | `penpot-local` | `pencil` |

**關鍵點**：Extension 提供的 MCP 功能就像 Extension 提供的其他功能一樣，是**自動可用**的，不需要額外配置。
