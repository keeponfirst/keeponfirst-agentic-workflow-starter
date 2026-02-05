---
description: 使用 Agentic Workflow 開發新功能（PLAN → ASSETS → DESIGN → CODE → REVIEW → RELEASE）。預設使用 Stitch + Jules CLI（Google 生態系）。
---

# Agentic Workflow 開發流程

當用戶要求開發新功能時，請按照以下 5 個 Phase 執行：

## Phase 1: PLAN

1. 建立 `plans/<feature_name>.md` 規劃文件
2. 內容包含：
   - 功能概述
   - 技術設計
   - 素材需求（給 Gemini CLI Nano Banana）
   - 程式任務（給 Jules）
   - 驗收標準
3. 請用戶確認規劃

### 決策快照 (Decision Snapshot)

每個 `plans/<feature>.md` 結尾必須附上決策快照：

```markdown
## 決策快照

| 項目 | 內容 |
|------|------|
| Feature Name | `<feature_name>` |
| 決策時間 | `YYYY-MM-DD HH:MM` |
| 已核准的關鍵範圍 | 1. ... 2. ... |
| 已否決的項目 | - ... |
| Human Gate 勾選結果 | ✅ 功能範圍 / ✅ 視覺風格 / ... |
| Open Questions | ⚠️ 未決不可進下一階段 |
```

### Human Gate 模板

用戶回覆需使用固定模板（見 `templates/human_gate_template.md`）：

- [ ] **功能範圍**：同意 / 不同意
- [ ] **視覺風格**：同意 / 不同意
- [ ] **資料模型**：同意 / 不同意
- [ ] **風險/合規**：同意 / 不同意

> ⚠️ 未勾選即視為未核准，流程不會進入下一階段。

## Phase 2: ASSETS (Browser Generation)

如果有圖片需求：

1. 在 `nanobanana/queue/` 建立 prompt 檔案
2. 使用 browser_subagent 開啟 Gemini 網頁版：
   - 檢查登入狀態
   - **若未登入**：Antigravity 暫停，請用戶在該視窗完成登入
   - 輸入 prompt 並產圖
3. 下載圖片到 `assets/generated/`
4. 驗證品質後將圖片複製到目標位置
5. 將完成的 prompt 移到 `nanobanana/completed/`

**Hybrid 原則**：
- 用戶需先登入 Google 帳號（一次性）
- Antigravity 自動化操作 Gemini 介面
- 若自動化失敗，回退到手動模式

**Fallback（手動模式）**：
- 用戶手動在 Gemini 網頁產圖
- 完成後告知 Antigravity：「圖產好了」或「/kof resume」

## Phase 2.5: DESIGN (選用)

如果需要 UI 設計（layout、wireframe、完整 UI）：

> **預設使用 Stitch**（Google 生態系，與 Gemini CLI 整合良好）。  
> **可選：Pencil**（移動 app、設計系統，詳見 `docs/PENCIL_MCP_SETUP.md`）。

### 前置條件

1. 安裝 MCP Server 依賴：
```bash
cd stitch/mcp-server && npm install && cd ../..
```

2. 設定 `.mcp.json`（複製範例並填入 Project ID）：
```bash
cp .mcp.json.example .mcp.json
# 編輯 .mcp.json，填入 GOOGLE_CLOUD_PROJECT
```

3. 確保已登入 gcloud：
```bash
gcloud auth application-default login
```

### 選項 A：使用 Stitch（預設，推薦）

#### 步驟（自動化模式 - 推薦）

1. **Antigravity 準備設計需求**
   - 建立 `stitch/queue/<feature>.md` 描述設計需求

2. **Antigravity 直接呼叫 Stitch MCP Tools**
   - 使用 `list_projects` 列出現有專案
   - 如需新專案：使用 `create_project`（注意參數是 `title`）
   - 使用 `generate_screen_from_text` 生成新設計（注意參數是 `projectId` / `prompt` / `deviceType` / `modelId`）
   - 使用 `get_screen` 取得 screen 的 `screenshot.downloadUrl` 與 `htmlCode.downloadUrl`
   - 下載/落地產物（見下方「輸出契約」）

3. **落地產物（輸出契約 / Artifact Contract）**

```
stitch/designs/<feature>/
  tokens.json            # 設計系統 token（必要）
  screen_main.png
  screen_main.html
  screen_main.meta.json
```

   - `tokens.json` **最少包含**：
     - `colors`
     - `typography`
     - `spacing`
     - `cornerRadius`
   - `screen_main.meta.json` 至少包含：`projectId`、`screenId`、`sessionId`、`screenshot.downloadUrl`、`htmlCode.downloadUrl`

