#!/bin/bash

# agent.sh - Agentic Workflow 單一入口腳本
# 用法: ./scripts/agent.sh [command]
# 命令: plan, assets, jules, watch, verify

set -e

# 顏色定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 取得腳本所在目錄的父目錄（專案根目錄）
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# 顯示 banner
show_banner() {
    echo -e "${BLUE}"
    echo "╔═══════════════════════════════════════════╗"
    echo "║   Agentic Workflow Starter                ║"
    echo "║   Antigravity + Gemini CLI + Jules        ║"
    echo "╚═══════════════════════════════════════════╝"
    echo -e "${NC}"
}

# 顯示用法
show_usage() {
    echo "用法: ./scripts/agent.sh [command]"
    echo ""
    echo "命令:"
    echo "  plan           產生 PLAN.md（規劃文件）"
    echo "  assets         準備產圖任務到 nanobanana/queue/"
    echo "  design         準備設計任務到 stitch/queue/"
    echo "  jules          準備程式任務到 jules/tasks/"
    echo "  watch <id>     監控 Jules session，完成後自動 fetch 並喚醒 Antigravity"
    echo "  stitch-setup   首次設定 Stitch extension（設定 GCP Project ID）"
    echo "  stitch-check   檢查 Stitch MCP 連線狀態"
    echo "  verify         驗證專案結構與安全性"
    echo ""
    echo "範例:"
    echo "  ./scripts/agent.sh plan"
    echo "  ./scripts/agent.sh assets"
    echo "  ./scripts/agent.sh design"
    echo "  ./scripts/agent.sh watch 123456"
    echo "  ./scripts/agent.sh stitch-setup"
    echo "  ./scripts/agent.sh verify"
}

# Plan 命令
cmd_plan() {
    echo -e "${BLUE}[Plan] 產生規劃文件...${NC}"
    
    local plan_file="$PROJECT_ROOT/PLAN.md"
    local template="$PROJECT_ROOT/prompts/antigravity/plan.md"
    
    if [ -f "$plan_file" ]; then
        echo -e "${YELLOW}警告: PLAN.md 已存在，將備份為 PLAN.md.bak${NC}"
        mv "$plan_file" "$plan_file.bak"
    fi
    
    cat > "$plan_file" << 'EOF'
# PLAN

> 請使用 prompts/antigravity/plan.md 模板填寫以下內容

## 功能概述

<!-- 描述要實作的功能 -->

## 技術設計

<!-- 技術方案 -->

## 素材需求（給 Gemini CLI）

| 檔名 | 尺寸 | 用途 |
|------|------|------|
| | | |

## 程式任務（給 Jules）

1. <!-- 任務 1 -->
2. <!-- 任務 2 -->

## 驗收標準

- [ ] <!-- 標準 1 -->
- [ ] <!-- 標準 2 -->

## 時程估計

- 素材產生：
- 程式實作：
- 測試整合：

---

*使用 `./scripts/agent.sh assets` 產生產圖任務*
*使用 `./scripts/agent.sh jules` 產生程式任務*
EOF

    echo -e "${GREEN}✓ 已產生 PLAN.md${NC}"
    echo -e "  請編輯 PLAN.md 填入功能規格"
    echo -e "  參考模板: prompts/antigravity/plan.md"
}

