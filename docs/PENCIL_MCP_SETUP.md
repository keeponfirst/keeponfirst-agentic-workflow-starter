# Pencil MCP 安裝與配置指南

Pencil.dev 透過 Cursor/Antigravity Extension 提供原生的 MCP 整合，讓 Agent 能直接操作設計畫布。

## 最新整合方式：Native Auto-Config (推薦)

根據 2026/01 的實測，Pencil Extension 具備 **自動配置 (Auto-Provisioning)** 能力。您**不需要**手動編輯 `mcp_config.json`，也**不需要**任何 Bridge 腳本。 Extension 會自動管理連接。

### 步驟

1.  **安裝 Extension**
    *   在 IDE 中安裝 "Pencil" Extension (id: `highagency.pencildev`)。

2.  **觸發自動配置**
    *   安裝後，請**重啟 IDE** 或點擊 MCP Server 列表的 **"Refresh"** 按鈕。
    *   Extension 會自動偵測並將正確的 Port 寫入 `mcp_config.json`。

3.  **驗證**
    *   檢查 `~/.gemini/antigravity/mcp_config.json`，應會自動出現 `"pencil"` 項目。

## 使用關鍵：Active File Requirement

Pencil 的 `batch_design` 工具 (Agent 主要使用的設計工具) 有一個硬性限制：

> **⚠️ 必須在 IDE 中開啟並顯示 `.pen` 檔案**

Agent 無法對「背景」或「未開啟」的檔案進行設計。

### 正確工作流

1.  **建立檔案**：手動建立一個空檔案 (例如 `babylog.pen`)。
2.  **開啟檔案**：在 IDE 編輯器中點開它，讓它處於 **Active (顯示中)** 狀態。
3.  **呼叫 Agent**：這時再對 Agent 下指令：「幫我設計一個登入畫面」。

## 常見問題 (Troubleshooting)

### Q: Agent 說連線失敗 (Connection Refused)？
*   **原因**：Extension 的 Port 可能變了（每次重啟都會變）。
*   **解法**：請按 MCP 列表的 **"Refresh"** 按鈕，讓 Extension 更新設定檔，然後重試。

### Q: Agent 說 "File needs to be open in editor"？
*   **原因**：你沒有打開 `.pen` 檔案。
*   **解法**：請在 IDE 中雙擊該檔案，確保它顯示在畫面上。

### Q: 需要手動設定 Port 嗎？
*   **不需要**。請依賴 Extension 的自動配置功能。手動設定反而會因為 Port 變動而失效。

## 參考資源

- [Pencil.dev 官方網站](https://pencil.dev)
- [Pencil Downloads](https://pencil.dev/downloads)
