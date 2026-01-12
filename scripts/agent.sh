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
    echo "  jules          準備程式任務到 jules/tasks/"
    echo "  watch <id>     監控 Jules session，完成後自動 fetch 並喚醒 Antigravity"
    echo "  verify         驗證專案結構與安全性"
    echo ""
    echo "範例:"
    echo "  ./scripts/agent.sh plan"
    echo "  ./scripts/agent.sh assets"
    echo "  ./scripts/agent.sh watch 123456"
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

# Watch 命令 - 監控 Jules session
cmd_watch() {
    local session_id="$1"
    
    if [ -z "$session_id" ]; then
        echo -e "${RED}錯誤: 請提供 session ID${NC}"
        echo "用法: ./scripts/agent.sh watch <session_id>"
        echo ""
        echo "取得 session ID："
        echo "  jules remote list --session"
        exit 1
    fi
    
    echo -e "${BLUE}[Watch] 開始監控 Jules session: ${session_id}${NC}"
    
    local poll_interval=30
    local completed_dir="$PROJECT_ROOT/jules/completed"
    mkdir -p "$completed_dir"
    
    # 系統通知函數（macOS）
    notify_system() {
        local message="$1"
        if command -v osascript &> /dev/null; then
            osascript -e "display notification \"$message\" with title \"Jules Watcher\" sound name \"Glass\""
        elif command -v notify-send &> /dev/null; then
            notify-send "Jules Watcher" "$message"
        fi
    }
    
    # 檢查 session 狀態
    check_status() {
        local output
        output=$(jules remote list --session 2>/dev/null || echo "")
        if echo "$output" | grep -q "$session_id.*completed"; then
            return 0
        elif echo "$output" | grep -q "$session_id.*failed"; then
            return 2
        else
            return 1
        fi
    }
    
    # 輪詢迴圈
    echo -e "${YELLOW}每 ${poll_interval} 秒檢查一次狀態...${NC}"
    echo -e "${YELLOW}按 Ctrl+C 停止監控${NC}"
    echo ""
    
    local attempt=0
    while true; do
        attempt=$((attempt + 1))
        local current_time=$(date +"%H:%M:%S")
        
        check_status
        local status=$?
        
        if [ $status -eq 0 ]; then
            echo ""
            echo -e "${GREEN}✓ Session $session_id 已完成！${NC}"
            
            # 發送通知
            notify_system "Session $session_id 已完成！正在拉取結果..."
            
            # 拉取結果並套用
            echo -e "${BLUE}正在拉取結果...${NC}"
            if jules remote pull --session "$session_id" --apply; then
                echo -e "${GREEN}✓ 已拉取並套用 patch${NC}"
                
                # 記錄完成的 session
                local review_file="$completed_dir/${session_id}_completed.md"
                cat > "$review_file" << REVIEWEOF
# Jules Session Review

**Session ID**: $session_id
**Completed**: $(date)

## Review 任務

請 Review Jules 完成的變更：

1. 執行 \`git diff\` 確認變更內容
2. 確認程式碼符合專案規範
3. 執行相關測試確認功能正常
4. 如有問題，請說明需要修正的地方

## 變更摘要

請分析本次變更並提供：
- 主要修改的檔案
- 功能影響範圍
- 潛在風險評估
REVIEWEOF
                
                # 使用 agy chat 喚醒 Antigravity agent
                echo -e "${BLUE}正在喚醒 Antigravity agent 進行 Review...${NC}"
                if command -v agy &> /dev/null; then
                    # 使用 agent mode 並傳入 review prompt
                    agy chat --mode agent --add-file "$review_file" \
                        "Jules session $session_id 已完成。請執行 git diff 查看變更，並進行 code review。如有問題請指出，確認無誤後協助整理 commit message。" &
                    echo -e "${GREEN}✓ 已喚醒 Antigravity agent${NC}"
                elif command -v antigravity &> /dev/null; then
                    # fallback: 開啟 IDE
                    antigravity "$PROJECT_ROOT" &
                    echo -e "${GREEN}✓ 已開啟 Antigravity IDE（請手動啟動 Review）${NC}"
                else
                    echo -e "${YELLOW}⚠ 找不到 agy/antigravity 命令，請手動進行 Review${NC}"
                fi
                
                # 最終通知
                notify_system "Jules 結果已套用！Antigravity agent 已啟動 Review"
                
            else
                echo -e "${RED}✗ 拉取結果失敗${NC}"
                notify_system "拉取 Jules 結果失敗！"
            fi
            
            break
            
        elif [ $status -eq 2 ]; then
            echo ""
            echo -e "${RED}✗ Session $session_id 執行失敗${NC}"
            notify_system "Session $session_id 執行失敗！"
            break
            
        else
            echo -ne "\r[$current_time] 檢查 #$attempt: session 仍在執行中..."
        fi
        
        sleep $poll_interval
    done
    
    echo ""
    echo -e "${GREEN}監控結束${NC}"
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

