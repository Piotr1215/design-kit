---
name: norm-plan
description: "Create master plan with phases (project, gitignored)"
---

Create a master implementation plan following the norm philosophy: test-driven, parallel execution, contract-based integration.

## Setup

```bash
~/.claude/design-kit/auto-connect-design.sh
BRANCH=$(git branch --show-current | sed 's/[^a-zA-Z0-9._-]/-/g')
PLAN_FILE=".claude/specs/$BRANCH/PLAN.md"

# Check if PLAN.md already exists
if [[ -f "$PLAN_FILE" ]]; then
    echo "❌ ERROR: PLAN.md already exists at $PLAN_FILE"
    echo "To recreate: rm $PLAN_FILE"
    exit 1
fi
```

## Task Description

Given project requirements: `{ARGS}`

## FIRST: Detect Current Phase

**Before creating PLAN.md, determine project state:**

1. Check `.claude/specs/$BRANCH/proofs/` - any proofs exist?
2. Check `.claude/specs/$BRANCH/tasks/` - any tasks exist?
3. Determine appropriate action based on findings

## Core Philosophy

**This is critical - read carefully:**

1. **Test-Driven**: 100+ diverse test runs BEFORE writing documentation
2. **Parallel Execution**: ALL Phase 1 tasks must be 100% independent (zero dependencies)
3. **Contract-Based**: Phase 2 uses ONLY CONTRACT.md + TESTING.md (never internals)
4. **Proof-First**: Validate approaches in isolation before integration

## Create PLAN.md Structure

Write to `.claude/specs/$BRANCH/PLAN.md`:

```markdown
# Project: [Name]

## Overview
[What are we building? Why?]

## Components (Phase 1 - Parallel Proofs)

Each component must be:
- 100% independent (can run in parallel)
- Test-driven (100+ tests before docs)
- Contract-ready (produces CONTRACT.md + TESTING.md)

### Component List
1. [Component A] - [What needs to be proven?]
2. [Component B] - [What needs to be proven?]
3. [Component C] - [What needs to be proven?]

## Three-Phase Approach

### Phase 1: Research (Parallel)
- All tasks run simultaneously
- Each proves ONE component works in isolation
- Uses generic/sample test data (NOT real system data)
- Deliverables: CONTRACT.md, TESTING.md, 100+ test runs per component

### Phase 1.5: Feedback Loop
- Review all FEEDBACK.md files from proofs
- Update this PLAN.md based on discoveries
- Adjust Phase 2 if needed

### Phase 2: Integration (Sequential if needed)
- Connect proven components to actual system
- Use ONLY contracts from Phase 1 (black-box)
- Re-run Phase 1 test harness with REAL data
- May reveal contract gaps → create TASK-P1-X-REFINEMENT.md

## Testing Emphasis

**CRITICAL**: Testing is the PRIMARY deliverable, not documentation.

For each component:
- Design MINIMAL testing strategy first
- Implement test harness (run.sh)
- Run 100+ DIVERSE tests (edge cases for YOUR use case)
- Collect results (pass/fail logs, metrics)
- THEN write docs based on empirical evidence

## Success Criteria

Phase 1 complete when:
- [ ] All components have CONTRACT.md + TESTING.md
- [ ] All test harnesses achieve ≥98% pass rate over 100+ runs
- [ ] All FEEDBACK.md files reviewed

Phase 2 complete when:
- [ ] Integration with real system data works
- [ ] Phase 1 harness re-run passes with real data
- [ ] No regressions in existing functionality
```

## Key Principles

1. **NO implementation code in PLAN.md** - just high-level component breakdown
2. **Short and focused** - agent gets creative freedom in approach
3. **Clear success boundaries** - "done when X passes Y tests"
4. **Test strategy must be automatable** - no manual validation

## Next Steps

After PLAN.md is created:
- Run `/norm-research` to generate Phase 1 parallel proof tasks
- Complete all Phase 1 tasks independently
- Review feedback, update PLAN.md if needed
- Run `/norm-integrate` to generate Phase 2 integration tasks
