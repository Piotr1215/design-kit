---
name: norm-integrate
description: "Generate Phase 2 integration tasks (project, gitignored)"
---

Generate Phase 2 integration tasks that connect proven components to the actual system.

**CRITICAL**: Integration is ITERATIVE. It often uncovers issues not found in isolation.
Going back to Phase 1 for refinement is NORMAL and EXPECTED in real engineering.

## Setup

```bash
~/.claude/design-kit/auto-connect-design.sh
BRANCH=$(git branch --show-current | sed 's/[^a-zA-Z0-9._-]/-/g')
PLAN_FILE=".claude/specs/$BRANCH/PLAN.md"
PROOFS_DIR=".claude/specs/$BRANCH/proofs"
TASKS_DIR=".claude/specs/$BRANCH/tasks"

# Check if PLAN.md exists
if [[ ! -f "$PLAN_FILE" ]]; then
    echo "❌ ERROR: PLAN.md not found. Run /norm-plan first."
    exit 1
fi

# Check Phase 1 complete - all proofs must have CONTRACT.md + TESTING.md
INCOMPLETE=()
for proof_dir in "$PROOFS_DIR"/*/ ; do
    if [[ ! -f "$proof_dir/CONTRACT.md" ]] || [[ ! -f "$proof_dir/TESTING.md" ]]; then
        INCOMPLETE+=("$(basename "$proof_dir")")
    fi
done

if [[ ${#INCOMPLETE[@]} -gt 0 ]]; then
    echo "❌ ERROR: Phase 1 incomplete. Missing CONTRACT.md or TESTING.md for:"
    printf '  - %s\n' "${INCOMPLETE[@]}"
    exit 1
fi

# Read PLAN.md and proof contracts for context
# Write TASK-P2-*.md files to $TASKS_DIR/
```

## Context

**Load these sources:**
1. Read `.claude/specs/$BRANCH/PLAN.md` - integration requirements
2. Read all `proofs/*/CONTRACT.md` - proven component interfaces
3. Read all `proofs/*/TESTING.md` - validation strategies
4. Read all `proofs/*/FEEDBACK.md` - discoveries and gotchas
5. Check CLAUDE.md for repo conventions
6. Scan actual codebase to understand current implementation
7. **CHECK MEMORY MCP** for proven test harness patterns to reuse Phase 1 harness

## Task Generation Rules

### CRITICAL: Phase 1.5 First!

**Before generating Phase 2 tasks, review feedback:**
1. Read all FEEDBACK.md files from Phase 1
2. Identify any plan changes needed
3. Update PLAN.md if discoveries warrant adjustments
4. Document what you learned and how it affects integration

### Integration Task Structure

Each integration task connects ONE proven component to the actual system.

### Naming Convention

Use: `TASK-P2-C-[Feature]-Integration.md`, `TASK-P2-D-[Feature]-Integration.md`, etc.

Example:
- `TASK-P2-C-pdf-generation-integration.md`
- `TASK-P2-D-auth-middleware-integration.md`

### Parallelism Check for Phase 2

**Unlike Phase 1, Phase 2 tasks may need to be sequential:**
- If tasks modify DIFFERENT files → Parallel ✅
- If tasks modify SAME files → Sequential ❌ (mark dependencies)

Example conflict: Both tasks modify `api/server.go` + `api/handlers.go` → Sequential

### Task Template

