# Stitch Integration 研究與決策

> 文件版本: 2.0
> 決策日期: 2026-01-23
> 狀態: **採用 Strategy C (Direct MCP via stitch-mcp)**

## Executive Summary

本文件記錄將 Stitch（Google AI UI 設計工具）整合至 KeepOnFirst Agentic Workflow 的研究過程與決策。

### 決策歷程

| 版本 | 決策 | 原因 |
|------|------|------|
| v1.0 | Strategy A (Gemini CLI) | MCP tools 未文件化、需手動 token |
| v2.0 | Strategy C (社群 stitch-mcp) | MCP tools 已文件化 |
| **v3.0** | **Strategy C (自建 MCP Server)** | 官方 API 已確認、自建可控性更高 |

### 當前推薦

**Primary**: Strategy C (npm 套件 `@keeponfirst/kof-stitch-mcp`)
- 📦 **npm**: [`@keeponfirst/kof-stitch-mcp`](https://www.npmjs.com/package/@keeponfirst/kof-stitch-mcp)
- 📂 **GitHub**: [`keeponfirst/kof-stitch-mcp`](https://github.com/keeponfirst/kof-stitch-mcp)
- 基於官方 Google Stitch MCP API (`stitch.googleapis.com/mcp`)
- Antigravity 可直接呼叫 Stitch tools
- 完全自動化，認證使用 gcloud ADC
- 使用 `npx` 自動下載執行，零設定

**Fallback**: Strategy A (Gemini CLI Interactive)
- 用於互動式設計探索
- MCP server 失效時的備案

---

## 驗證事實

### Stitch Extension 資訊

| 項目 | 值 | 驗證方式 |
|------|----|---------|
| Extension 版本 | v0.1.0 | `gemini extensions list` |
| 安裝路徑 | `~/.gemini/extensions/Stitch/` | 檔案系統 |
| MCP Server URL | `https://stitch.googleapis.com/mcp` | `gemini-extension.json` |
| 認證方式 | Google ADC (`google_credentials`) | `gemini-extension.json` |
| OAuth Scope | `https://www.googleapis.com/auth/cloud_platform` | `gemini-extension.json` |
| 價格 | 免費 | `README.md` |

### Stitch 功能

| 功能 | 指令範例 | 已驗證 |
|------|---------|--------|
| 列出專案 | `/stitch What projects do I have?` | 待測試 |
| 生成設計 | `/stitch Design a mobile login screen` | 待測試 |
| 下載圖片 | `/stitch Download the image of screen <id>` | 待測試 |
| 下載 HTML | `/stitch Download the HTML of screen <id>` | 待測試 |
| 優化 Prompt | `/stitch Enhance this prompt: "..."` | 待測試 |

### Claude Code MCP 支援

| 功能 | 支援狀態 |
|------|----------|
| HTTP Transport | ✅ 支援 |
| Custom Headers | ✅ 支援 |
| Bearer Token Auth | ✅ 支援 |
| Google ADC (自動) | ❌ 不支援 |

---

## 策略比較

### Strategy A: Gemini CLI Interactive (Fallback)

```
Antigravity → 準備需求 → 用戶 → Gemini CLI → /stitch → 輸出
                              ↑
                          手動介入點
```

**優點**：
- 官方支援的整合方式
- ADC 認證由 Gemini CLI 處理
- 互動式，可即時調整設計

**缺點**：
- 需要用戶手動操作
- Context 切換（IDE ↔ Terminal）

**風險等級**: 🟢 低
**角色**: Fallback / 互動式探索

### Strategy C: MCP Server (推薦)

```
Antigravity → MCP tools → kof-stitch-mcp → Google Stitch API
                               ↑                    ↑
                          npm 套件             官方 JSON-RPC API
                    @keeponfirst/kof-stitch-mcp   (stitch.googleapis.com/mcp)
```

**架構**：
- 官方 API：`https://stitch.googleapis.com/mcp` (JSON-RPC 2.0)
- MCP Server：[`@keeponfirst/kof-stitch-mcp`](https://www.npmjs.com/package/@keeponfirst/kof-stitch-mcp) (stdio MCP)
- 認證：gcloud Application Default Credentials

**設定**：
```json
// .mcp.json
{
  "mcpServers": {
    "stitch": {
      "command": "npx",
      "args": ["-y", "@keeponfirst/kof-stitch-mcp"],
      "env": {
        "GOOGLE_CLOUD_PROJECT": "your-project-id"
      }
    }
  }
}
```

**可用 Tools**：

官方 API 提供的工具（透過 `tools/list` 動態取得）：
- `list_projects`, `get_project`, `create_project`
- `list_screens`, `get_screen`
- `generate_screen_from_text`
- ...其他官方工具

自建 wrapper 額外提供：
| Tool | 功能 |
|------|------|
| `fetch_screen_code` | 下載畫面 HTML（包裝 get_screen + download） |
| `fetch_screen_image` | 下載畫面截圖並儲存 PNG |

**優點**：
- ✅ 完全自動化
- ✅ 基於官方 API，長期穩定
- ✅ 專案內自維護，不依賴第三方
- ✅ 可依需求擴充功能
- ✅ 認證使用標準 gcloud ADC

**缺點**：
- 需安裝 npm dependencies
- 需自行維護 wrapper code

**風險等級**: 🟢 低（基於官方 API）
**角色**: Primary

---

## 決策

### 選擇: Strategy C (Primary) + Strategy A (Fallback)

### 理由

1. **完全自動化** - Antigravity 可直接呼叫 Stitch tools
2. **認證已解決** - stitch-mcp 內部處理 ADC，無需手動 token
3. **工具已文件化** - 9 個清晰定義的 tools
4. **原生 Claude Code 支援** - stdio 傳輸，標準設定

### 切換條件

| 條件 | 行動 |
|------|------|
| stitch-mcp 運作正常 | 使用 Strategy C |
| stitch-mcp 失敗 | 切換到 Strategy A |
| 需互動式探索 | 臨時使用 Strategy A |
| stitch-mcp 6 個月無更新 | 評估切回 Strategy A |

---

## 設定步驟

### Strategy C 設定 (推薦)

#### 1. 設定 GCP Project 與認證

```bash
export PROJECT_ID="your-project-id"
gcloud config set project $PROJECT_ID
gcloud auth application-default login
```

#### 2. 確認 Node.js 已安裝

```bash
node --version  # 需要 v18+
```

> 💡 使用 npm 套件不需要本地安裝依賴，`npx` 會自動處理。

#### 3. 建立 MCP 設定（推薦：npm）

複製範例設定：

```bash
cp .mcp.json.example .mcp.json
```

編輯 `.mcp.json`，填入你的 Project ID：

```json
{
  "mcpServers": {
    "stitch": {
      "command": "npx",
      "args": ["-y", "@keeponfirst/kof-stitch-mcp"],
      "env": {
        "GOOGLE_CLOUD_PROJECT": "your-project-id"
      }
    }
  }
}
```

> 📦 **npm 套件**：[`@keeponfirst/kof-stitch-mcp`](https://www.npmjs.com/package/@keeponfirst/kof-stitch-mcp)
>
> 這是最簡單的方式，`npx` 會自動下載並執行最新版本。

#### 3.1 替代方式：本地開發模式

如果你需要修改 MCP Server 或進行除錯：

```bash
# 安裝本地依賴
cd stitch/mcp-server
npm install
cd ../..
```

```json
{
  "mcpServers": {
    "stitch": {
      "command": "node",
      "args": ["stitch/mcp-server/src/index.js"],
      "env": {
        "GOOGLE_CLOUD_PROJECT": "your-project-id"
      }
    }
  }
}
```

#### 3.2 替代方式：Git URL（開發測試用）

直接從 GitHub 執行：

```json
{
  "mcpServers": {
    "stitch": {
      "command": "npx",
      "args": ["-y", "github:keeponfirst/kof-stitch-mcp"],
      "env": {
        "GOOGLE_CLOUD_PROJECT": "your-project-id"
      }
    }
  }
}
```

> 適合測試未發佈的版本或特定 branch。

#### 4. 驗證設定

重啟 Claude Code，確認 Stitch tools 可用。

#### 5. 測試功能

在 Claude Code 中請求：
> "使用 list_projects 列出我的 Stitch 專案"

> 參考：本 repo 有一份完整的實測紀錄（含 tool 參數與輸出契約），可直接複製流程：`docs/STITCH_MCP_RUN_LOG.md`

---

### Strategy A 設定 (Fallback)

#### 1. 設定 GCP Project

```bash
export PROJECT_ID="your-project-id"
gcloud config set project $PROJECT_ID
gcloud auth application-default login
gcloud auth application-default set-quota-project $PROJECT_ID
```

#### 2. 設定 Stitch Extension

```bash
./scripts/agent.sh stitch-setup
```

#### 3. 驗證連線

```bash
./scripts/agent.sh stitch-check
gemini mcp list  # stitch 應顯示 Connected
```

#### 4. 測試功能

```bash
gemini
> /stitch What projects do I have?
```

---

## 檔案結構

```
stitch/
├── mcp-server/           # MCP Server 原始碼（已發佈為 npm 套件）
│   ├── src/index.js      # Server 主程式
│   ├── package.json      # 依賴定義
│   └── README.md         # Server 文件
├── queue/                # 待設計的需求（由 Antigravity 建立）
├── completed/            # 已完成的需求
└── designs/              # Stitch 輸出
    └── <feature>/
        ├── screen_main.html
        └── screen_main.png

prompts/stitch/
└── ui_screen.md          # 設計需求模板

.mcp.json                 # Claude Code MCP 設定（從 .mcp.json.example 複製）
.mcp.json.example         # MCP 設定範例
```

> 💡 **一般使用者只需要** `.mcp.json` 設定檔，npm 套件會自動下載執行。
> `stitch/mcp-server/` 是 MCP Server 的原始碼，已獨立發佈到：
> - npm: [`@keeponfirst/kof-stitch-mcp`](https://www.npmjs.com/package/@keeponfirst/kof-stitch-mcp)
> - GitHub: [`keeponfirst/kof-stitch-mcp`](https://github.com/keeponfirst/kof-stitch-mcp)

---

## 相關文件

- [Stitch Extension README](https://github.com/gemini-cli-extensions/stitch)
- [Stitch Web App](https://stitch.withgoogle.com/)
- [Gemini CLI Extensions](https://google-gemini.github.io/gemini-cli/docs/extensions/)
