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

### Task Template (Keep concise and focused)

```markdown
# TASK-P1-[X]-[Component]

## Goal
Prove [component X] works reliably in isolation with automated validation.

## PRIMARY OBJECTIVE: Design EFFECTIVE Testing Strategy

**BEFORE implementing, design tests that will actually stress YOUR system:**

**1. Understand What Can Go Wrong:**
- What invariants MUST hold true? (e.g., auth token never leaks, data never corrupts)
- What are failure modes specific to THIS component? (timeouts, race conditions, memory leaks)
- What edge cases are unique to YOUR use case? (not generic happy-path scenarios)

**2. Design Tests That Reveal Problems:**
- How will we detect violations of invariants? (automated assertions, monitoring)
- What conditions expose failure modes? (concurrent requests, slow networks, large data)
- Pick ONE validation tool/library that can verify these conditions

**3. Determine "Done" Criteria:**
- What pass rate indicates reliability for YOUR requirements? (critical system = higher bar)
- How many test runs validate consistency? (based on how random/timing-sensitive the component is)
- Document your rationale in TESTING.md (not arbitrary numbers)

**CRITICAL**: A great testing approach is more valuable than running arbitrary test counts.
**If you cannot design meaningful tests that stress the system, STOP and report to user immediately.**

## What to Explore

- Try at least 2 approaches: Library A vs Library B, or Technique X vs Y
- Test with: [describe generic test data]
- Compare tradeoffs: size, performance, complexity, testability

## Research Starting Points

- [Library/tool name 1]
- [Library/tool name 2]
- [Testing framework for validation]

## CRITICAL: Check Memory for Proven Test Harness Patterns

**BEFORE setting up a new test harness, check if Memory MCP has proven patterns:**

```bash
# Search memory for test harness guides
# Examples: "playwright setup", "jest harness", "pytest setup", "cypress setup"
```

**If Memory MCP available:**
1. Search for: `[tech-stack] quick setup guide` or `[tech-stack] test harness`
2. Example queries: "Playwright quick setup", "Jest configuration", "Pytest harness", "Cypress setup"
3. Follow proven steps from memory to avoid common pitfalls
4. Memory contains step-by-step guides like `Playwright_Quick_Setup_Guide`

**If you create a NOVEL test harness (not in memory):**

**YOU MUST add your setup steps to memory using Memory MCP:**

Create memory entity with pattern: `[Tech]_Quick_Setup_Guide`

**Required format:**
- Entity name: `[Technology]_Quick_Setup_Guide` (e.g., `Playwright_Quick_Setup_Guide`, `Jest_Quick_Setup_Guide`)
- Entity type: `development_guide`
- Observations: Step-by-step setup instructions (GENERIC, not project-specific)

**Example observation format:**
```
Quick setup guide for [Technology] test harness - follow these steps in order
1. Create directories: mkdir -p [structure]
2. Install dependencies: [exact commands]
3. Create config file: [filename with essential config]
4. Create first test: [minimal working example]
5. Run single test first: [command with --debug/--headed flag]
6. Run all tests: [command] (only after single test works!)
7. View results: [how to check output]
8. Docs: [official docs URL]
Key config options: [explain critical settings]
CRITICAL: [key gotcha or debugging tip]
Network/debug commands: [if applicable]
```

**What makes a GOOD memory entry:**
- ✅ GENERIC steps that work across projects
- ✅ Exact commands (copy-paste ready)
- ✅ Minimal working example
- ✅ Debug/verify steps ("run ONE test first with --headed")
- ✅ Common gotchas and fixes
- ✅ Links to official docs
- ❌ NOT project-specific paths/config
- ❌ NOT implementation details
- ❌ NOT full test suite code

**Why this matters:**
- Saves hours for future agents setting up same tech stack
- Captures proven approaches (not trial-and-error)
- Builds collective knowledge base
- Enables rapid test harness setup across projects

**After adding to memory:**
- Verify with memory search to ensure it's discoverable
- Use clear, searchable entity names
- Include technology name in observations for search matching

## Deliverable

Working proof in `.claude/specs/$BRANCH/proofs/[component-name]/` with:

**CRITICAL: Incremental Test Development (NOT batch testing):**

1. **Start Simple - Happy Path First:**
   - [ ] Set up test harness (run.sh exits 0/1, generates results/summary.json, results/logs/*.json)
   - [ ] Write ONE basic happy-path test
   - [ ] Make it pass
   - [ ] Verify test harness works end-to-end

2. **Build Iteratively - Add One Test at a Time:**
   - [ ] Identify next most important scenario (edge case, failure mode, invariant check)
   - [ ] Write ONE new test
   - [ ] Run ALL tests (catch regressions immediately)
   - [ ] Make new test pass
   - [ ] REPEAT until confidence achieved

3. **Research Multiple Approaches:**
   - [ ] Test at least 2 different approaches/libraries using same iterative method
   - [ ] Compare tradeoffs based on empirical test results
   - [ ] Pick ONE winner with documented rationale

4. **Validate Reliability:**
   - [ ] Run full test suite multiple times to validate consistency
   - [ ] Document acceptable pass rate in TESTING.md (based on requirements, not arbitrary)
   - [ ] Achieve target reliability for YOUR use case

5. **THEN Document from Empirical Evidence:**
   - [ ] TESTING.md (how to run, what's validated, pass criteria from test data)
   - [ ] CONTRACT.md (API/interface + gotchas discovered during testing)
   - [ ] FEEDBACK.md (design choices + surprises learned from test results)
   - [ ] README.md (quick start, dependencies)

**Anti-Pattern**: Writing 100+ tests then running them all at once (no regression detection)
**Correct**: Write 1 test → run ALL tests → repeat (catch regressions early)

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
2. Keep each task concise and focused (as brief as needed to convey requirements)
3. Emphasize testing strategy upfront
4. Ensure 100% parallelism (no cross-task dependencies)
5. Focus on WHAT to prove, not HOW to code it

## Anti-Patterns to Avoid

❌ Creating dependencies between tasks
❌ Including implementation code in task files
❌ Making tasks unnecessarily verbose
❌ Allowing manual validation (must be automated)
❌ Forgetting the Test Harness Contract (summary.json + logs/)
❌ Specifying arbitrary test counts ("100+ tests") - let requirements drive coverage

## Verification

After generating tasks, ask yourself:
- ✅ Can all tasks start simultaneously?
- ✅ Does each task use generic test data?
- ✅ Is testing strategy clearly defined?
- ✅ Are tasks concise and focused?
- ✅ Are test coverage targets based on requirements, not arbitrary numbers?

## Next Steps

After tasks are generated:
- Agent(s) execute Phase 1 tasks independently
- Each produces CONTRACT.md + TESTING.md + sufficient test runs to validate requirements
- Review all FEEDBACK.md files
- Update PLAN.md if discoveries warrant changes
- Then run `/norm-integrate` for Phase 2