```markdown
# TASK-P2-[X]-[Feature]-Integration (Phase 2)

## Goal
Integrate proven [component] from Phase 1 into [target system].

## Prerequisites
- TASK-P1-[X] completed with CONTRACT.md at `.claude/specs/$BRANCH/proofs/[component]/CONTRACT.md`
- [If sequential] TASK-P2-[Y] completed (modifies same files: [list files])

## Current Implementation Analysis

**Existing Code**:
- [File:LineNumbers] - Current implementation
- Problems: [what's broken/missing]
- Constraints: [deployment, infrastructure limitations]

**Proven Solution** (per CONTRACT.md):
- Approach/library from Phase 1
- Benefits: [what it fixes]
- Requirements: [dependencies, infrastructure needs]

## Integration Constraints

**Critical limitations to consider:**
- Static site? Server infrastructure available?
- Build process? Deployment pipeline?
- Browser compatibility? Mobile support?
- Performance requirements? Scale?

## What to Implement

**Must Reference**: `.claude/specs/$BRANCH/proofs/[component]/CONTRACT.md` ONLY (never internal implementation)

**Replace**:
- [File:LineNumbers to be replaced]

**Preserve**:
- [Existing functionality that must not break]

**Add**:
- [New functionality]

## Integration Points

**Existing Functions to Connect**:
- `existingFunction()` - [file:line] ([how it connects])

**New Functions Needed**:
- `newFunction()` - [purpose]

## Deliverable

- Updated [files modified]
- New [dependencies, config files]
- Integration test results with REAL system data
- **Regression test report**: Re-ran Phase 1 harness with real data
  - Copy Phase 1 test harness to project root
  - Update to target REAL system endpoints (not mocks)
  - If Memory MCP has setup guide for this tech, follow it for quick setup
- README.md section: [documentation updates]
- INTEGRATION-ISSUES.md (if contract gaps found)

## Done When

- [ ] Read CONTRACT.md + TESTING.md thoroughly
- [ ] Implemented integration per contract
- [ ] Removed old dependencies/code
- [ ] Feature works with actual system data
- [ ] **Re-ran Phase 1 test harness with real data** (regression check)
- [ ] No regressions in existing functionality
- [ ] Error handling for edge cases
- [ ] Integration-level automated tests created
- [ ] Manual testing: [specific test count/scenarios]
- [ ] Updated documentation

## If Contract is Insufficient

**If integration reveals contract gaps, DO NOT work around them:**

1. Document issues in `INTEGRATION-ISSUES.md`:
   ```markdown
   # Integration Issues Found

   ## Issue 1: [Description]
   - What's missing from CONTRACT.md
   - Impact on integration
   - Required refinement

   ## Issue 2: [Description]
   ...
   ```

2. Create `TASK-P1-[X]-REFINEMENT-[Issue].md` in tasks/ directory
3. Agent must return to Phase 1, refine proof, update CONTRACT + TESTING
4. Re-run validation harness
5. Return to Phase 2 integration after refinement complete

**Do NOT throw away Phase 1 work. Refine it.**
```

## Your Task

For each component that needs integration:
1. Analyze existing codebase implementation
2. Read corresponding proof CONTRACT.md + TESTING.md
3. Create one TASK-P2-*.md file in `.claude/specs/$BRANCH/tasks/`
4. Specify file-level integration points
5. Mark sequential dependencies if tasks modify same files
6. Include regression testing requirements

## Sequential Dependencies Example

If multiple tasks modify the same files:

```markdown
## Prerequisites
- TASK-P1-A completed with CONTRACT.md + TESTING.md
- **TASK-P2-C completed** (modifies same files: api/server.go, api/handlers.go)
```

This ensures tasks run in order, not parallel.

## Anti-Patterns to Avoid

❌ Working around insufficient contracts (go back to Phase 1!)
❌ Ignoring Phase 1 FEEDBACK.md discoveries
❌ Referencing proof implementation internals (use CONTRACT.md only)
❌ Skipping Phase 1 harness re-run with real data
❌ Forgetting to check for file conflicts (parallel vs sequential)

## Verification

After generating tasks:
- ✅ All tasks reference CONTRACT.md + TESTING.md (black-box)
- ✅ Sequential dependencies marked where files conflict
- ✅ Regression testing included (re-run Phase 1 harness)
- ✅ Refinement path clear if contracts insufficient

## Next Steps

After Phase 2 tasks are generated:
- Agent(s) execute integration tasks
- Re-run Phase 1 harnesses with real system data
- If contract gaps found → create REFINEMENT tasks
- Verify no regressions in existing functionality
- Update documentation
