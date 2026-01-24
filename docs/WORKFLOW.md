# 標準工作流程

這份文件描述從「一個功能想法」到「完成交付」的標準流程。

> **設計背景**：本 workflow 源自 Gemini Pro 訂閱與 Google 工具鏈的實戰經驗。核心差異在於：Jules 提供雲端非同步的程式任務執行（每日 100 tasks），Codex CLI 提供本地即時執行，而 Gemini CLI 提供本地化的圖像生成能力（需控制 quota）。這些工具的互補性是本 workflow 的設計出發點。

## Feature Pipeline 總覽

```
┌─────────┐   ┌─────────┐   ┌─────────┐   ┌─────────┐   ┌─────────┐   ┌─────────┐
│  PLAN   │ → │ ASSETS  │ → │ DESIGN  │ → │  CODE   │ → │ REVIEW  │ → │ RELEASE │
│  (1)    │   │  (2)    │   │ (2.5)   │   │  (3)    │   │  (4)    │   │  (5)    │
└─────────┘   └─────────┘   └─────────┘   └─────────┘   └─────────┘   └─────────┘
     │             │             │             │             │             │
     ▼             ▼             ▼             ▼             ▼             ▼
Antigravity  Gemini CLI     Stitch* /   Jules CLI* / Antigravity   Antigravity
             (NanoBanana)   Pencil      Codex CLI
             
             *預設工具（Google 生態系）
```

> **Phase 2.5 (DESIGN)** 是選用階段，僅在需要 UI 設計時使用。**預設使用 Stitch**（Google 生態系）。Pencil 為可選替代方案（移動 app、設計系統）。詳見下方說明。  
> **Phase 3 (CODE)** **預設使用 Jules CLI**（Google 生態系，雲端非同步）。Codex CLI 為可選替代方案（本地即時執行）。詳見下方說明。

---

## Phase 1: PLAN

**執行者**：Antigravity  
**輸入**：功能需求（口語描述或 Issue）  
**輸出**：`PLAN.md`

### 步驟

1. 使用 `prompts/antigravity/plan.md` 模板
2. 描述功能需求
3. Antigravity 產出結構化的 `PLAN.md`

### PLAN.md 內容

- 功能概述
- 需要的素材清單（給 Gemini CLI）
- 需要的程式任務（給 Jules CLI 或 Codex CLI）
- 驗收標準

---

## Phase 2: ASSETS

**執行者**：Gemini CLI (Nano Banana)  
**輸入**：`PLAN.md` 中的素材清單  
**輸出**：`assets/generated/` 中的圖片

### 步驟

1. 執行 `./scripts/agent.sh assets`
2. 腳本會把 prompts 複製到 `nanobanana/queue/`
3. 逐一用 Gemini CLI 執行每個 prompt
4. 圖片產出到 `assets/generated/`

### Nano Banana 原則

- **一次一張**：不要批次產圖
- **明確描述**：prompt 要具體
- **立即確認**：產完一張就確認品質

---

## Phase 2.5: DESIGN (選用)

**預設執行者**：Stitch（Google 生態系）  
**可選執行者**：Pencil（移動 app、設計系統）  
**輸入**：`PLAN.md` 中的 UI 設計需求  
**輸出**：設計稿（`.pen` 檔案或 `stitch/designs/`）

> 此階段僅在需要 UI layout、wireframe 或完整 UI 設計時使用。純邏輯功能可跳過。  
> **預設使用 Stitch**（Google 生態系，與 Gemini CLI 整合良好）。Pencil 為可選替代方案。

### 工具選擇

| 面向 | Stitch（預設） | Pencil（可選） |
|------|---------------|---------------|
| **適用場景** | Web UI、快速原型、HTML 輸出 | 移動 app、需要精細控制、設計系統 |
| **輸出格式** | HTML + 圖片 | `.pen` 檔案（可轉碼為 SwiftUI/React Native） |
| **整合方式** | Gemini CLI 或 MCP Server | Cursor Extension（自動 MCP） |
| **轉碼能力** | ❌ 僅 HTML | ✅ 可轉換為程式碼 |
| **設計系統** | ⚠️ 基礎支援 | ✅ 完整設計系統支援 |
| **互動性** | ✅ 可迭代調整 | ✅ 可迭代、可轉碼 |
| **生態系** | ✅ Google 生態系 | ⚠️ 獨立工具 |

