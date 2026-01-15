# keeponfirst-agentic-workflow-starter

> 人不一定在場，任務也能前進。

一套以 **Antigravity（主控）+ Gemini CLI（Nano Banana 產圖）+ Jules（雲端 Task Executor）** 為核心的 Agentic Workflow 起手式。

**[🚀 互動式新手引導 (Onboarding Guide)](../onboarding/index.html)**

---

## 🧩 安裝為 Antigravity Skill（新功能！）

這套 workflow 可以安裝為 **全域 Antigravity Skill** — 在任何專案中使用，無需 clone 整個 repo！

### 安裝方式

```bash
# Clone 並安裝
git clone https://github.com/keeponfirst/keeponfirst-agentic-workflow-starter.git
cp -r keeponfirst-agentic-workflow-starter/skills/keeponfirst-agentic-workflow ~/.gemini/antigravity/skills/
```

### 使用方式

安裝後，在任何 workspace 對 Antigravity 說：

```
/kof                           # 簡短觸發詞
KOF workflow 新增深色模式       # 自然語言
用 KOF 開發新功能               # 中文也可以
```

**觸發關鍵字**：`/kof`、`KOF workflow`、`KOF agentic`、`keeponfirst workflow`、`keeponfirst agentic`

> 💡 **為什麼用 KOF？** 為了避免與其他 agentic 類型的 skill 衝突，我們特意使用專屬觸發詞。如果你想改成其他名稱，直接編輯 `skills/keeponfirst-agentic-workflow/SKILL.md` 中的 `description` 欄位即可。

### Skill 內容

| 元件 | 說明 |
|------|------|
| `SKILL.md` | 5 階段工作流程指南 (PLAN → ASSETS → CODE → REVIEW → RELEASE) |
| `scripts/init.sh` | 在任何專案初始化 workflow 結構 |
| `scripts/jules-watcher.sh` | 可攜式 Jules session 監控器 |
| `assets/plan-template.md` | 即用的規劃文件範本 |

### 在新專案初始化 Workflow

```bash
# 從 skill 目錄執行
bash ~/.gemini/antigravity/skills/keeponfirst-agentic-workflow/scripts/init.sh /path/to/your/project
```

這會建立：`plans/`、`jules/tasks/`、`nanobanana/queue/`、`assets/generated/`

---

## 我為什麼做這個 Repo

這套 workflow 的誕生過程：

1. **訂閱 Gemini Pro** → 開始研究 Google 生態系的 AI 工具
2. **發現 Gemini CLI** → 嘗試用來產圖、做素材；但很快就遇到 **quota limit**
3. **看到 Jules 開放試用** → 發現每日 100 tasks 的雲端 executor 潛力
4. **整合思路成形** → Antigravity 做主控規劃、Gemini CLI 只負責輕量產圖（Nano Banana 策略）、Jules 處理需要時間的程式任務

**核心價值：**
- **非同步協作**：人睡覺時，Jules 還在工作
- **避免單點 Quota 崩潰**：分散任務到不同工具
- **可追溯**：所有 prompt 和 task 都有留存

---

## 三角色分工

| 角色 | 工具 | 職責 | Quota 策略 |
|------|------|------|------------|
| **Orchestrator** | Antigravity | 規劃、決策、Review、Release | 人在場時使用 |
| **Asset Generator** | Gemini CLI | 產生圖片、Icon、UI 素材 | Nano Banana（每次只做一張） |
| **Task Executor** | Jules | 實作 UI、寫程式、重構 | 每日 100 tasks 上限 |

```
┌─────────────────┐
│   Antigravity   │  ← 你的大腦延伸，做規劃與決策
│  (Orchestrator) │
└────────┬────────┘
         │
    ┌────┴────┐
    ▼         ▼
┌───────┐  ┌───────┐
│Gemini │  │ Jules │  ← 兩個 Executor，各司其職
│  CLI  │  │       │
└───────┘  └───────┘
    │           │
    ▼           ▼
 assets/    程式碼
```

---

## Execution Model

本 repo 基於 **Google-first 工具鏈**設計，核心概念如下：

### 角色定義

