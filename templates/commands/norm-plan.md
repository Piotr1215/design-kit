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

1. **Incremental Testing**: Start with happy path, add tests one-by-one, run ALL tests every time (catch regressions early)
2. **Test-Driven**: Sufficient diverse test runs to validate requirements BEFORE writing documentation
3. **Parallel Execution**: ALL Phase 1 tasks must be 100% independent (zero dependencies)
4. **Contract-Based**: Phase 2 uses ONLY CONTRACT.md + TESTING.md (never internals)
5. **Proof-First**: Validate approaches in isolation BEFORE integration
6. **Iterative Integration**: Integration may uncover issues → refine Phase 1 proof → re-integrate (this is NORMAL)
7. **Requirement-Driven Testing**: Test coverage based on what can go wrong, not arbitrary numbers

## Create PLAN.md Structure

Write to `.claude/specs/$BRANCH/PLAN.md`:

```markdown
# Project: [Name]

## Overview
[What are we building? Why?]

## Components (Phase 1 - Parallel Proofs)

Each component must be:
- 100% independent (can run in parallel)
- Test-driven (sufficient tests to validate requirements before docs)
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
- Deliverables: CONTRACT.md, TESTING.md, test runs sufficient to validate requirements

### Phase 1.5: Feedback Loop
- Review all FEEDBACK.md files from proofs
- Update this PLAN.md based on discoveries
- Adjust Phase 2 if needed

### Phase 2: Integration (Sequential if needed, ITERATIVE by nature)
- Connect proven components to actual system
- Use ONLY contracts from Phase 1 (black-box)
- Re-run Phase 1 test harness with REAL data
- **EXPECT iteration**: Integration often uncovers issues not found in isolation
- When issues found → create TASK-P1-X-REFINEMENT.md → refine proof → re-integrate
- **This back-and-forth is NORMAL and EXPECTED in real engineering**

## Testing Emphasis

**CRITICAL**: Testing is the PRIMARY deliverable, not documentation.

For each component:
- Design EFFECTIVE testing strategy first (what can go wrong in YOUR use case?)
- Implement test harness (run.sh)
- **Develop tests INCREMENTALLY:**
  - Start with ONE happy-path test
  - Add one test at a time (edge case, failure mode, invariant)
  - Run ALL tests after each addition (catch regressions immediately)
  - Build confidence iteratively until reliability requirements met
- Collect results (pass/fail logs, metrics)
- THEN write docs based on empirical evidence

**Focus on test design quality and incremental development over arbitrary test counts.**

**Real Engineering**: Research within guardrails → test iteratively → validate → integrate → iterate based on findings.

## Success Criteria

Phase 1 complete when:
- [ ] All components have CONTRACT.md + TESTING.md
- [ ] All test harnesses achieve acceptable pass rate (documented in TESTING.md with rationale)
- [ ] All FEEDBACK.md files reviewed

Phase 2 complete when:
- [ ] Integration with real system data works
- [ ] Phase 1 harness re-run passes with real data
- [ ] No regressions in existing functionality
```

## Key Principles

1. **NO implementation code in PLAN.md** - just high-level component breakdown
2. **Short and focused** - agent gets creative freedom in approach
3. **Clear success boundaries** - "done when reliability requirements are validated"
4. **Test strategy must be automatable** - no manual validation
5. **Requirement-driven testing** - test coverage based on what can fail, not arbitrary numbers

## Next Steps

After PLAN.md is created:
- Run `/norm-research` to generate Phase 1 parallel proof tasks
- Complete all Phase 1 tasks independently
- Review feedback, update PLAN.md if needed
- Run `/norm-integrate` to generate Phase 2 integration tasks
