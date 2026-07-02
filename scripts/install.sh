#!/bin/bash

# install.sh - One-line installer for the KOF Agentic Workflow skill
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/keeponfirst/keeponfirst-agentic-workflow-starter/main/scripts/install.sh | bash
#
# Or install for a specific IDE only:
#   curl -fsSL .../install.sh | bash -s -- claude
#
# Supported targets: antigravity, cursor, claude, codex, all (default: auto-detect)

set -e

REPO="keeponfirst/keeponfirst-agentic-workflow-starter"
SKILL_NAME="keeponfirst-agentic-workflow"
TARBALL_URL="https://codeload.github.com/${REPO}/tar.gz/refs/heads/main"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

TARGET="${1:-auto}"

echo -e "${BLUE}KOF Agentic Workflow — Skill Installer${NC}"
echo ""

# Download skill to a temp dir
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

echo "Downloading skill from ${REPO}..."
curl -fsSL "$TARBALL_URL" | tar -xz -C "$TMP_DIR"

SKILL_SRC="$TMP_DIR/keeponfirst-agentic-workflow-starter-main/skills/$SKILL_NAME"
if [ ! -d "$SKILL_SRC" ]; then
    echo -e "${RED}Error: skill directory not found in downloaded archive${NC}"
    exit 1
fi

install_to() {
    local ide="$1"
    local dest_parent="$2"
    mkdir -p "$dest_parent"
    rm -rf "${dest_parent:?}/$SKILL_NAME"
    cp -r "$SKILL_SRC" "$dest_parent/"
    echo -e "  ${GREEN}✓${NC} $ide → $dest_parent/$SKILL_NAME"
    INSTALLED=$((INSTALLED + 1))
}

# IDE detection: install where the IDE's config directory already exists
maybe_install() {
    local ide="$1"
    local detect_dir="$2"
    local dest_parent="$3"
    if [ "$TARGET" = "$ide" ] || [ "$TARGET" = "all" ]; then
        install_to "$ide" "$dest_parent"
    elif [ "$TARGET" = "auto" ] && [ -d "$detect_dir" ]; then
        install_to "$ide" "$dest_parent"
    fi
}

INSTALLED=0
echo ""
echo "Installing skill..."

maybe_install "antigravity" "$HOME/.gemini"  "$HOME/.gemini/antigravity/skills"
maybe_install "cursor"      "$HOME/.cursor"  "$HOME/.cursor/skills"
maybe_install "claude"      "$HOME/.claude"  "$HOME/.claude/skills"
maybe_install "codex"       "$HOME/.codex"   "$HOME/.codex/skills"

if [ "$INSTALLED" -eq 0 ]; then
    echo -e "${YELLOW}No supported IDE detected.${NC}"
    echo ""
    echo "Install explicitly with one of:"
    echo "  bash -s -- antigravity   # Antigravity"
    echo "  bash -s -- cursor        # Cursor"
    echo "  bash -s -- claude        # Claude Code"
    echo "  bash -s -- codex         # OpenAI Codex"
    echo "  bash -s -- all           # All of the above"
    exit 1
fi

echo ""
echo -e "${GREEN}Done!${NC} Trigger the workflow in your IDE with:"
echo ""
echo "  /kof                          # shorthand"
echo "  KOF workflow add dark mode    # natural language"
echo ""
echo "Optional: install Jules CLI for cloud code execution:"
echo "  npm install -g @google/jules && jules login"
