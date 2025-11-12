#!/usr/bin/env bash
set -euo pipefail

# Simple script to show a specific task
TASK_ID="${1:-}"

if [[ -z "$TASK_ID" ]]; then
    echo "Usage: ./.claude/show-task.sh [A|B|P2-A|etc]"
    echo ""
    echo "Examples:"
    echo "  ./.claude/show-task.sh A"
    echo "  ./.claude/show-task.sh B"
    exit 1
fi

BRANCH_DIR=$(~/.claude/design-kit/auto-connect-design.sh | grep "Branch directory:" | cut -d: -f2 | xargs)
TASKS_DIR="$BRANCH_DIR/tasks"

# Normalize task ID
if [[ "$TASK_ID" =~ ^[A-Z]$ ]]; then
    TASK_PATTERN="TASK-P1-${TASK_ID}-"
elif [[ "$TASK_ID" =~ ^P[12]-[A-Z]$ ]]; then
    TASK_PATTERN="TASK-${TASK_ID}-"
else
    echo "Invalid task ID: $TASK_ID"
    exit 1
fi

TASK_FILE=$(ls "$TASKS_DIR"/$TASK_PATTERN*.md 2>/dev/null | head -1)

if [[ -z "$TASK_FILE" ]]; then
    echo "Task not found: $TASK_ID"
    exit 1
fi

echo "Task: $(basename "$TASK_FILE" .md)"
echo "Path: $(realpath "$TASK_FILE")"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
cat "$TASK_FILE"
