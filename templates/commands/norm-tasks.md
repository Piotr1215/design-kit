List all Phase 1 and Phase 2 tasks with their paths and status.

## Setup

```bash
# Get branch directory from auto-connect script
BRANCH_INFO=$(~/.claude/design-kit/auto-connect-design.sh)
BRANCH_DIR=$(echo "$BRANCH_INFO" | grep "Branch directory:" | cut -d: -f2 | xargs)

if [[ -z "$BRANCH_DIR" ]]; then
    echo "❌ Failed to detect branch directory"
    exit 1
fi

TASKS_DIR="$BRANCH_DIR/tasks"
PROOFS_DIR="$BRANCH_DIR/proofs"

# Check if tasks directory exists
if [[ ! -d "$TASKS_DIR" ]]; then
    echo "❌ No tasks directory found."
    echo "Run /norm-research to generate Phase 1 tasks."
    exit 1
fi
```

## Your Task

List all tasks in a clear, organized format with:
1. Task number and name
2. Full absolute path
3. Status (pending/in-progress/completed based on proof directory existence)
4. Phase indicator (P1 or P2)

## Output Format

```
Branch: [branch-name]
Location: .claude/specs/[branch-name]/tasks/

Phase 1 Tasks (Research - Parallel):
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

1. TASK-P1-A-[component] [STATUS: pending/in-progress/completed]
   Path: [full-absolute-path]
   Proof: [proof-directory-path or "Not started"]

2. TASK-P1-B-[component] [STATUS: ...]
   Path: [full-absolute-path]
   Proof: [proof-directory-path or "Not started"]

Phase 2 Tasks (Integration - Sequential):
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

1. TASK-P2-A-[component] [STATUS: ...]
   Path: [full-absolute-path]

Quick Commands:
  /norm-task A     - View/work on TASK-P1-A
  /norm-task B     - View/work on TASK-P1-B
  /norm-task P2-A  - View/work on TASK-P2-A
```

## Status Detection

Determine status by checking:
- **pending**: Task file exists, no proof directory
- **in-progress**: Proof directory exists but no CONTRACT.md
- **completed**: Proof directory has CONTRACT.md + TESTING.md + FEEDBACK.md

## Implementation

Read all files matching `TASK-*.md` in `$TASKS_DIR`, sort them by phase and letter, then display with full paths.

For Phase 1 tasks, check if corresponding proof directory exists:
```bash
TASK_NAME="json-endpoint-validation"  # extracted from TASK-P1-A-json-endpoint-validation.md
PROOF_DIR="$PROOFS_DIR/$TASK_NAME"
```
