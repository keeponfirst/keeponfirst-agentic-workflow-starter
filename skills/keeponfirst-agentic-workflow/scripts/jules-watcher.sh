#!/bin/bash

# jules-watcher.sh - Portable Jules session watcher
# Usage: bash jules-watcher.sh <session_id> [max_retries] [project_root] [repo_name]
#
# This script monitors a Jules session in the background and notifies when complete.

SESSION_ID="$1"
MAX_RETRIES="${2:-3}"
PROJECT_ROOT="${3:-$(pwd)}"
REPO_NAME="${4:-}"

if [ -z "$SESSION_ID" ]; then
    echo "Usage: bash jules-watcher.sh <session_id> [max_retries] [project_root] [repo_name]"
    echo ""
    echo "Get session ID with: jules remote list --session"
    exit 1
fi

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Ensure log directory exists
LOG_DIR="$PROJECT_ROOT/jules"
LOG_FILE="$LOG_DIR/watcher.log"
mkdir -p "$LOG_DIR"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

notify_system() {
    local message="$1"
    if command -v osascript &> /dev/null; then
        osascript -e "display notification \"$message\" with title \"Antigravity\" subtitle \"Jules Task 完成\" sound name \"Glass\"" 2>/dev/null || true
    elif command -v notify-send &> /dev/null; then
        notify-send "Antigravity" "$message" 2>/dev/null || true
    fi
}

check_status() {
    local output
    output=$(jules remote list --session 2>/dev/null || echo "")
    if echo "$output" | grep -qi "$SESSION_ID.*completed"; then
        return 0
    elif echo "$output" | grep -qi "$SESSION_ID.*failed"; then
        return 2
    else
        return 1
    fi
}

log "=========================================="
log "Starting Jules watcher"
log "Session ID: $SESSION_ID"
log "Max Retries: $MAX_RETRIES"
log "Project Root: $PROJECT_ROOT"
log "=========================================="

POLL_INTERVAL=30
COMPLETED_DIR="$PROJECT_ROOT/jules/completed"
mkdir -p "$COMPLETED_DIR"

attempt=0
retry_count=0

while true; do
    attempt=$((attempt + 1))
    
    check_status && status=0 || status=$?
    
    if [ $status -eq 0 ]; then
        log "✓ Session $SESSION_ID completed!"
        notify_system "Session $SESSION_ID 完成！正在拉取結果..."
        
        cd "$PROJECT_ROOT"
        
        pull_output=$(jules remote pull --session "$SESSION_ID" --apply 2>&1)
        echo "$pull_output"
        
        if echo "$pull_output" | grep -qi "No diff found"; then
            log "⚠ Jules completed but no file changes produced"
            notify_system "Jules 完成但沒有產生變更"
            break
        fi
        
        if echo "$pull_output" | grep -qi "applied successfully\|Patch applied"; then
            log "✓ Patch applied successfully"
            
            review_file="$COMPLETED_DIR/${SESSION_ID}_completed.md"
            cat > "$review_file" << REVIEWEOF
# Jules Session Review

**Session ID**: $SESSION_ID
**Completed**: $(date)

## Review Tasks

1. Run \`git diff\` to check changes
2. Verify code meets project standards
3. Run tests to confirm functionality
4. If issues found, note what needs fixing

## Next Steps

Tell Antigravity: "請 review 剛才 Jules 完成的變更，並幫我整理 commit"
REVIEWEOF
            
            notify_system "請對 Antigravity 說：請 review 剛才 Jules 完成的變更"
            
            log ""
            log "====== REVIEW READY ======"
            log "Tell Antigravity:"
            log "  請 review 剛才 Jules 完成的變更"
            log "=========================="
            log ""
            
            break
        else
            log "Error: Failed to pull results"
            notify_system "拉取 Jules 結果失敗！"
            break
        fi
        
    elif [ $status -eq 2 ]; then
        log "Session $SESSION_ID failed"
        
        retry_count=$((retry_count + 1))
        if [ $retry_count -lt $MAX_RETRIES ]; then
            log "Preparing retry ($retry_count/$MAX_RETRIES)"
            notify_system "Jules session 失敗，正在重試..."
            
            task_file=$(ls -t "$PROJECT_ROOT/jules/tasks/"*.md 2>/dev/null | head -1)
            if [ -n "$task_file" ] && [ -n "$REPO_NAME" ]; then
                log "Re-submitting Jules task..."
                new_output=$(jules new --repo "$REPO_NAME" "$(cat "$task_file")" 2>&1)
                new_session=$(echo "$new_output" | grep -oE 'ID: [0-9]+' | grep -oE '[0-9]+')
                
                if [ -n "$new_session" ]; then
                    log "✓ New session created: $new_session"
                    SESSION_ID="$new_session"
                    attempt=0
                else
                    log "Error: Failed to re-submit"
                    break
                fi
            else
                log "Error: No task file found or repo name not specified"
                break
            fi
        else
            log "Max retries reached ($MAX_RETRIES)"
            notify_system "Jules 重試 $MAX_RETRIES 次仍失敗"
            break
        fi
        
    else
        log "Check #$attempt: session still running..."
    fi
    
    sleep $POLL_INTERVAL
done

log "=========================================="
log "Watcher finished"
log "=========================================="
