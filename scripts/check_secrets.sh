#!/bin/bash

# check_secrets.sh - 敏感資訊掃描腳本
# 用法: ./scripts/check_secrets.sh

set -e

# 顏色定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 取得腳本所在目錄的父目錄（專案根目錄）
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

echo "掃描敏感資訊..."

# 計數器
issues=0

# 檢查 .env 是否被 git 追蹤
if [ -d "$PROJECT_ROOT/.git" ]; then
    if git -C "$PROJECT_ROOT" ls-files --error-unmatch .env &>/dev/null; then
        echo -e "${RED}✗ .env 被 git 追蹤！${NC}"
        echo "  請執行: git rm --cached .env"
        issues=$((issues + 1))
    else
        echo -e "${GREEN}✓${NC} .env 未被追蹤"
    fi
else
    echo -e "${YELLOW}⚠${NC} 不是 git repo，跳過 .env 追蹤檢查"
fi

# 定義敏感 pattern
patterns=(
    # API Keys
    'AIza[0-9A-Za-z_-]{35}'           # Google API Key
    'sk-[a-zA-Z0-9]{20,}'             # OpenAI API Key
    'ghp_[a-zA-Z0-9]{36}'             # GitHub Personal Access Token
    'gho_[a-zA-Z0-9]{36}'             # GitHub OAuth Token
    
    # Generic patterns
    'api[_-]?key[[:space:]]*[:=][[:space:]]*["\047][^"\047]{10,}'
    'secret[_-]?key[[:space:]]*[:=][[:space:]]*["\047][^"\047]{10,}'
    'password[[:space:]]*[:=][[:space:]]*["\047][^"\047]{6,}'
    'token[[:space:]]*[:=][[:space:]]*["\047][^"\047]{10,}'
)

# 要掃描的檔案類型
include_patterns=(
    "*.md"
    "*.txt"
    "*.json"
    "*.yaml"
    "*.yml"
    "*.js"
    "*.ts"
    "*.py"
    "*.swift"
    "*.sh"
)

# 要排除的目錄
exclude_dirs=(
    ".git"
    "node_modules"
    ".env.example"
)

# 建立 exclude 參數
exclude_args=""
for dir in "${exclude_dirs[@]}"; do
    exclude_args="$exclude_args --exclude-dir=$dir"
done
exclude_args="$exclude_args --exclude=*.example"
exclude_args="$exclude_args --exclude=check_secrets.sh"

# 建立 include 參數
include_args=""
for pattern in "${include_patterns[@]}"; do
    include_args="$include_args --include=$pattern"
done

# 掃描每個 pattern
echo ""
echo "掃描常見敏感 pattern..."

for pattern in "${patterns[@]}"; do
    # 使用 grep 掃描
    results=$(grep -r -E -n $include_args $exclude_args "$pattern" "$PROJECT_ROOT" 2>/dev/null || true)
    
    if [ -n "$results" ]; then
        echo -e "${RED}✗ 發現可疑內容:${NC}"
        echo "$results" | while read -r line; do
            echo "  $line"
        done
        issues=$((issues + 1))
    fi
done

# 特別檢查：hardcoded strings in code
echo ""
echo "檢查 hardcoded secrets..."

# 找 = "AIza 這種 pattern
hardcoded=$(grep -r -n $include_args $exclude_args '=[[:space:]]*"AIza' "$PROJECT_ROOT" 2>/dev/null || true)
if [ -n "$hardcoded" ]; then
    echo -e "${RED}✗ 發現 hardcoded Google API Key:${NC}"
    echo "$hardcoded"
    issues=$((issues + 1))
fi

# 結果
echo ""
if [ $issues -eq 0 ]; then
    echo -e "${GREEN}✓ 未發現敏感資訊${NC}"
    exit 0
else
    echo -e "${RED}✗ 發現 $issues 個潛在問題${NC}"
    echo ""
    echo "建議："
    echo "1. 移除或替換敏感資訊"
    echo "2. 使用環境變數 (.env) 儲存 keys"
    echo "3. 確保 .env 在 .gitignore 中"
    exit $issues
fi
