#!/bin/bash

# bootstrap.sh - 專案初始化腳本
# 用法: ./scripts/bootstrap.sh

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

echo -e "${BLUE}"
echo "╔═══════════════════════════════════════════╗"
echo "║   Bootstrap: 專案初始化                    ║"
echo "╚═══════════════════════════════════════════╝"
echo -e "${NC}"

# 建立必要目錄
echo "建立目錄結構..."

directories=(
    "nanobanana/queue"
    "nanobanana/completed"
    "assets/generated/icons"
    "assets/generated/illustrations"
    "assets/generated/heroes"
    "jules/tasks"
    "jules/completed"
)

for dir in "${directories[@]}"; do
    mkdir -p "$PROJECT_ROOT/$dir"
    echo -e "  ${GREEN}✓${NC} $dir/"
done

# 建立 .gitkeep
echo ""
echo "建立 .gitkeep 檔案..."

gitkeep_dirs=(
    "nanobanana/queue"
    "nanobanana/completed"
    "assets/generated/icons"
    "assets/generated/illustrations"
    "assets/generated/heroes"
    "jules/tasks"
    "jules/completed"
)

for dir in "${gitkeep_dirs[@]}"; do
    touch "$PROJECT_ROOT/$dir/.gitkeep"
done
echo -e "  ${GREEN}✓${NC} .gitkeep 檔案已建立"

# 複製 .env.example → .env
echo ""
echo "設定環境變數..."

# 如果 .env.example 不存在，自動建立最小可用版本
if [ ! -f "$PROJECT_ROOT/.env.example" ]; then
    echo -e "  ${YELLOW}警告: .env.example 不存在，自動建立${NC}"
    cat > "$PROJECT_ROOT/.env.example" << 'ENVEOF'
# Gemini CLI 配置
# 從 https://aistudio.google.com/apikey 取得
GEMINI_API_KEY=your_gemini_api_key_here

# 專案配置（可選，目前腳本未使用，供未來擴展）
PROJECT_NAME=my-project
OUTPUT_DIR=assets/generated
ENVEOF
    echo -e "  ${GREEN}✓${NC} 已建立 .env.example"
fi

if [ -f "$PROJECT_ROOT/.env" ]; then
    echo -e "  ${YELLOW}注意: .env 已存在，跳過${NC}"
else
    cp "$PROJECT_ROOT/.env.example" "$PROJECT_ROOT/.env"
    echo -e "  ${GREEN}✓${NC} 已複製 .env.example → .env"
fi

# 設定腳本執行權限
echo ""
echo "設定腳本執行權限..."

chmod +x "$PROJECT_ROOT/scripts/"*.sh 2>/dev/null || true
echo -e "  ${GREEN}✓${NC} scripts/*.sh"

# 完成
echo ""
echo -e "${GREEN}╔═══════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║   初始化完成！                             ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════════╝${NC}"
echo ""
echo "下一步："
echo ""
echo "1. 編輯 .env 填入你的 API keys:"
echo -e "   ${BLUE}vim .env${NC}"
echo ""
echo "2. 產生一份 Plan:"
echo -e "   ${BLUE}./scripts/agent.sh plan${NC}"
echo ""
echo "3. 查看文件了解 workflow:"
echo -e "   ${BLUE}cat docs/WORKFLOW.md${NC}"
echo ""
