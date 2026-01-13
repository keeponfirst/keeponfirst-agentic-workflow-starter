#!/bin/bash

# watcher.sh - Jules Session 監控腳本（背景執行）
# 這個腳本會被 agent.sh watch 透過 nohup 在背景啟動
# 日誌輸出到 jules/watcher.log

# Don't use set -e because grep returns 1 when no match
# set -e

# 顏色定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# 參數
SESSION_ID="$1"
MAX_RETRIES="${2:-3}"
PROJECT_ROOT="${3:-$(pwd)}"

# 確保日誌目錄存在
LOG_DIR="$PROJECT_ROOT/jules"
LOG_FILE="$LOG_DIR/watcher.log"
mkdir -p "$LOG_DIR"

# 日誌函數
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

log_error() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [ERROR] $1" | tee -a "$LOG_FILE"
}

# 系統通知
notify_system() {
    local message="$1"
    if command -v osascript &> /dev/null; then
        osascript -e "display notification \"$message\" with title \"Jules Watcher\" sound name \"Glass\"" 2>/dev/null || true
    elif command -v notify-send &> /dev/null; then
        notify-send "Jules Watcher" "$message" 2>/dev/null || true
    fi
}

# 檢查 session 狀態
check_status() {
    local output
    output=$(jules remote list --session 2>/dev/null || echo "")
    # Case insensitive grep for Completed/completed
    if echo "$output" | grep -qi "$SESSION_ID.*completed"; then
        return 0
    elif echo "$output" | grep -qi "$SESSION_ID.*failed"; then
        return 2
    else
        return 1
    fi
}

# 驗證產出品質
validate_output() {
    log "正在驗證產出品質..."
    local has_content=false
    local empty_files=()
    
    cd "$PROJECT_ROOT"
    local changed_files=$(git diff --name-only HEAD~1 2>/dev/null || echo "")
    
    if [ -z "$changed_files" ]; then
        log_error "沒有偵測到檔案變更"
        return 1
    fi
    
    for file in $changed_files; do
        if [ -f "$PROJECT_ROOT/$file" ]; then
            local size=$(wc -c < "$PROJECT_ROOT/$file" | tr -d ' ')
            if [ "$size" -gt 10 ]; then
                has_content=true
            else
                empty_files+=("$file")
            fi
        fi
    done
    
    if [ ${#empty_files[@]} -gt 0 ]; then
        log "發現空白或內容過少的檔案: ${empty_files[*]}"
    fi
    
    if [ "$has_content" = true ]; then
        log "產出驗證通過"
        return 0
    else
        log_error "產出驗證失敗：所有檔案都是空的"
        return 1
    fi
}

# 主流程
main() {
    log "=========================================="
    log "開始監控 Jules session: $SESSION_ID"
    log "最大重試次數: $MAX_RETRIES"
    log "專案目錄: $PROJECT_ROOT"
    log "=========================================="
    
    local poll_interval=30
    local completed_dir="$PROJECT_ROOT/jules/completed"
    mkdir -p "$completed_dir"
    
    local attempt=0
    local retry_count=0
    
    while true; do
        attempt=$((attempt + 1))
        
        # Capture status without set -e interference
        check_status && status=0 || status=$?
        
        if [ $status -eq 0 ]; then
            log "✓ Session $SESSION_ID 已完成！"
            notify_system "Session $SESSION_ID 已完成！正在拉取結果..."
            
            log "正在拉取結果..."
            cd "$PROJECT_ROOT"
            
            if jules remote pull --session "$SESSION_ID" --apply; then
                log "✓ 已拉取並套用 patch"
                
                if validate_output; then
                    local review_file="$completed_dir/${SESSION_ID}_completed.md"
                    cat > "$review_file" << REVIEWEOF
# Jules Session Review

**Session ID**: $SESSION_ID
**Completed**: $(date)
**Retry Count**: $retry_count

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
                    
                    log "正在喚醒 Antigravity agent..."
                    if command -v agy &> /dev/null; then
                        agy chat --mode agent --add-file "$review_file" \
                            "Jules session $SESSION_ID 已完成。請執行 git diff 查看變更，並進行 code review。如有問題請指出，確認無誤後協助整理 commit message。" &
                        log "✓ 已喚醒 Antigravity agent"
                    elif command -v antigravity &> /dev/null; then
                        antigravity "$PROJECT_ROOT" &
                        log "✓ 已開啟 Antigravity IDE"
                    else
                        log "⚠ 找不到 agy/antigravity 命令"
                    fi
                    
                    notify_system "Jules 結果已套用！Antigravity agent 已啟動 Review"
                    break
                    
                else
                    retry_count=$((retry_count + 1))
                    if [ $retry_count -lt $MAX_RETRIES ]; then
                        log "產出品質不佳，準備重試 ($retry_count/$MAX_RETRIES)"
                        notify_system "Jules 產出為空，正在重試..."
                        
                        git checkout HEAD~1 -- . 2>/dev/null || true
                        
                        local task_file=$(ls -t "$PROJECT_ROOT/jules/tasks/"*.md 2>/dev/null | head -1)
                        if [ -n "$task_file" ]; then
                            log "正在重新提交 Jules task..."
                            local new_output=$(jules new --repo keeponfirst/keeponfirst-agentic-workflow-starter "$(cat "$task_file")" 2>&1)
                            local new_session=$(echo "$new_output" | grep -oE 'ID: [0-9]+' | grep -oE '[0-9]+')
                            
                            if [ -n "$new_session" ]; then
                                log "✓ 新 session 已建立: $new_session"
                                SESSION_ID="$new_session"
                                attempt=0
                            else
                                log_error "重新提交失敗"
                                break
                            fi
                        else
                            log_error "找不到 task 檔案可重試"
                            break
                        fi
                    else
                        log_error "已達最大重試次數 ($MAX_RETRIES)"
                        notify_system "Jules 重試 $MAX_RETRIES 次仍失敗，請手動檢查"
                        break
                    fi
                fi
                
            else
                log_error "拉取結果失敗"
                notify_system "拉取 Jules 結果失敗！"
                break
            fi
            
        elif [ $status -eq 2 ]; then
            log_error "Session $SESSION_ID 執行失敗"
            
            retry_count=$((retry_count + 1))
            if [ $retry_count -lt $MAX_RETRIES ]; then
                log "準備重試 ($retry_count/$MAX_RETRIES)"
                notify_system "Jules session 失敗，正在重試..."
                
                local task_file=$(ls -t "$PROJECT_ROOT/jules/tasks/"*.md 2>/dev/null | head -1)
                if [ -n "$task_file" ]; then
                    log "正在重新提交 Jules task..."
                    local new_output=$(jules new --repo keeponfirst/keeponfirst-agentic-workflow-starter "$(cat "$task_file")" 2>&1)
                    local new_session=$(echo "$new_output" | grep -oE 'ID: [0-9]+' | grep -oE '[0-9]+')
                    
                    if [ -n "$new_session" ]; then
                        log "✓ 新 session 已建立: $new_session"
                        SESSION_ID="$new_session"
                        attempt=0
                    else
                        log_error "重新提交失敗"
                        break
                    fi
                else
                    log_error "找不到 task 檔案可重試"
                    break
                fi
            else
                log_error "已達最大重試次數 ($MAX_RETRIES)"
                notify_system "Jules 重試 $MAX_RETRIES 次仍失敗"
                break
            fi
            
        else
            log "檢查 #$attempt: session 仍在執行中..."
        fi
        
        sleep $poll_interval
    done
    
    log "=========================================="
    log "監控結束"
    log "=========================================="
}

main
