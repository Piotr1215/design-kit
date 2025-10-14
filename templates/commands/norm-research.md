---
name: norm-research
description: "Generate Phase 1 parallel proof tasks (project, gitignored)"
---

Generate Phase 1 proof-of-concept tasks. Each task must be 100% independent and test-driven.

## Setup

```bash
~/.claude/design-kit/auto-connect-design.sh
BRANCH=$(git branch --show-current | sed 's/[^a-zA-Z0-9._-]/-/g')
PLAN_FILE=".claude/specs/$BRANCH/PLAN.md"
TASKS_DIR=".claude/specs/$BRANCH/tasks"

# Check if PLAN.md exists
if [[ ! -f "$PLAN_FILE" ]]; then
    echo "❌ ERROR: PLAN.md not found. Run /norm-plan first."
    exit 1
fi

# Read PLAN.md for context
# Write TASK-P1-*.md files to $TASKS_DIR/
```

## Context

**Load these sources:**
1. Read `.claude/specs/$BRANCH/PLAN.md` - component breakdown
2. Check CLAUDE.md for repo conventions
3. Scan codebase for existing patterns

## Task Generation Rules

### CRITICAL: Parallelism Check

**Each task MUST be 100% independent:**
- ✅ Can run simultaneously with all other Phase 1 tasks
- ✅ Uses generic/sample test data (NOT real system data)
- ✅ Proves ONE component works in isolation
- ❌ NO dependencies on other tasks
- ❌ NO integration with actual system (that's Phase 2)

### Naming Convention

Use this pattern: `TASK-P1-A-[Component].md`, `TASK-P1-B-[Component].md`, etc.

Example:
- `TASK-P1-A-pdf-generation.md`
- `TASK-P1-B-auth-middleware.md`
- `TASK-P1-C-graphql-parser.md`

### Task Template (20-40 lines max)

```markdown
# TASK-P1-[X]-[Component]

## Goal
Prove [component X] works reliably in isolation with automated validation.

## PRIMARY OBJECTIVE: Design MINIMAL Testing Strategy

**BEFORE implementing, determine HOW to test this component (keep it simple):**
- How will we validate correctness automatically? (pick ONE validation tool/library)
- What metrics define success? (1-2 key metrics, not 10)
- What edge cases must be covered? (list 3-5 critical scenarios)
- **If you cannot devise testing strategy, STOP and report to user immediately.**

**Goal**: Get validation working quickly, THEN expand test coverage.
**NOT**: Design elaborate 7-layer validation architecture before running any tests.

## What to Explore

- Try at least 2 approaches: Library A vs Library B, or Technique X vs Y
- Test with: [describe generic test data]
- Compare tradeoffs: size, performance, complexity, testability

## Research Starting Points

- [Library/tool name 1]
- [Library/tool name 2]
- [Testing framework for validation]

## Deliverable

Working proof in `.claude/specs/$BRANCH/proofs/[component-name]/` with:

**Order matters - complete tests BEFORE writing docs:**
- [ ] Automated test harness implemented (run.sh)
- [ ] **Test Harness Contract implemented:**
  - [ ] run.sh exits 0 on success, 1 on any failure
  - [ ] results/summary.json generated (timestamp, total, passed, failed, pass_rate, failures[])
  - [ ] results/logs/*.json contain individual test details
- [ ] **100+ test cases EXECUTED** (not just planned!) across diverse scenarios
- [ ] Edge cases for YOUR use case tested (not generic happy-path)
- [ ] Tested 2+ approaches, picked ONE winner with rationale
- [ ] Zero failures in last 50 consecutive runs
- [ ] **THEN write docs from test data:**
- [ ] TESTING.md ≤50 lines (how to run, what's validated, pass criteria from empirical data)
- [ ] CONTRACT.md ≤100 lines (API + gotchas discovered during testing)
- [ ] FEEDBACK.md ≤30 lines (design choices + surprises learned from test results)
- [ ] README.md ≤30 lines (quick start, dependencies)

## Edge Cases for YOUR Use Case

Think: "What breaks in MY specific scenario?"
- API endpoint? → Large payloads, timeouts, retries, malformed JSON, Unicode
- React form? → Async validation, rapid input, browser autofill, keyboard nav
- K8s controller? → Multiple replicas, network partition, OOM, node drain
- NOT generic happy-path tests!

## Done When

All checkboxes above are complete with empirical evidence.
```

## Your Task

For each component in PLAN.md:
1. Create one TASK-P1-*.md file in `.claude/specs/$BRANCH/tasks/`
2. Keep each task 20-40 lines
3. Emphasize testing strategy upfront
4. Ensure 100% parallelism (no cross-task dependencies)
5. Focus on WHAT to prove, not HOW to code it

## Anti-Patterns to Avoid

❌ Creating dependencies between tasks
❌ Including implementation code in task files
❌ Making tasks longer than one screen (40 lines max)
❌ Allowing manual validation (must be automated)
❌ Forgetting the Test Harness Contract (summary.json + logs/)

## Verification

After generating tasks, ask yourself:
- ✅ Can all tasks start simultaneously?
- ✅ Does each task use generic test data?
- ✅ Is testing strategy clearly defined?
- ✅ Are tasks short and focused (20-40 lines)?

## Next Steps

After tasks are generated:
- Agent(s) execute Phase 1 tasks independently
- Each produces CONTRACT.md + TESTING.md + 100+ test runs
- Review all FEEDBACK.md files
- Update PLAN.md if discoveries warrant changes
- Then run `/norm-integrate` for Phase 2