**選擇建議**：
- **預設** → 使用 **Stitch**（Google 生態系，與本 workflow 整合良好）
- **移動 app** → 可選 **Pencil**（可轉碼為 SwiftUI/React Native）
- **需要設計系統** → 可選 **Pencil**
- **Web app** → 使用 **Stitch**（直接輸出 HTML）

---

### 選項 A：使用 Stitch（預設，推薦）

#### 前置設定（推薦：MCP 自動化）

1. 確認 Cursor/IDE 已載入 Stitch MCP tools（可用 `list_projects` 測試）
2. 確認 gcloud ADC 已登入：

```bash
gcloud auth application-default login
gcloud config set project <PROJECT_ID>
```

> 若 MCP tools 不可用，再使用 Gemini CLI `/stitch` 當 fallback（見下方）。

#### 步驟（MCP 自動化，讓 workflow 能無人值守繼續往下）

1. 在 `stitch/queue/<feature>.md` 寫清楚設計需求（可包含一段 `Design Prompt for Stitch`）
2. 使用 Stitch MCP tools 生成畫面：
   - `list_projects`（找既有專案或確認連線）
   - `create_project { "title": "<feature>" }`（若尚無專案）
   - `generate_screen_from_text { projectId, prompt, deviceType:"MOBILE" }`
   - `get_screen { projectId, screenId }`（取得 downloadUrl/尺寸等）
3. **落地產物（輸出契約）**到固定位置（建議用固定檔名，讓後續 CODE 容易引用）：

```
stitch/designs/<feature>/
  screen_main.png
  screen_main.html
  screen_main.meta.json
```

其中 `screen_main.meta.json` 至少包含：`projectId`、`screenId`、`sessionId`、`screenshot.downloadUrl`、`htmlCode.downloadUrl`

4. **交接到 CODE**（讓 workflow 自動前進）：
   - 將 `stitch/queue/<feature>.md` 移到 `stitch/completed/<feature>.md`
   - 在 Jules 任務中把設計產物加入 Input Files（例如 `stitch/designs/<feature>/screen_main.png`、`screen_main.html`）
   - 進入 Phase 3: CODE（Jules CLI 預設）

#### 更多資訊

詳見：
- [STITCH_INTEGRATION.md](./STITCH_INTEGRATION.md)
- [STITCH_MCP_RUN_LOG.md](./STITCH_MCP_RUN_LOG.md)（BabyLog 實測紀錄與交接建議）

---

### 選項 B：使用 Pencil（可選）

#### 前置設定

Pencil 透過 Cursor Extension 自動提供 MCP 功能，無需額外設定。

1. 在 Cursor 中安裝 Pencil Extension
2. 確認 MCP 已自動連接（Extension 會自動處理）

詳見 [PENCIL_MCP_SETUP.md](./PENCIL_MCP_SETUP.md)。

#### 步驟

1. 在 Cursor 中使用 Pencil MCP 工具設計 UI
2. 設計完成後，可選擇：
   - **選項 1**：直接使用設計作為參考，手動實作
   - **選項 2**：使用 Pencil 轉碼功能，生成 SwiftUI/React Native 程式碼
3. 將設計檔案（`.pen`）保存到 `designs/<feature>/`
4. 通知 Antigravity「設計完成」繼續流程

#### Pencil 設計範例

```javascript
// 使用 Pencil MCP 建立設計
mcp_highagency_pencildev-extension-pencil_batch_design({
  operations: [
    "screen=I(document, {type: 'frame', name: 'Home Screen', ...})",
    // ...
  ]
})
```

#### 轉碼為程式碼（可選）

Pencil 可以將設計轉換為對應框架的程式碼：
- iOS app → SwiftUI
- React Native → React Native Components
- Web app → React/Tailwind

詳見 [PENCIL_NEXT_STEPS.md](./PENCIL_NEXT_STEPS.md)。

---

### 設計工具與 Nano Banana 的區別

| 面向 | Pencil | Stitch | Nano Banana |
|------|--------|--------|-------------|
| 用途 | UI 設計、設計系統、可轉碼 | UI layout、完整畫面設計 | 圖示、插圖、hero 圖片 |
| 輸出 | `.pen` 檔案（可轉碼） | HTML + 圖片 | 圖片 |
| 互動 | 可迭代、可轉碼 | 可迭代調整 | 單次生成 |
| 適用 | 移動 app、設計系統 | Web app、快速原型 | 素材生成 |

