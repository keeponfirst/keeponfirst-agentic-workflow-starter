# Implementation Plan: KOF Nano Banana MCP Server

> **Created**: 2026-02-06 10:27  
> **Updated**: 2026-02-06 11:21  
> **Status**: ✅ APPROVED  
> **Author**: Antigravity

---

## Feature Overview

### Problem Statement

目前 `keeponfirst-agentic-workflow` 的 **Phase 2: ASSETS** 步驟依賴：
1. Browser automation (Antigravity 專有功能)
2. 手動開啟 Gemini Web 產圖
3. 截圖保存

**問題**：其他 IDE（Cursor、Windsurf、Copilot Workspace）完全無法執行這個步驟，因為：
- 沒有 browser automation 能力
- 不知道如何呼叫 Gemini API
- 缺少標準化的 tool interface

### Solution

建立 **KOF Nano Banana MCP Server**，提供標準化的圖片生成工具，讓任何支援 MCP 的 AI Agent 都能：
1. 直接呼叫 Gemini Image Generation API（**使用 Free Tier，不額外花錢**）
2. 處理 `nanobanana/queue/` 中的 prompt 檔案
3. 自動保存生成的圖片到 `assets/generated/`

### 💰 Cost Model (重要發現)

| 方案 | 來源 | 額度 | 費用 |
|------|------|------|------|
| ~~Google AI Pro 訂閱~~ | Gemini Web/App | 1000 credits/月 | $19.99/月（你已訂閱） |
| **Gemini API Free Tier** ✅ | API Key | **500 images/天** | **$0（免費）** |

**結論**：MCP 使用 Gemini API Free Tier，不需要額外花錢，也不需要 Playwright！

---

## Technical Design

### Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│  AI Agent (Antigravity / Cursor / Windsurf / Copilot)          │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼ MCP Protocol (stdio)
┌─────────────────────────────────────────────────────────────────┐
│                   kof-nanobanana-mcp                            │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │  Tools                                                   │   │
│  │  • nanobanana_generate_image                            │   │
│  │  • nanobanana_process_queue                             │   │
│  │  • nanobanana_list_queue                                │   │
│  └─────────────────────────────────────────────────────────┘   │
│                              │                                  │
│                              ▼                                  │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │  Gemini Client                                          │   │
│  │  • Authentication (GEMINI_API_KEY)                      │   │
│  │  • Model: gemini-2.5-flash-image                        │   │
│  │  • Image decoding & file saving                         │   │
│  └─────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼ HTTPS
┌─────────────────────────────────────────────────────────────────┐
│                     Gemini API                                  │
│                 generativelanguage.googleapis.com               │
└─────────────────────────────────────────────────────────────────┘
```

### Project Structure

```
kof-nanobanana-mcp/
├── package.json
├── tsconfig.json
├── README.md
├── README_zh-TW.md
├── src/
│   ├── index.ts              # MCP server entry point
│   ├── tools/
│   │   ├── generate-image.ts # nanobanana_generate_image
│   │   ├── process-queue.ts  # nanobanana_process_queue
│   │   └── list-queue.ts     # nanobanana_list_queue
│   ├── services/
│   │   ├── gemini-client.ts  # Gemini API wrapper
│   │   └── file-utils.ts     # File I/O utilities
│   ├── schemas/
│   │   └── prompt-parser.ts  # Parse .md prompt files
│   ├── types.ts              # TypeScript types
│   └── constants.ts          # API URLs, limits, etc.
└── examples/
    └── sample-prompt.md      # Example prompt file