4. **Stitch Clean Room 步驟**

   DESIGN 完成時，執行以下清理：
   - 列出需要刪除或忽略的元素（如 FAB / bottom nav / extra cards）
   - 記錄「刪除清單」

   **轉譯規則**：
   1. HTML 結構與數值優先
   2. 截圖用於視覺校正
   3. 若 HTML 與截圖衝突，記錄在 CODE 註記

5. **繼續 CODE Phase**
   - 設計作為 Jules 任務的輸入參考
   - 將 `stitch/queue/<feature>.md` 移到 `stitch/completed/<feature>.md`（代表 DESIGN 完成，可繼續）

### Design Verified Checklist

DESIGN 完成前必須確認：

- [ ] Light Mode 有對應檔（若適用）
- [ ] Dark Mode 有對應檔（若適用）
- [ ] 核心元件齊全（header / card / button / empty state）
- [ ] 是否包含 out-of-scope 元素？
  - 若有，列「刪除清單」：...
- [ ] 若任一項未達標 → 標記「部分完成」，CODE 階段需註明風險

### SwiftUI / React / HTML Mapping 檢核表

| 元件 | SwiftUI | React | HTML |
|------|---------|-------|------|
| header | ✅ / ❌ | ✅ / ❌ | ✅ / ❌ |
| cards | ✅ / ❌ | ✅ / ❌ | ✅ / ❌ |
| badges | ✅ / ❌ | ✅ / ❌ | ✅ / ❌ |
| empty state | ✅ / ❌ | ✅ / ❌ | ✅ / ❌ |
| background/gradient | ✅ / ❌ | ✅ / ❌ | ✅ / ❌ |
| typography | ✅ / ❌ | ✅ / ❌ | ✅ / ❌ |
| spacing | ✅ / ❌ | ✅ / ❌ | ✅ / ❌ |

### Stitch MCP Tools 參考

| Tool | 功能 |
|------|------|
| `list_projects` | 列出所有專案 |
| `create_project` | 建立新專案 |
| `list_screens` | 列出專案中的畫面 |
| `generate_screen_from_text` | 從文字生成新畫面 |
| `extract_design_context` | 擷取設計 DNA（字型、顏色、佈局） |
| `fetch_screen_code` | 下載畫面 HTML |
| `fetch_screen_image` | 下載畫面截圖 |

### Fallback：手動模式（Gemini CLI）

若自動化模式失敗，可改用 Gemini CLI：

```bash
gemini
> /stitch Design a mobile login screen with email and social login
> /stitch Download the image of screen <screen_id>
```

完成後告知 Antigravity「設計完成」或 `/kof resume`

### 輸出結構

```
stitch/
├── queue/           # 待設計的需求
├── completed/       # 已完成的需求
└── designs/         # 設計產出
    └── <feature>/
        ├── tokens.json
        ├── screen_main.html
        └── screen_main.png
```

### 選項 B：使用 Pencil（可選，移動 app）

如果需要移動 app 設計或完整設計系統：

1. 在 Cursor 中使用 Pencil MCP 工具設計 UI
2. 設計完成後，可選擇轉碼為 SwiftUI/React Native
3. 將設計檔案（`.pen`）保存到 `designs/<feature>/`
4. 通知 Antigravity「設計完成」繼續流程

詳見 `docs/PENCIL_MCP_SETUP.md`。

### 注意事項

- DESIGN 是選用階段，純邏輯功能可跳過
- **預設使用 Stitch**（Google 生態系）
- 設計稿作為 CODE 任務的參考輸入
- Stitch HTML 輸出使用 Tailwind CSS（CDN）
- 詳細設定參考：`docs/STITCH_INTEGRATION.md`

## Phase 3: CODE

> **預設使用 Jules CLI**（Google 生態系，支援非同步執行，每日 100 tasks 免費）。  
> **可選：Codex CLI**（本地即時執行，需要 OpenAI API key）。

### DESIGN 交接（若 Phase 2.5 有使用 Stitch/Pencil）

- 如果存在 `stitch/designs/<feature>/`（或 `designs/<feature>/` 的 `.pen`），請在 `jules/tasks/<task>.md` 的 **Input Files (Read Only)** 明確列出：
  - `stitch/designs/<feature>/tokens.json`（設計 token）
  - `stitch/designs/<feature>/screen_main.png`
  - `stitch/designs/<feature>/screen_main.html`（若有）
  - `stitch/designs/<feature>/screen_main.meta.json`
  - 以及 Phase 2 產生的圖片素材（如 `assets/generated/...`）