---

## Phase 3: CODE

**預設執行者**：Jules CLI（Google 生態系）  
**可選執行者**：Codex CLI（本地即時執行）  
**輸入**：`PLAN.md` 中的程式任務 + 素材 +（若 Phase 2.5 有使用）`stitch/designs/<feature>/` 的設計產物  
**輸出**：程式碼 PR 或 patch

> **預設使用 Jules CLI**（Google 生態系，與 Antigravity 整合良好，支援非同步執行）。Codex CLI 為可選替代方案。

### 工具選擇

| 面向 | Jules CLI（預設） | Codex CLI（可選） |
|------|------------------|------------------|
| **適用場景** | 雲端非同步執行、長時間任務 | 本地執行、即時回饋 |
| **執行方式** | 雲端執行（不佔本地資源） | 本地執行（需要本地環境） |
| **Quota** | 每日 100 tasks（免費） | 依 OpenAI API 計費 |
| **非同步** | ✅ 可離線執行 | ❌ 需保持連線 |
| **整合** | ✅ Google 生態系 | ⚠️ OpenAI 生態系 |
| **輸出** | Patch 檔案 | 直接修改檔案 |

**選擇建議**：
- **預設** → 使用 **Jules CLI**（Google 生態系，非同步執行，免費額度）
- **需要即時回饋** → 可選 **Codex CLI**（本地執行）
- **長時間任務** → 使用 **Jules CLI**（不佔本地資源）
- **簡單快速任務** → 使用 **Jules CLI**（預設）

---

### 選項 A：使用 Jules CLI（預設，推薦）

#### 前置設定

```bash
# 安裝 Jules CLI
npm install -g @google/jules

# 登入
jules login
```

#### 步驟

1. 執行 `./scripts/agent.sh jules`
2. 腳本會產出任務到 `jules/tasks/`
3. 使用 Jules CLI 建立 session：`jules new "task description"`
4. **自動化流程**：執行 `./scripts/agent.sh watch <session_id>`
   - 自動輪詢 Jules 狀態
   - 完成後自動拉取並套用 patch
   - 喚醒 Antigravity agent 進行 Review

#### Jules 優勢

- ✅ **非同步執行**：可離線執行，不佔本地資源
- ✅ **免費額度**：每日 100 tasks
- ✅ **自動化**：watch 命令自動處理整個流程
- ✅ **Google 生態系**：與 Antigravity、Gemini CLI 整合良好

---

### 選項 B：使用 Codex CLI（可選，非 Google 生態系）

#### 前置設定

```bash
# 安裝 Codex CLI
# 參考：https://developers.openai.com/codex/cli

# 設定 API Key
export OPENAI_API_KEY="your-api-key"
```

#### 步驟

1. 執行 `./scripts/agent.sh codex`（如果支援）或手動準備任務
2. 使用 Codex CLI 執行任務：
   ```bash
   codex execute --task "jules/tasks/your_task.md"
   ```
3. Codex 會直接修改本地檔案
4. 手動 review 變更並 commit

#### Codex 優勢

- ✅ **即時回饋**：本地執行，立即看到結果
- ✅ **直接修改**：直接修改檔案，無需 patch
- ✅ **靈活控制**：可隨時中斷和調整

#### Codex 限制

- ⚠️ **需要本地環境**：必須有完整的開發環境
- ⚠️ **API 費用**：依 OpenAI API 計費
- ⚠️ **需保持連線**：無法離線執行

---

### 任務拆分原則

無論使用哪個工具，都遵循以下原則：

- **單一職責**：一個 task 做一件事
- **明確輸入輸出**：清楚說明用到哪些檔案
- **可驗證**：包含驗收條件
- **可重現**：任務描述要完整，可獨立執行

---

## Phase 4: REVIEW

**執行者**：Antigravity  
**輸入**：Jules CLI 或 Codex CLI 的產出  
**輸出**：Review 意見或 Approval

### 自動化 Review（使用 watch，僅 Jules CLI）

當使用 `./scripts/agent.sh watch` 時，Jules 完成後會：

1. 執行 `jules remote pull --apply` 拉取並套用變更
2. 驗證產出品質（檢查是否有實際檔案變更）
3. 開啟 review 檔案並顯示通知
4. **你需要說**：「請 review 剛才 Jules 完成的變更，並幫我整理 commit」

