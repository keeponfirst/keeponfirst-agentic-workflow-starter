#!/bin/bash

# agentic-workflow-init.sh - Initialize agentic workflow structure in any project
# Usage: bash agentic-workflow-init.sh [project_path]
#
# This script creates the necessary directory structure and templates
# for using the agentic workflow in any repository.

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

PROJECT_ROOT="${1:-.}"

echo -e "${BLUE}╔═══════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   Agentic Workflow Initializer            ║${NC}"
echo -e "${BLUE}║   Antigravity + Gemini CLI + Jules        ║${NC}"
echo -e "${BLUE}╚═══════════════════════════════════════════╝${NC}"
echo ""

# Create directory structure
echo -e "${BLUE}Creating directory structure...${NC}"

mkdir -p "$PROJECT_ROOT/plans"
mkdir -p "$PROJECT_ROOT/jules/tasks"
mkdir -p "$PROJECT_ROOT/jules/completed"
mkdir -p "$PROJECT_ROOT/nanobanana/queue"
mkdir -p "$PROJECT_ROOT/nanobanana/completed"
mkdir -p "$PROJECT_ROOT/assets/generated"

echo -e "  ${GREEN}✓${NC} plans/"
echo -e "  ${GREEN}✓${NC} jules/tasks/"
echo -e "  ${GREEN}✓${NC} jules/completed/"
echo -e "  ${GREEN}✓${NC} nanobanana/queue/"
echo -e "  ${GREEN}✓${NC} assets/generated/"

# Create plan template
cat > "$PROJECT_ROOT/plans/_TEMPLATE.md" << 'EOF'
# PLAN: [Feature Name]

> Created: [Date]
> Status: [ ] PLAN → [ ] ASSETS → [ ] CODE → [ ] REVIEW → [ ] RELEASE

## Feature Overview

<!-- What this feature does and why -->

## Technical Design

<!-- How it will be implemented -->

## Asset Requirements (Nano Banana)

<!-- Leave empty if no assets needed -->

| Filename | Size | Purpose |
|----------|------|---------|
| | | |

## Code Tasks (Jules)

1. <!-- Task 1 -->
2. <!-- Task 2 -->

## Acceptance Criteria

- [ ] <!-- Criterion 1 -->
- [ ] <!-- Criterion 2 -->

## Notes

<!-- Any additional context -->
EOF

echo -e "  ${GREEN}✓${NC} plans/_TEMPLATE.md"

# Create .gitignore additions
if [ -f "$PROJECT_ROOT/.gitignore" ]; then
    if ! grep -q "jules/watcher.log" "$PROJECT_ROOT/.gitignore"; then
        echo "" >> "$PROJECT_ROOT/.gitignore"
        echo "# Agentic Workflow" >> "$PROJECT_ROOT/.gitignore"
        echo "jules/watcher.log" >> "$PROJECT_ROOT/.gitignore"
        echo "nanobanana/queue/*.md" >> "$PROJECT_ROOT/.gitignore"
        echo -e "  ${GREEN}✓${NC} Updated .gitignore"
    fi
fi

echo ""
echo -e "${GREEN}✓ Agentic Workflow initialized!${NC}"
echo ""
echo "Next steps:"
echo "  1. Copy a plan template: cp plans/_TEMPLATE.md plans/my-feature.md"
echo "  2. Fill in the plan details"
echo "  3. Use '/workflow' command to start the workflow"
echo ""
echo -e "${YELLOW}Prerequisites:${NC}"
echo "  - jules auth login"
echo "  - gemini auth login"