# Assets 命令
cmd_assets() {
    echo -e "${BLUE}[Assets] 準備產圖任務...${NC}"
    
    local queue_dir="$PROJECT_ROOT/nanobanana/queue"
    local output_dir="$PROJECT_ROOT/assets/generated"
    local prompts_dir="$PROJECT_ROOT/prompts/gemini-cli/nanobanana"
    
    # 確保目錄存在
    mkdir -p "$queue_dir"
    mkdir -p "$output_dir/icons"
    mkdir -p "$output_dir/illustrations"
    mkdir -p "$output_dir/heroes"
    
    # 複製 prompt 模板到 queue
    local count=0
    for prompt in "$prompts_dir"/*.md; do
        if [ -f "$prompt" ]; then
            local filename=$(basename "$prompt")
            local timestamp=$(date +%Y%m%d_%H%M%S)
            cp "$prompt" "$queue_dir/${timestamp}_${filename}"
            count=$((count + 1))
        fi
    done
    
    echo -e "${GREEN}✓ 已複製 ${count} 個 prompt 模板到 nanobanana/queue/${NC}"
    echo ""
    echo "下一步："
    echo "1. 編輯 nanobanana/queue/ 中的 prompts，填入具體內容"
    echo "2. 使用 Gemini CLI 逐一執行"
    echo "3. 產出檔案放到 assets/generated/ 對應目錄"
    echo ""
    echo "目錄結構："
    echo "  assets/generated/"
    echo "  ├── icons/         # Icon 圖片"
    echo "  ├── illustrations/ # 插圖"
    echo "  └── heroes/        # Feature hero 圖片"
}

# Jules 命令
cmd_jules() {
    echo -e "${BLUE}[Jules] 準備程式任務...${NC}"
    
    local tasks_dir="$PROJECT_ROOT/jules/tasks"
    local prompts_dir="$PROJECT_ROOT/prompts/jules"
    
    # 確保目錄存在
    mkdir -p "$tasks_dir"
    
    # 複製 prompt 模板到 tasks
    local count=0
    for prompt in "$prompts_dir"/*.md; do
        if [ -f "$prompt" ]; then
            local filename=$(basename "$prompt")
            local timestamp=$(date +%Y%m%d_%H%M%S)
            cp "$prompt" "$tasks_dir/${timestamp}_${filename}"
            count=$((count + 1))
        fi
    done
    
    echo -e "${GREEN}✓ 已複製 ${count} 個任務模板到 jules/tasks/${NC}"
    echo ""
    echo "下一步："
    echo "1. 編輯 jules/tasks/ 中的任務，填入具體內容"
    echo "2. 複製任務內容到 Jules"
    echo "3. 等待 Jules 完成執行"
    echo "4. Review 產出的程式碼"
}

# Watch 命令 - 啟動背景監控 Jules session
cmd_watch() {
    local session_id="$1"
    local max_retries="${2:-3}"
    
    if [ -z "$session_id" ]; then
        echo -e "${RED}錯誤: 請提供 session ID${NC}"
        echo "用法: ./scripts/agent.sh watch <session_id> [max_retries]"
        echo ""
        echo "取得 session ID："
        echo "  jules remote list --session"
        exit 1
    fi
    
    # 確保 watcher.sh 可執行
    chmod +x "$SCRIPT_DIR/watcher.sh"
    
    # 使用 nohup 在背景啟動 watcher
    local log_file="$PROJECT_ROOT/jules/watcher.log"
    nohup "$SCRIPT_DIR/watcher.sh" "$session_id" "$max_retries" "$PROJECT_ROOT" > "$log_file" 2>&1 &
    local watcher_pid=$!
    
    echo -e "${GREEN}✅ Watcher 已在背景啟動${NC}"
    echo ""
    echo "  Session ID: $session_id"
    echo "  Max Retries: $max_retries"
    echo "  Process ID: $watcher_pid"
    echo "  Log File: $log_file"
    echo ""
    echo -e "${YELLOW}你可以繼續其他工作。${NC}"
    echo -e "${YELLOW}監控狀態: tail -f $log_file${NC}"
    echo -e "${YELLOW}停止監控: kill $watcher_pid${NC}"
}

# Design 命令 - 準備 Stitch 設計任務
cmd_design() {
    echo -e "${BLUE}[Design] 準備設計任務...${NC}"

    local queue_dir="$PROJECT_ROOT/stitch/queue"
    local designs_dir="$PROJECT_ROOT/stitch/designs"
    local prompts_dir="$PROJECT_ROOT/prompts/stitch"

    # 確保目錄存在
    mkdir -p "$queue_dir"
    mkdir -p "$designs_dir"
    mkdir -p "$prompts_dir"

    # 如果沒有模板，建立預設模板
    if [ ! -f "$prompts_dir/ui_screen.md" ]; then
        cat > "$prompts_dir/ui_screen.md" << 'EOF'
# UI Screen Design Request

## 目標用戶
<!-- 描述使用這個畫面的用戶 -->

## 功能描述
<!-- 這個畫面要完成什麼？ -->

## 設計需求
<!-- 風格、顏色、元件等 -->

## Stitch Prompt
<!-- 實際給 Stitch 的 prompt -->

Design a mobile screen for [描述]...
EOF
        echo -e "${YELLOW}已建立預設模板: prompts/stitch/ui_screen.md${NC}"
    fi

    # 複製 prompt 模板到 queue
    local count=0
    for prompt in "$prompts_dir"/*.md; do
        if [ -f "$prompt" ]; then
            local filename=$(basename "$prompt")
            local timestamp=$(date +%Y%m%d_%H%M%S)
            cp "$prompt" "$queue_dir/${timestamp}_${filename}"
            count=$((count + 1))
        fi
    done

    echo -e "${GREEN}✓ 已複製 ${count} 個設計模板到 stitch/queue/${NC}"
    echo ""
    echo "下一步："
    echo "1. 編輯 stitch/queue/ 中的設計需求"
    echo "2. 開啟 Gemini CLI: gemini"
    echo "3. 執行設計: /stitch <你的設計描述>"
    echo "4. 下載設計: /stitch Download the image of screen <id>"
    echo "5. 將下載檔案移到 stitch/designs/<feature>/"
    echo "6. 告知 Antigravity「設計完成」繼續流程"
}

# Stitch Setup 命令 - 首次設定
cmd_stitch_setup() {
    echo -e "${BLUE}[Stitch] 設定 Stitch extension...${NC}"

    local extension_config="$HOME/.gemini/extensions/Stitch/gemini-extension.json"

    # 檢查 extension 是否安裝
    if [ ! -f "$extension_config" ]; then
        echo -e "${RED}錯誤: Stitch extension 未安裝${NC}"
        echo ""
        echo "請執行以下命令安裝："
        echo "  gemini extensions install https://github.com/gemini-cli-extensions/stitch --auto-update"
        exit 1
    fi

    # 取得目前的 Project ID
    local current_project=$(gcloud config get-value project 2>/dev/null)

    if [ -z "$current_project" ]; then
        echo -e "${YELLOW}警告: 尚未設定 GCP Project${NC}"
        echo ""
        echo "請先設定 GCP Project："
        echo "  export PROJECT_ID=\"your-project-id\""
        echo "  gcloud config set project \$PROJECT_ID"
        echo ""
        read -p "輸入你的 GCP Project ID: " current_project

        if [ -z "$current_project" ]; then
            echo -e "${RED}錯誤: 未提供 Project ID${NC}"
            exit 1
        fi

        # 驗證 Project ID 格式 (GCP 規則: 6-30 字元, 小寫字母開頭, 只能包含小寫字母、數字、連字號)
        if [[ ! "$current_project" =~ ^[a-z][a-z0-9-]{4,28}[a-z0-9]$ ]]; then
            echo -e "${RED}錯誤: 無效的 Project ID 格式${NC}"
            echo "GCP Project ID 規則："
            echo "  - 6-30 個字元"
            echo "  - 必須以小寫字母開頭"
            echo "  - 只能包含小寫字母、數字、連字號"
            echo "  - 不能以連字號結尾"
            exit 1
        fi

        gcloud config set project "$current_project"
    fi

    echo "使用 Project ID: $current_project"

    # 更新 extension 設定
    if grep -q "YOUR_PROJECT_ID" "$extension_config"; then
        # 使用跨平台相容的 sed 語法
        if [[ "$OSTYPE" == "darwin"* ]]; then
            # macOS
            sed -i '' "s/YOUR_PROJECT_ID/$current_project/g" "$extension_config"
        else
            # Linux
            sed -i "s/YOUR_PROJECT_ID/$current_project/g" "$extension_config"
        fi
        echo -e "${GREEN}✓ 已更新 Stitch extension 設定${NC}"
    else
        echo -e "${YELLOW}Stitch extension 已設定過${NC}"
    fi

    # 設定 ADC
    echo ""
    echo "設定 Application Default Credentials..."
    gcloud auth application-default set-quota-project "$current_project" 2>/dev/null || true

    echo ""
    echo -e "${GREEN}✓ Stitch 設定完成${NC}"
    echo ""
    echo "下一步："
    echo "1. 確認登入狀態: gcloud auth application-default login"
    echo "2. 檢查連線: ./scripts/agent.sh stitch-check"
    echo "3. 開始設計: gemini → /stitch Design a..."
}

# Stitch Check 命令 - 檢查連線狀態
cmd_stitch_check() {
    echo -e "${BLUE}[Stitch] 檢查連線狀態...${NC}"
    echo ""

    # 檢查 gcloud
    if ! command -v gcloud &> /dev/null; then
        echo -e "${RED}✗ gcloud CLI 未安裝${NC}"
        exit 1
    fi
    echo -e "${GREEN}✓${NC} gcloud CLI 已安裝"

    # 檢查 Project
    local project=$(gcloud config get-value project 2>/dev/null)
    if [ -z "$project" ]; then
        echo -e "${RED}✗ 未設定 GCP Project${NC}"
    else
        echo -e "${GREEN}✓${NC} GCP Project: $project"
    fi

    # 檢查 ADC
    if [ -f "$HOME/.config/gcloud/application_default_credentials.json" ]; then
        echo -e "${GREEN}✓${NC} Application Default Credentials 已設定"
    else
        echo -e "${YELLOW}⚠${NC} Application Default Credentials 未設定"
        echo "  執行: gcloud auth application-default login"
    fi

    # 檢查 Gemini CLI
    echo ""
    if ! command -v gemini &> /dev/null; then
        echo -e "${YELLOW}⚠${NC} Gemini CLI 未安裝"
        echo "  安裝: https://github.com/anthropics/gemini-cli"
    else
        echo -e "${GREEN}✓${NC} Gemini CLI 已安裝"
        echo ""
        echo "檢查 Gemini CLI MCP 連線..."
        if gemini mcp list 2>&1 | grep -qiE "(stitch|Stitch)"; then
            echo -e "${GREEN}✓${NC} Stitch MCP 已連線"
        else
            echo -e "${RED}✗${NC} Stitch MCP 未連線"
            echo "  請確認 Stitch extension 已安裝並設定"
        fi
    fi
}

# Verify 命令
cmd_verify() {
    echo -e "${BLUE}[Verify] 驗證專案結構...${NC}"
    
    local errors=0
    
    # 檢查必要目錄
    echo "檢查目錄結構..."
    local required_dirs=(
        "docs"
        "prompts/antigravity"
        "prompts/gemini-cli/nanobanana"
        "prompts/jules"
        "scripts"
        "examples"
        "nanobanana/queue"
        "assets/generated"
        "jules/tasks"
    )
    
    for dir in "${required_dirs[@]}"; do
        if [ -d "$PROJECT_ROOT/$dir" ]; then
            echo -e "  ${GREEN}✓${NC} $dir"
        else
            echo -e "  ${RED}✗${NC} $dir (missing)"
            errors=$((errors + 1))
        fi
    done
    
    # 檢查必要檔案
    echo ""
    echo "檢查必要檔案..."
    local required_files=(
        "README.md"
        "LICENSE"
        ".gitignore"
        ".env.example"
    )
    
    for file in "${required_files[@]}"; do
        if [ -f "$PROJECT_ROOT/$file" ]; then
            echo -e "  ${GREEN}✓${NC} $file"
        else
            echo -e "  ${RED}✗${NC} $file (missing)"
            errors=$((errors + 1))
        fi
    done
    
    # 檢查敏感檔案
    echo ""
    echo "檢查敏感檔案..."
    "$SCRIPT_DIR/check_secrets.sh"
    local secrets_result=$?
    
    if [ $secrets_result -ne 0 ]; then
        errors=$((errors + secrets_result))
    fi
    
    # 結果
    echo ""
    if [ $errors -eq 0 ]; then
        echo -e "${GREEN}✓ 驗證通過！${NC}"
        exit 0
    else
        echo -e "${RED}✗ 發現 $errors 個問題${NC}"
        exit 1
    fi
}

# 主程式
main() {
    show_banner
    
    local command="${1:-help}"
    shift 2>/dev/null || true
    
    case "$command" in
        plan)
            cmd_plan
            ;;
        assets)
            cmd_assets
            ;;
        jules)
            cmd_jules
            ;;
        watch)
            cmd_watch "$1"
            ;;
        design)
            cmd_design
            ;;
        stitch-setup)
            cmd_stitch_setup
            ;;
        stitch-check)
            cmd_stitch_check
            ;;
        verify)
            cmd_verify
            ;;
        help|--help|-h)
            show_usage
            ;;
        *)
            echo -e "${RED}錯誤: 未知命令 '$command'${NC}"
            echo ""
            show_usage
            exit 1
            ;;
    esac
}

main "$@"