> **注意**：由於 Antigravity CLI 限制，目前無法自動執行 prompt。
> Watch 會發送通知提醒你手動觸發 Review。

### 手動 Review

1. 使用 `prompts/antigravity/review.md` 模板
2. 提供程式碼變更（Jules patch 或 Codex 直接修改的檔案）
3. Antigravity 進行 code review
4. 如有問題，產生修正任務回到 Phase 3

> **注意**：Codex CLI 直接修改檔案，無需 patch 流程，可直接 review 變更。

---

## Phase 5: RELEASE

**執行者**：Antigravity  
**輸入**：已 review 的程式碼  
**輸出**：Release notes、版本 tag

### 步驟

1. 使用 `prompts/antigravity/release.md` 模板
2. 彙整本次變更
3. 產出 release notes
4. 打 tag、發布

---

## 流程圖

```
User Idea
    │
    ▼
┌─────────────────┐
│  Antigravity    │
│  plan.md        │──────────────────────────────────────┐
└────────┬────────┘                                      │
         │                                               │
         ▼                                               │
    PLAN.md                                              │
         │                                               │
    ┌────┼────┬────────────┐                             │
    ▼    │    ▼            ▼                             │
素材需求 │  設計需求     程式需求                          │
    │    │    │            │                             │
    ▼    │    ▼            │                             │
┌───────┐│ ┌─────────┐     │                             │
│Gemini ││ │ Stitch* │     │                             │
│CLI    ││ │ (預設)  │     │                             │
│Nano   ││ │  OR     │     │                             │
│Banana ││ │ Pencil  │     │                             │
│       ││ └────┬────┘     │                             │
└───┬───┘│      │          │                             │
    │    │      ▼          │                             │
    │    │   designs/      │                             │
    ▼    │      │          ▼                             │
 assets/ │      │     ┌─────────┐                        │
    │    │      │     │Jules CLI*│                        │
    │    │      │     │(預設)   │                        │
    │    │      │     │  OR     │                        │
    │    │      │     │Codex CLI │                        │
    │    │      │     └────┬────┘                        │
    │    │      │          │                             │
    └────┴──────┴─────┬────┘                             │
                      │                                  │
                      ▼                                  │
               ┌─────────────────┐                       │
               │  Antigravity    │◄──────────────────────┘
               │  review.md      │
               └────────┬────────┘
                        │
                        ▼
                  程式碼變更
                        │
                   ┌────┴────┐
                   ▼         ▼
            Jules Patch*  Codex 直接修改
            (預設，自動化)  (可選，手動)
                        │
                        ▼
               ┌─────────────────┐
               │  Antigravity    │
               │  release.md     │
               └────────┬────────┘
                        │
                        ▼
                   Release!
```

---

## 常見情境

### 情境 A：純 UI 功能

1. PLAN → 定義 UI 規格
2. ASSETS → 產 icon、empty state
3. CODE → **Jules CLI**（預設）或 Codex CLI 實作 SwiftUI/React 元件
4. REVIEW → 確認樣式與互動
5. RELEASE

### 情境 B：純邏輯功能

1. PLAN → 定義邏輯規格
2. ASSETS → 跳過
3. CODE → **Jules CLI**（預設）或 Codex CLI 實作
4. REVIEW
5. RELEASE

### 情境 C：重構

1. PLAN → 定義重構目標
2. ASSETS → 跳過
3. CODE → **Jules CLI**（預設，非同步）或 Codex CLI 執行重構
4. REVIEW → 重點檢查 breaking changes
5. RELEASE

### 情境 D：完整 UI 設計 + 實作（Web App）

1. PLAN → 定義功能規格與 UI 需求
2. ASSETS → 產 icon、插圖
3. **DESIGN → Stitch 生成 UI layout 與 HTML**（預設）
4. CODE → **Jules CLI** 參考 Stitch 設計實作元件（預設）
5. REVIEW → 對照設計稿確認
6. RELEASE

### 情境 E：完整 UI 設計 + 實作（移動 App）

1. PLAN → 定義功能規格與 UI 需求
2. ASSETS → 產 icon、插圖
3. **DESIGN → Pencil 設計 UI**（可選，移動 app 專用）
4. CODE → **Jules CLI**（預設）或 Codex CLI 使用 Pencil 生成的程式碼或參考設計實作
5. REVIEW → 對照設計稿確認
6. RELEASE