```

### Tool Definitions

#### Tool 1: `nanobanana_generate_image`

**Purpose**: 直接產生單張圖片

```typescript
inputSchema: z.object({
  prompt: z.string()
    .min(10, "Prompt must be at least 10 characters")
    .max(5000, "Prompt must not exceed 5000 characters")
    .describe("Image generation prompt describing the desired image"),
  
  output_path: z.string()
    .describe("Relative or absolute path to save the generated image (e.g., 'assets/generated/hero.png')"),
  
  model: z.enum([
    "gemini-2.5-flash-image",
    "gemini-3-pro-image-preview"
  ])
    .default("gemini-2.5-flash-image")
    .describe("Gemini model to use. Flash for speed, Pro for quality"),
  
  aspect_ratio: z.enum(["1:1", "16:9", "9:16", "4:3", "3:4"])
    .optional()
    .describe("Aspect ratio of the generated image"),
  
  overwrite: z.boolean()
    .default(false)
    .describe("If true, overwrite existing file. If false, skip if file exists")
})
```

**Returns**:
```typescript
{
  success: boolean;
  output_path: string;      // Where the image was saved
  model_used: string;       // Which model was used
  prompt_tokens: number;    // Token usage for cost tracking
  generation_time_ms: number;
  skipped: boolean;         // True if file existed and overwrite=false
}
```

#### Tool 2: `nanobanana_process_queue`

**Purpose**: 批次處理 queue 中的所有 prompt 檔案

```typescript
inputSchema: z.object({
  queue_dir: z.string()
    .default("nanobanana/queue")
    .describe("Directory containing prompt markdown files"),
  
  output_dir: z.string()
    .default("assets/generated")
    .describe("Directory to save generated images"),
  
  completed_dir: z.string()
    .default("nanobanana/completed")
    .describe("Directory to move processed prompts to"),
  
  model: z.enum([
    "gemini-2.5-flash-image",
    "gemini-3-pro-image-preview"
  ])
    .default("gemini-2.5-flash-image")
    .describe("Gemini model to use for all generations"),
  
  // ✅ 新增：validate / dry_run / overwrite 策略
  validate_only: z.boolean()
    .default(false)
    .describe("If true, only validate prompt files without generating images"),
  
  dry_run: z.boolean()
    .default(false)
    .describe("If true, show what would be generated without actually calling API"),
  
  overwrite: z.enum(["skip", "overwrite", "rename"])
    .default("skip")
    .describe("Strategy when output file exists: skip, overwrite, or rename with suffix")
})
```

**Returns**:
```typescript
{
  mode: "validate" | "dry_run" | "execute";
  processed: number;
  successful: number;
  failed: number;
  skipped: number;          // Files skipped due to overwrite policy
  results: Array<{
    prompt_file: string;
    output_path: string;
    status: "success" | "failed" | "skipped" | "would_generate";
    validation_errors?: string[];  // If validate_only or parsing failed
    error?: string;
  }>;
}
```

#### Tool 3: `nanobanana_list_queue`

**Purpose**: 列出 queue 中待處理的 prompt 檔案（含驗證狀態）

```typescript
inputSchema: z.object({
  queue_dir: z.string()
    .default("nanobanana/queue")
    .describe("Directory to scan for prompt files"),
  
  // ✅ 新增：驗證和衝突檢查
  validate: z.boolean()
    .default(true)
    .describe("If true, validate each prompt file and report errors"),
  
  check_conflicts: z.boolean()
    .default(true)
    .describe("If true, check if output files already exist")
})
```

**Returns**:
```typescript
{
  count: number;
  valid_count: number;
  invalid_count: number;
  conflict_count: number;   // Files where output already exists
  prompts: Array<{
    filename: string;
    title: string;          // From frontmatter or first heading
    output_path: string;    // From frontmatter
    model: string;          // From frontmatter or default
    aspect_ratio?: string;  // From frontmatter
    overwrite: boolean;     // From frontmatter
    preview: string;        // First 200 chars of prompt
    is_valid: boolean;
    validation_errors?: string[];
    output_exists: boolean; // True if output file already exists
  }>;
}
```

### Prompt File Format

✅ **新格式 (v2)**: 使用 YAML Frontmatter + Markdown body

```markdown
---
output_path: assets/generated/workflow-hero.png
model: gemini-2.5-flash-image
aspect_ratio: 16:9
overwrite: false
---

