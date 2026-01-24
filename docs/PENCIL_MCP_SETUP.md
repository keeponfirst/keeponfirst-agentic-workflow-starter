# Pencil MCP 安裝指南

Pencil.dev 是一個 agent-driven MCP canvas，可以在 Cursor 中直接進行設計，並將設計轉換為程式碼。

## 安裝方式

### 方式 1：桌面應用程式（推薦）

#### macOS 安裝步驟

1. **下載 Pencil**
   - Apple Silicon (M1/M2/M3): [下載 ARM64 版本](https://5ykymftd1soethh5.public.blob.vercel-storage.com/Pencil-mac-arm64.dmg)
   - Intel Mac: [下載 x64 版本](https://5ykymftd1soethh5.public.blob.vercel-storage.com/Pencil-mac-x64.dmg)

2. **安裝應用程式**
   ```bash
   # 下載後，打開 .dmg 檔案
   # 將 Pencil 拖拽到 Applications 資料夾
   ```

3. **啟動 Pencil**
   - 從 Applications 啟動 Pencil
   - 首次啟動可能需要授權（系統偏好設定 > 安全性與隱私）

### 方式 2：Cursor Extension（替代方案）

如果不想安裝桌面應用程式，可以使用 Cursor Extension：

1. 在 Cursor 中打開 Extensions
2. 搜尋 "Pencil" 或 "highagency.pencildev"
3. 安裝並啟用

## 配置 MCP 連接

### 檢查現有配置

你的 MCP 配置檔案位於：`~/.cursor/mcp.json`

目前已有配置：
- `penpot-local` (SSE 連接)

### 添加 Pencil MCP Server

Pencil 的 MCP 連接有兩種方式：

#### 方式 1：使用 Cursor Extension（推薦，最簡單）

1. 在 Cursor 中打開 Extensions（Cmd+Shift+X）
2. 搜尋 "Pencil" 或 "highagency.pencildev"
3. 安裝並啟用 Extension
4. **不需要修改 MCP 配置**，Extension 會自動處理連接

#### 方式 2：桌面應用程式的 MCP 連接

如果使用桌面應用程式並需要直接 MCP 連接：

1. **啟動 Pencil 應用程式**
   ```bash
   open /Applications/Pencil.app
   ```

2. **查看 MCP 連接資訊**
   - 在 Pencil 應用程式中查看設定或說明
   - 通常會顯示 MCP server 的連接方式（stdio 或 SSE）和端口

3. **更新 MCP 配置**

   如果是 **stdio** 連接：
   ```json
   {
     "mcpServers": {
       "penpot-local": {
         "type": "sse",
         "url": "http://localhost:4401/sse"
       },
       "pencil": {
         "type": "stdio",
         "command": "/Applications/Pencil.app/Contents/MacOS/Pencil",
         "args": ["--mcp"]
       }
     }
   }
   ```

   如果是 **SSE** 連接（需要確認端口號）：
   ```json
   {
     "mcpServers": {
       "penpot-local": {
         "type": "sse",
         "url": "http://localhost:4401/sse"
       },
       "pencil": {
         "type": "sse",
         "url": "http://localhost:XXXX/sse"
       }
     }
   }
   ```

   > **注意**：請將 `XXXX` 替換為 Pencil 實際使用的端口號（通常在 Pencil 應用程式的設定或文檔中可找到）

### 驗證連接

1. **重啟 Cursor**（必須重啟才能載入新的 MCP 配置）
2. 在 Cursor 中，Pencil 的功能應該可以透過 MCP 使用
3. 可以嘗試在對話中提及「使用 Pencil 設計」來測試

### 已配置的 MCP Servers

你的 `~/.cursor/mcp.json` 現在包含：
- `penpot-local` (SSE 連接)
- `pencil` (stdio 連接，使用 Extension 的 MCP server)

### 驗證 MCP 是否正常運作

在 Cursor 中：
1. 打開命令面板（Cmd+Shift+P）
2. 搜尋 "MCP" 相關命令
3. 或直接在對話中測試 Pencil 功能

## 使用方式

### 在 Cursor 中使用 Pencil

1. **設計畫布**：在 Cursor 中打開 Pencil 畫布
2. **AI 輔助設計**：使用自然語言描述設計需求
3. **轉換為程式碼**：Pencil 可以將設計轉換為 HTML/CSS/React 程式碼
4. **版本控制**：設計檔案會保存在你的 repository 中

### 與本 Workflow 整合

Pencil 可以與本 workflow 整合：

1. **設計階段**：使用 Pencil 設計 UI
2. **產圖階段**：Pencil 設計可以作為參考給 Gemini CLI
3. **實作階段**：Pencil 產生的程式碼可以作為 Jules 任務的起點

## 故障排除

### Pencil 無法連接

1. 確認 Pencil 應用程式正在運行
2. 檢查 MCP 配置檔案格式是否正確
3. 查看 Cursor 的 MCP 日誌（如果有）

### 找不到 Pencil 命令

如果使用 stdio 連接，確認 Pencil 的可執行檔案路徑：
```bash
# 檢查 Pencil 是否在 Applications
ls -la /Applications/Pencil.app/Contents/MacOS/
```

## 參考資源

- [Pencil.dev 官方網站](https://pencil.dev)
- [Pencil Downloads](https://pencil.dev/downloads)
- [Cursor MCP 文檔](https://docs.mcp.run/mcp-clients/cursor/)

## 注意事項

- Pencil 需要請求訪問權限才能與 Cursor 整合
- 首次使用可能需要登入或註冊
- 設計檔案會保存在專案目錄中，記得加入版本控制