- Jules 的 UI 實作規格以這些設計產物為準，避免「設計做了但 CODE 端不知道要照哪個版本」。

### 選項 A：使用 Jules CLI（預設，推薦）

// turbo
1. 在 `jules/tasks/` 建立任務檔案

// turbo
2. 使用 `jules new --repo <repo> "$(cat jules/tasks/<task>.md)"` 提交任務

// turbo
3. 執行 `./scripts/agent.sh watch <session_id>` 啟動背景監控

4. 等待 Jules 完成（監控會自動喚醒 Antigravity 進行 Review）

5. 如果 Jules 產出空檔案，使用 retry 機制重新提交

### 選項 B：使用 Codex CLI（可選，非 Google 生態系）

如果需要本地即時執行：

1. 準備任務檔案（格式與 Jules 相同）
2. 使用 Codex CLI 執行：
   ```bash
   codex execute --task "jules/tasks/<task>.md"
   ```
3. Codex 會直接修改本地檔案
4. 手動 review 變更並繼續 Phase 4

**注意**：Codex CLI 需要 OpenAI API key，且無法使用 watch 自動化流程。

## Phase 4: REVIEW

> **⚠️ REVIEW 只做「bug/偏差修正」**  
> 新功能或範圍變更一律回 PLAN。

1. 執行 `git diff` 檢查變更內容（Jules patch 或 Codex 直接修改）
2. 在瀏覽器中驗證 UI（如適用）
3. 確認符合驗收標準
4. 如有問題，回到 Phase 3 修正

### REVIEW 結果標記

每項檢查需標記狀態：

| 符號 | 狀態 |
|------|------|
| ✅ | 修正完成 |
| ⚠️ | 未解決（記錄原因） |
| 🔴 | 遺留風險（需追蹤） |

> **注意**：Jules CLI 使用 watch 命令可自動化 Review 流程。Codex CLI 需手動 review。

## Phase 5: RELEASE

### 1. 更新文件 (Documentation Sync)

RELEASE 前，請確認文件已反映現況：
- [ ] **更新專案文件**：如 `README.md`、`docs/` 若功能影響使用方式或架構
- [ ] **更新 PLAN 狀態**：將 `plans/<feature>.md` 中的待辦事項標記為完成

### 2. 驗收快照 (Release Snapshot)

RELEASE 前必須附上驗收快照：

```markdown
## 驗收快照

| 項目 | 狀態 |
|------|------|
| 已完成的驗收項目 | 1. ... 2. ... |
| 未完成的驗收項目與理由 | - ... (理由：...) |
| 已知限制 | - ... |
| 下一步建議 | - ... |
```

### 執行 Release

// turbo
1. `git add -A && git status` 確認變更

// turbo
2. 使用描述性 commit message：

```bash
git commit -m "feat: <功能名稱>

## Workflow Executed
- Phase 1 PLAN: <plan file>
- Phase 2 ASSETS: <assets created>
- Phase 2.5 DESIGN: Stitch/Pencil (if used)
- Phase 3 CODE: Jules CLI session ID / Codex CLI
- Phase 4 REVIEW: Verified
- Phase 5 RELEASE: This commit"
```

// turbo
3. `git push`

---

## 工具鏈設定檢查表

每次開始新功能前，確認工具鏈狀態（見 `templates/tooling_checklist.md`）：

| 項目 | 狀態 | 最後確認時間 |
|------|------|--------------|
| 必要 CLI / SDK 已安裝 | ✅ / ❌ | `YYYY-MM-DD HH:MM` |
| 必要 MCP 可用（若使用） | ✅ / ❌ / N/A | `YYYY-MM-DD HH:MM` |
| 主要設定檔最後更新時間 | — | `YYYY-MM-DD HH:MM` |
| 依賴版本鎖定方式已確認 | ✅ / ❌ | `YYYY-MM-DD HH:MM` |

---

## 觸發關鍵字

用戶說以下詞彙時，啟動此 workflow：

- 「按照 agentic workflow...」
- 「使用 workflow 開發...」
- 「/workflow」
- 「幫我規劃並實作...」

## 注意事項

- 不要跳過任何 Phase
- Phase 2 (ASSETS) 可能不需要（純邏輯功能）
- Phase 2.5 (DESIGN) 可能不需要（純邏輯功能）
- **預設使用 Stitch + Jules CLI**（Google 生態系）
- Pencil 和 Codex CLI 為可選替代方案
- 每個 Phase 完成後更新 plans/<feature>.md 的狀態
- watch 命令會在背景執行，立即返回（僅 Jules CLI）
