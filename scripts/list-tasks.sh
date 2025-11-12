#!/usr/bin/env bash
set -euo pipefail

# Simple script to list tasks with their paths
BRANCH_DIR=$(~/.claude/design-kit/auto-connect-design.sh | grep "Branch directory:" | cut -d: -f2 | xargs)
TASKS_DIR="$BRANCH_DIR/tasks"

if [[ ! -d "$TASKS_DIR" ]]; then
    echo "No tasks found in: $TASKS_DIR"
    exit 1
fi

echo "Tasks in current branch:"
echo ""

for task in "$TASKS_DIR"/TASK-*.md; do
    if [[ -f "$task" ]]; then
        basename=$(basename "$task" .md)
        echo "  $basename"
        echo "  → $(realpath "$task")"
        echo ""
    fi
done
