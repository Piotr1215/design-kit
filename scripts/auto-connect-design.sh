#!/usr/bin/env bash
set -euo pipefail

# Setup design-kit directory for branch
# Each command will check for overwrites individually

CLAUDE_DIR=".claude"

# Create base structure if needed
if [[ ! -d "$CLAUDE_DIR" ]]; then
    mkdir -p "$CLAUDE_DIR/specs"

    # Add to .gitignore if needed
    if [[ -f .gitignore ]] && ! grep -q "^\.claude/" .gitignore; then
        echo -e "\n# Claude design-kit artifacts\n.claude/" >> .gitignore
    fi
fi

# Get current branch name
BRANCH=$(git branch --show-current 2>/dev/null || echo "detached")

# Sanitize branch name for directory (replace / with -)
SAFE_BRANCH=$(echo "$BRANCH" | sed 's/[^a-zA-Z0-9._-]/-/g')

# Create branch directory with norm structure
BRANCH_DIR="$CLAUDE_DIR/specs/$SAFE_BRANCH"
if [[ ! -d "$BRANCH_DIR" ]]; then
    mkdir -p "$BRANCH_DIR/proofs"
    mkdir -p "$BRANCH_DIR/tasks"
    echo "✓ Created new branch directory: $BRANCH"
else
    echo "✓ Branch directory exists: $BRANCH"
    # Ensure subdirectories exist
    mkdir -p "$BRANCH_DIR/proofs"
    mkdir -p "$BRANCH_DIR/tasks"
fi

# Show what we have
echo "→ Branch directory: $BRANCH_DIR"
if [[ -f "$BRANCH_DIR/PLAN.md" ]]; then
    echo "  Has PLAN.md"
fi
if [[ -d "$BRANCH_DIR/proofs" ]]; then
    PROOF_COUNT=$(find "$BRANCH_DIR/proofs" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | wc -l)
    echo "  Has $PROOF_COUNT proof(s)"
fi
if [[ -d "$BRANCH_DIR/tasks" ]]; then
    TASK_COUNT=$(find "$BRANCH_DIR/tasks" -name "TASK-*.md" 2>/dev/null | wc -l)
    echo "  Has $TASK_COUNT task(s)"
fi

# Output the branch name for use in commands
echo ""
echo "Branch: $SAFE_BRANCH"