| 層級 | 角色 | 說明 |
|------|------|------|
| Orchestrator | Antigravity | 規劃、決策、協調各 Agent |
| Agent (Asset) | Gemini CLI | 執行產圖任務 |
| Agent (Code) | Jules | 執行程式碼任務 |
| Adapter | `scripts/agent.sh` | CLI 統一入口，銜接 Orchestrator 與 Agents |

### agent.sh 的定位

`agent.sh` 是 **Orchestrator Adapter**，不是單一工具：

- **plan**：產生規劃模板（供 Antigravity 使用）
- **assets**：準備產圖任務到 `nanobanana/queue/`（供 Gemini CLI 執行）
- **jules**：準備程式任務到 `jules/tasks/`（供 Jules 執行）
- **verify**：驗證專案結構

### 預設安全模式

本 repo 的腳本 **不會直接呼叫外部 API**，你可以安全地執行所有指令：

```bash
./scripts/agent.sh plan    # 產生 PLAN.md 模板，不消耗 quota
./scripts/agent.sh assets  # 產生任務 queue，不消耗 quota
./scripts/agent.sh jules   # 產生任務檔案，不消耗 quota
```

實際執行 Agent 是由你手動進行：
- Gemini CLI：`gemini generate ...`
- Jules：複製任務內容到 Jules 介面

這樣的設計讓你可以先 **dry-run** 整個流程，確認任務內容正確後再執行。

> **簡單說**：`agent.sh` 是「任務準備工具」。它只負責產生 plan、prompts、tasks 等檔案，不會呼叫 Gemini API 也不會觸發 Jules。你可以放心執行，不會消耗任何 quota。

### 關於 API Key 與登入

Gemini CLI 和 Jules **不一定需要手動設定 API Key**：

- **多數情況**：安裝後登入 Google 帳戶即可使用
- **API Key 主要用於**：非互動式環境、自動化腳本、或特定 API 呼叫

本 repo 的 `.env.example` 提供 API Key 設定欄位，但這**並非必要條件**。如果你只是互動式使用 Gemini CLI 或 Jules，登入即可開始。

---

## 實際使用流程

> 💡 **重點**：日常使用時，你只需要對 Antigravity 下指令。腳本是輔助工具，不是必須手動執行。

### 啟動 Workflow

對 Antigravity（如本 IDE）說以下任一指令：

```
/workflow 幫我新增一個「暗黑模式切換」功能
```

```
按照 agentic workflow 幫我實作一個收藏功能
```

```
使用這個 repo 的 workflow 開發 XXX
```

Antigravity 會自動執行完整的 **PLAN → ASSETS → CODE → REVIEW → RELEASE** 流程。

### 典型工作流程（手動）

1. **在 Antigravity 中描述需求**
   ```
   我要新增一個 Tag Selector 功能，請幫我規劃並產生 Jules task
   ```

2. **Antigravity 會自動**：
   - 產生 `PLAN.md`
   - 準備 Jules 任務到 `jules/tasks/`
   - 如需產圖，準備 prompts 到 `nanobanana/queue/`

3. **提交 Jules 任務後，對 Antigravity 說**：
   ```
   我已經提交 Jules task，session ID 是 123456，請幫我監控
   ```

4. **Antigravity 執行 watch**，Jules 完成後自動進入 Review

5. **Review 完成後**：
   ```
   確認無誤，請幫我整理 commit message 並提交
   ```

### 腳本用途說明

`scripts/agent.sh` 是給進階使用者或自動化場景使用：

| 指令 | 用途 | 通常何時用 |
|------|------|-----------|
| `plan` | 產生 PLAN.md 模板 | Antigravity 會自動呼叫 |
| `assets` | 準備產圖任務 | Antigravity 會自動呼叫 |
| `jules` | 準備程式任務 | Antigravity 會自動呼叫 |
| `watch <id>` | 監控 Jules session | Antigravity 會自動呼叫，或手動執行 |
| `verify` | 驗證專案結構 | CI 或手動檢查時 |

---

## 快速開始（初次設定）

### 1. Clone & Bootstrap

```bash
git clone https://github.com/keeponfirst/keeponfirst-agentic-workflow-starter.git
cd keeponfirst-agentic-workflow-starter

# 初始化資料夾與環境變數
./scripts/bootstrap.sh
```

### 2. 產生一份 Plan

```bash
./scripts/agent.sh plan
# 輸出：PLAN.md
```

