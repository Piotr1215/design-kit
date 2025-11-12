View or work on a specific task by its identifier (e.g., "A", "B", "P2-A").

## Setup

```bash
~/.claude/design-kit/auto-connect-design.sh
BRANCH=$(git branch --show-current | sed 's/[^a-zA-Z0-9._-]/-/g')
TASKS_DIR=".claude/specs/$BRANCH/tasks"
PROOFS_DIR=".claude/specs/$BRANCH/proofs"

# Get task identifier from argument
TASK_ID="${1:-}"

if [[ -z "$TASK_ID" ]]; then
    echo "❌ ERROR: No task identifier provided."
    echo ""
    echo "Usage: /norm-task [identifier]"
    echo ""
    echo "Examples:"
    echo "  /norm-task A       - Work on TASK-P1-A"
    echo "  /norm-task B       - Work on TASK-P1-B"
    echo "  /norm-task P2-A    - Work on TASK-P2-A"
    echo ""
    echo "Tip: Run /norm-tasks to see all available tasks"
    exit 1
fi

# Normalize task ID (handle both "A" and "P1-A" formats)
if [[ "$TASK_ID" =~ ^[A-Z]$ ]]; then
    # Single letter, assume Phase 1
    TASK_PATTERN="TASK-P1-${TASK_ID}-"
elif [[ "$TASK_ID" =~ ^P[12]-[A-Z]$ ]]; then
    # Full format like "P1-A" or "P2-B"
    TASK_PATTERN="TASK-${TASK_ID}-"
else
    echo "❌ ERROR: Invalid task identifier: $TASK_ID"
    echo "Expected format: A, B, C or P1-A, P2-B, etc."
    exit 1
fi

# Find matching task file
TASK_FILE=$(ls "$TASKS_DIR"/$TASK_PATTERN*.md 2>/dev/null | head -1)

if [[ -z "$TASK_FILE" ]]; then
    echo "❌ ERROR: No task found matching: $TASK_ID"
    echo ""
    echo "Run /norm-tasks to see all available tasks"
    exit 1
fi
```

## Your Task

Display the task and provide context for working on it:

1. **Show task header** with full path
2. **Display task status** (pending/in-progress/completed)
3. **Show the task content** (read the markdown file)
4. **Provide next steps** based on status

## Output Format

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
TASK: [TASK-P1-A-component-name]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Status: [pending/in-progress/completed]
Path: [full-absolute-path]
Proof: [proof-directory-path or "Not started"]

[... full task content ...]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Next Steps:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[Based on status, provide relevant next steps]

For pending tasks:
  "Ready to start. Create proof directory and begin implementation."

For in-progress tasks:
  "Continue working on proof in: [proof-path]"
  "Deliverables needed: CONTRACT.md, TESTING.md, FEEDBACK.md"

For completed tasks:
  "Task completed! Review artifacts:"
  "  - CONTRACT.md: [path]"
  "  - TESTING.md: [path]"
  "  - FEEDBACK.md: [path]"
```

## Status Detection

Same logic as /norm-tasks:
- **pending**: Task file exists, no proof directory
- **in-progress**: Proof directory exists but missing deliverables
- **completed**: All deliverables present (CONTRACT.md, TESTING.md, FEEDBACK.md)

## Extract Proof Directory Name

From `TASK-P1-A-json-endpoint-validation.md`, extract `json-endpoint-validation`:
```bash
COMPONENT_NAME=$(basename "$TASK_FILE" .md | sed 's/^TASK-P[12]-[A-Z]-//')
PROOF_DIR="$PROOFS_DIR/$COMPONENT_NAME"
```

## Implementation

1. Find and read the task file
2. Detect status by checking proof directory
3. Display task content with context
4. Provide actionable next steps

This makes it easy to jump into working on a specific task without remembering paths.