# Workflow Hero Image

Create a modern, sleek hero illustration showing three AI agents
working together in a software development workflow.

## Style Guidelines
- Style: Flat illustration with gradients
- Color palette: Deep purple (#6B46C1) to blue (#3B82F6)
- Background: Subtle gradient from dark to light

## Elements to Include
- Three distinct AI robot characters
- Code symbols floating around
- Arrows showing workflow direction
```

**YAML Frontmatter 欄位**:

| 欄位 | 必填 | 預設值 | 說明 |
|------|------|--------|------|
| `output_path` | ✅ | - | 輸出圖片路徑 |
| `model` | ❌ | `gemini-2.5-flash-image` | 使用的模型 |
| `aspect_ratio` | ❌ | `1:1` | 圖片比例 |
| `overwrite` | ❌ | `false` | 是否覆蓋已存在的檔案 |

**Parser 邏輯**:
1. 解析 YAML frontmatter 取得設定
2. 將 Markdown body 作為完整 prompt（包含標題、Style Guidelines 等）
3. 驗證必填欄位
4. 回傳結構化的 PromptTask 物件

**向後相容**: 如果沒有 frontmatter，fallback 到舊格式解析（從 `## Output` 取得路徑）

### Authentication

**環境變數**: `GEMINI_API_KEY`

**取得方式**:
1. 前往 [Google AI Studio](https://aistudio.google.com/apikey)
2. 建立 API Key
3. 設定環境變數或在 MCP config 中配置

**MCP Config 範例** (`~/.gemini/antigravity/mcp_config.json`):
```json
{
  "servers": {
    "nanobanana": {
      "command": "node",
      "args": ["/path/to/kof-nanobanana-mcp/dist/index.js"],
      "env": {
        "GEMINI_API_KEY": "your-api-key-here"
      }
    }
  }
}
```

### Error Handling

| Error Type | Handling Strategy |
|------------|-------------------|
| Missing API Key | Clear error: "GEMINI_API_KEY not set. Get one at https://aistudio.google.com/apikey" |
| Rate Limit (429) | Return with retry-after suggestion |
| Invalid Prompt (400) | Return Gemini's error message with prompt adjustments |
| File Write Error | Return path and permission details |
| Network Timeout | 30s timeout with retry suggestion |

### Dependencies

```json
{
  "dependencies": {
    "@modelcontextprotocol/sdk": "^1.6.1",
    "@google/genai": "^1.0.0",
    "zod": "^3.23.8"
  },
  "devDependencies": {
    "@types/node": "^22.10.0",
    "tsx": "^4.19.2",
    "typescript": "^5.7.2"
  }
}
```

---

## Asset Requirements

**None** - 這是純程式碼的 MCP server，不需要視覺資產。

---

## Code Tasks (for Implementation)

### Task 1: Project Initialization
- [x] 建立 `kof-nanobanana-mcp/` 目錄結構
- [x] 設定 `package.json` 和 `tsconfig.json`
- [x] 安裝 dependencies

### Task 2: Gemini Client
- [x] 實作 `gemini-client.ts`
- [x] 呼叫 `generateContent` with `responseModality: IMAGE`
- [x] 處理 base64 image decoding
- [x] 實作 file saving

### Task 3: Prompt Parser
- [x] 實作 `prompt-parser.ts`
- [x] 解析 markdown 格式的 prompt 檔案 (YAML frontmatter + legacy format)
- [x] 提取 output path、prompt、style guidelines

### Task 4: MCP Tools
- [x] 實作 `nanobanana_generate_image`
- [x] 實作 `nanobanana_process_queue` (含 validate/dry_run/overwrite)
- [x] 實作 `nanobanana_list_queue` (含 validate/check_conflicts)

### Task 5: Server Entry Point
- [x] 實作 `index.ts` with stdio transport
- [x] 註冊所有 tools
- [x] 錯誤處理和日誌

### Task 6: Documentation
- [x] 撰寫 `README.md` (English)
- [ ] 撰寫 `README_zh-TW.md` (Traditional Chinese) - 可後續補
- [x] 更新 `SKILL.md` 的 Phase 2 指示

### Task 7: Testing
- [ ] 手動測試各 tool
- [ ] 使用 MCP Inspector 驗證
- [ ] 整合測試 with Antigravity

---

## Acceptance Criteria

### Functional Requirements

- [ ] **AC1**: `nanobanana_generate_image` 可成功產生圖片並保存到指定路徑
- [ ] **AC2**: `nanobanana_process_queue` 可批次處理 queue 中所有 `.md` 檔案
- [ ] **AC3**: `nanobanana_list_queue` 可列出待處理的 prompt 檔案
- [ ] **AC4**: 支援 `gemini-2.5-flash-image` 和 `gemini-3-pro-image-preview` 兩種 model
- [ ] **AC5**: 錯誤訊息清晰，包含解決建議

### Non-Functional Requirements

- [ ] **AC6**: 單張圖片生成時間 < 30 秒
- [ ] **AC7**: MCP Inspector 可正確列出所有 tools
- [ ] **AC8**: README 包含完整安裝和使用說明

### Integration Requirements

- [ ] **AC9**: Antigravity 可透過 MCP 呼叫產圖
- [ ] **AC10**: `SKILL.md` Phase 2 更新為使用 MCP tool
- [ ] **AC11**: 現有的 `nanobanana/queue/` prompt 檔案格式相容

---

## Risk Assessment

| Risk | Probability | Impact | Mitigation |
|------|-------------|--------|------------|
| Gemini API 格式變更 | Low | High | Pin SDK version, monitor changelog |
| Rate Limiting | Medium | Medium | Add retry logic, document quota |
| 其他 IDE 不支援 MCP | Medium | High | 提供 CLI fallback script |
| Prompt file 格式不一致 | Medium | Low | 寬鬆 parser + validation warnings |

---

## Timeline Estimate

| Task | Effort |
|------|--------|
| Task 1: Project Init | 15 min |
| Task 2: Gemini Client | 30 min |
| Task 3: Prompt Parser | 20 min |
| Task 4: MCP Tools | 45 min |
| Task 5: Server Entry | 15 min |
| Task 6: Documentation | 30 min |
| Task 7: Testing | 30 min |
| **Total** | **~3 hours** |

---

## Decision Snapshot

| Item | Content |
|------|---------|
| Feature Name | `kof-nanobanana-mcp` |
| Decision Time | 2026-02-06 11:21 |
| Approved Scope | 1. MCP Server with 3 tools（含 validate/dry-run/overwrite）<br/>2. Gemini API Free Tier integration<br/>3. YAML frontmatter prompt parser<br/>4. SKILL.md update |
| Out of Scope | - Gemini 3 Pro 4K resolution<br/>- Image editing (text-and-image-to-image)<br/>- Reference images / style transfer<br/>- edit_image tool |
| ~~Open Questions~~ | ~~⚠️ 需確認是否要支援 reference images~~ → 先不做 |

---

## Human Gate ✅ APPROVED

| 項目 | 決議 |
|------|------|
| **Scope** | ✅ 3 tools 足夠，edit_image 先不做 |
| **Model Support** | ✅ Flash + Pro Preview 可以 |
| **Prompt Format** | ✅ .md OK，加 YAML frontmatter |
| **Reference Images** | ✅ 先不做 |
| **Cost Model** | ✅ 使用 Gemini API Free Tier (500 張/天，不額外花錢) |

---

## Next Steps

1. ✅ Human Gate 審核通過
2. 🔲 開始 Task 1-5 實作
3. 🔲 Task 6 文件撰寫
4. 🔲 Task 7 測試驗證
5. 🔲 更新 `SKILL.md` Phase 2