### 3. 產生產圖任務（給 Gemini CLI）

```bash
./scripts/agent.sh assets
# 輸出：nanobanana/queue/*.md
# 你可以用 Gemini CLI 逐一執行
```

### 4. 產生程式任務（給 Jules）

```bash
./scripts/agent.sh jules
# 輸出：jules/tasks/*.md
# 你可以複製內容到 Jules 執行
```

### 5. 監控 Jules 並自動 Review（可選）

```bash
# 建立 Jules session
jules new "implement feature X"

# 取得 session ID
jules remote list --session

# 啟動監控 - 完成後自動喚醒 Antigravity agent 進行 Review
./scripts/agent.sh watch <session_id>
```

`watch` 命令會：
- 每 30 秒輪詢 Jules session 狀態
- 偵測到 completed 後自動執行 `jules remote pull --apply`
- 使用 `agy chat --mode agent` 喚醒 Antigravity 進行 code review
- 發送系統通知

### 6. 驗證專案結構

```bash
./scripts/agent.sh verify
```

---

## 快速驗證（Optional）

完成 Quick Start 後，可執行以下指令確認環境正確：

```bash
# 檢查 Gemini CLI 是否已安裝（可選，僅供確認）
gemini --version

# 驗證專案結構與安全性
./scripts/agent.sh verify
```

這一步的目的是確認：
- 專案目錄結構完整
- 沒有敏感資訊被意外 commit
- 環境設定正確

> **注意**：`gemini --version` 只是確認工具已安裝，不會消耗 quota。如果你尚未安裝 Gemini CLI，可以跳過此步驟。

---

## 目錄結構

```
.
├── docs/                  # 工作流程文件
│   ├── ARCHITECTURE.md    # 架構演進故事
│   ├── WORKFLOW.md        # 標準流程
│   ├── PROS_CONS.md       # 優缺點分析
│   ├── QUOTA_STRATEGY.md  # Quota 控制策略
│   └── SECURITY.md        # 安全實踐
│
├── prompts/               # 可直接使用的 Prompt 模板
│   ├── antigravity/       # 給 Orchestrator 的 prompts
│   ├── gemini-cli/        # 給 Gemini CLI 的產圖 prompts
│   └── jules/             # 給 Jules 的任務模板
│
├── scripts/               # 自動化腳本
│   ├── agent.sh           # 單一入口
│   ├── bootstrap.sh       # 初始化
│   └── check_secrets.sh   # 敏感資訊檢查
│
├── examples/              # 範例
│   └── feature_tag_selector/
│
├── nanobanana/queue/      # Gemini CLI 任務佇列
├── assets/generated/      # 產出的素材
└── jules/tasks/           # Jules 任務佇列
```

---

## 文件導覽

| 文件 | 說明 |
|------|------|
| [ARCHITECTURE.md](../ARCHITECTURE.md) | 這套 workflow 怎麼演進來的 |
| [WORKFLOW.md](../WORKFLOW.md) | 標準 Feature Pipeline |
| [PROS_CONS.md](../PROS_CONS.md) | 優缺點與適用情境 |
| [QUOTA_STRATEGY.md](../QUOTA_STRATEGY.md) | Quota 控制策略 |
| [SECURITY.md](../SECURITY.md) | API Key 安全管理 |
| [TROUBLESHOOTING.md](../TROUBLESHOOTING.md) | 常見問題排除（quota、Jules、重試） |

---

## 已知限制

### agy chat 無法自動執行 prompt

目前 `agy chat` CLI 只能**開啟視窗**，但**無法自動填入並執行 prompt**。

```bash
# 這個命令只會開啟 Antigravity，不會執行 prompt
agy chat --mode agent "請幫我 review"
```

**影響**：
- Watch 命令完成後，無法自動喚醒 Antigravity 執行 Review
- 需要手動對 Antigravity 說：「請 review 剛才 Jules 完成的變更」

**期望的未來改進**：
- Antigravity CLI 支援直接發送 prompt 並執行
- 或提供 extension API 讓第三方 extension 可以控制 chat

---

## License

MIT License - 詳見 [LICENSE](../../LICENSE)

---

## Contributing

歡迎貢獻 prompts 和 examples！詳見 [CONTRIBUTING.md](../../CONTRIBUTING.md)
