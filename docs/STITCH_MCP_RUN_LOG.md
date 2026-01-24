# Stitch MCP 使用紀錄（BabyLog 實測）與 Workflow 交接建議

本文件記錄一次完整的 **Stitch MCP** 設計生成實測（新增 BabyLog 首頁），並整理「Phase 2.5 DESIGN → Phase 3 CODE」要如何更新 workflow 才能**自動往下走**。

---

## 1) 前置條件（這次實測的環境狀態）

- **gcloud ADC 已登入**：
  - `gcloud auth application-default login`
  - `gcloud config set project <PROJECT_ID>`
- **Stitch MCP Server 可用**：
  - Cursor 已載入 Stitch MCP tools（本次在 Cursor 的 MCP tool registry 看到 `user-stitch`）
  - Stitch tools schema 可在 Cursor 端看到：`mcps/user-stitch/tools/*.json`

> 註：`user-stitch` 是 **Cursor 內部用來辨識 MCP server 的 identifier**（server name 仍是 `stitch`）。  
> 本次實測是透過 Cursor 已註冊的 `stitch` MCP server 直接呼叫 tools；而本 repo 也保留一份可自維護的 **自建 MCP wrapper**（`stitch/mcp-server/src/index.js`，Strategy C）用來提供/包裝 Stitch MCP 能力（包含額外的 `fetch_screen_image` / `fetch_screen_code` 這類便利工具）。

---

## 2) 這次實測的「最小可重現」流程（MCP tools）

### Step A — 列出專案（確認連線 OK）

工具：`list_projects`

參數：

```json
{ "filter": "view=owned" }
```

輸出：取得 `projects[]`（每個 `project.name` 格式為 `projects/<id>`）。

### Step B — 建立 BabyLog 專案（若尚未存在）

工具：`create_project`

> 重要：此 tool **用的是 `title`**（不是 `name`）。

參數：

```json
{ "title": "BabyLog" }
```

輸出：`name: "projects/<project_id>"`（本次為 `projects/5804119508173637902`）。

### Step C — 以文字生成畫面

工具：`generate_screen_from_text`

> 重要：tool schema 使用的欄位是 **`projectId` / `prompt` / `deviceType` / `modelId`**。

參數（節錄）：

```json
{
  "projectId": "5804119508173637902",
  "prompt": "<stitch/queue/babylog_home_screen.md 的 Design Prompt for Stitch 區塊>",
  "deviceType": "MOBILE",
  "modelId": "GEMINI_3_FLASH"
}
```

輸出（關鍵欄位）：
- `sessionId`: `13394353588662222159`
- `outputComponents[0].design.screens[0].name`: `projects/5804119508173637902/screens/44ff348990744db28292fa8267575bf6`
- `outputComponents[0].design.screens[0].screenshot.downloadUrl`
- `outputComponents[0].design.screens[0].htmlCode.downloadUrl`

### Step D — 取得畫面細節（可選，但建議做成標準步驟）

工具：`get_screen`

參數：

```json
{
  "projectId": "5804119508173637902",
  "screenId": "44ff348990744db28292fa8267575bf6"
}
```

輸出：可再次拿到 `screenshot.downloadUrl` 與 `htmlCode.downloadUrl`（用於落地檔案或除錯）。

### Step E — 下載產物（截圖 + HTML）

本 repo 目標是「產物要落地到工作區，讓下一步 CODE 能引用」；因此需要把：
- **PNG 截圖**
- **HTML（Stitch 輸出）**

落到固定位置（建議用固定檔名），例如：

```
stitch/designs/babylog/
  screen_main.png
  screen_main.html
  screen_main.meta.json
```

本次實測落地結果（已存在於 repo 工作區）：
- `stitch/designs/babylog/babylog_home_screen.png`
- `stitch/designs/babylog/babylog_home_screen.html`
- `stitch/designs/babylog/babylog_home_screen.meta.json`

---

## 3) 這次實測的輸出資訊（可追溯）

- **Project**
  - title: `BabyLog`
  - projectId: `5804119508173637902`
- **Screen**
  - title: `BabyLog Home Screen`
  - screenId: `44ff348990744db28292fa8267575bf6`
- **Session**
  - sessionId: `13394353588662222159`

---

## 4) Workflow 要怎麼更新，才能「DESIGN 完就能進 CODE」

目前 workflow 文件已描述「DESIGN 使用 Stitch」，但缺少兩個關鍵：

### A. 明確的「輸出契約（Artifact Contract）」

DESIGN 結束時，必須產生一個**固定、可被 CODE 直接引用**的輸出集合：

1. `stitch/designs/<feature>/screen_main.png`
2. `stitch/designs/<feature>/screen_main.html`
3. `stitch/designs/<feature>/screen_main.meta.json`（至少包含 `projectId/screenId/sessionId/downloadUrl`）

這樣 Jules 任務就能穩定引用這些檔案做 UI 實作，不會卡在「設計做完了但找不到檔案」。

### B. 明確的「交接動作（Handoff Actions）」

DESIGN 完成後要做三件事，workflow 才能繼續：

1. **把 `stitch/queue/<feature>.md` 移到 `stitch/completed/<feature>.md`**
2. **在 `PLAN.md`（或產生的 CODE 任務檔）附上設計產物路徑**
3. **產生/更新 `jules/tasks/<feature>.md`，把設計產物列為 Input Files**

### C. 移除「需要人手動去 Stitch UI 下載檔案」的步驟

對「progress without human presence」來說，Phase 2.5 的預設路徑應該是：

- Stitch MCP：`generate_screen_from_text` → `get_screen` → 下載 screenshot/html → 落地檔案

Gemini CLI `/stitch` 下載畫面應退回為 fallback（工具故障才用）。

---

## 5) 建議更新點（對應要改哪些文件）

- `docs/WORKFLOW.md`
  - Phase 2.5 (DESIGN) 的 Stitch 路徑要把「MCP 自動落地產物 + 交接」寫清楚
- `.agent/workflows/workflow.md`
  - 讓 orchestrator 有「固定輸出契約」與「交接動作」可依循，做完 DESIGN 就能自動進 CODE

