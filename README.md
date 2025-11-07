# Design-Kit

Test-driven, parallel-execution framework for building complex systems.

One plan per branch. Automatic context switching.

## Philosophy

- **Test-Driven**: 100+ diverse tests BEFORE documentation
- **Parallel Execution**: Independent proofs run simultaneously
- **Contract-Based**: Black-box integration via CONTRACT.md
- **Proof-First**: Validate approaches in isolation before integration

## Install

```bash
cd /home/decoder/dev/design-kit
./install.sh  # Installs to ~/.claude/
```

## Usage

```bash
/norm-plan      # Create master plan with phases (WHAT & WHY)
/norm-research  # Generate Phase 1 parallel proof tasks (PROVE IT WORKS)
/norm-integrate # Generate Phase 2 integration tasks (CONNECT TO SYSTEM)
```

## How It Works

Each git branch gets its own workspace:

```
.claude/specs/
├── main/
│   ├── PLAN.md           # Master plan with phases
│   ├── proofs/           # Phase 1 proof-of-concepts
│   │   ├── pdf-gen/
│   │   │   ├── run.sh           # Automated test harness
│   │   │   ├── CONTRACT.md      # Integration interface
│   │   │   ├── TESTING.md       # Validation strategy
│   │   │   ├── FEEDBACK.md      # Discoveries
│   │   │   └── results/         # Test outputs (100+ runs)
│   │   │       ├── summary.json
│   │   │       └── logs/
│   │   └── auth-api/
│   └── tasks/            # Task definitions
│       ├── TASK-P1-A-pdf-gen.md
│       └── TASK-P2-C-integration.md
└── feature-xyz/
    ├── PLAN.md
    ├── proofs/
    └── tasks/
```

Switch branch = switch plan. Automatic symlinks via `.claude/current-plan.md`.

## The Three-Phase Flow

### Phase 1: Research (Parallel)

Generate independent proof-of-concept tasks:

```bash
/norm-research
```

- All tasks run in parallel (zero dependencies)
- Each proves ONE component works in isolation
- Uses generic/sample test data (NOT real system)
- Produces: CONTRACT.md + TESTING.md + 100+ test runs

**Done when**: All proofs have ≥98% pass rate over 100+ diverse tests.

### Phase 1.5: Feedback Loop

Review discoveries:
- Read all `FEEDBACK.md` files
- Update `PLAN.md` based on learnings
- Adjust Phase 2 approach if needed

### Phase 2: Integration

Connect proven components to actual system:

```bash
/norm-integrate
```

- References ONLY CONTRACT.md + TESTING.md (black-box)
- Re-runs Phase 1 test harness with REAL system data
- May be sequential if tasks modify same files
- If contract gaps found → create REFINEMENT tasks, go back to Phase 1

## Key Principles

### 1. Testing is the Primary Deliverable

**NOT**: Write 1000 lines of testing philosophy → Run 3 tests → Done

**CORRECT**: Design minimal test strategy → Implement harness → Run 100+ diverse tests → Collect data → Write docs from evidence

### 2. 100% Parallelism (Phase 1)

All Phase 1 tasks must be executable simultaneously:
- ✅ Independent components
- ✅ Generic test data
- ✅ Zero cross-task dependencies
- ❌ NO integration with actual system (that's Phase 2)

### 3. Contract-Based Integration

Phase 2 integration uses ONLY:
- `CONTRACT.md` - Interface/API specification
- `TESTING.md` - Validation strategy
- NEVER internal implementation details

### 4. Test Harness Contract

Every Phase 1 proof must implement:
- `run.sh` exits 0 on success, 1 on failure
- `results/summary.json` with pass/fail metrics
- `results/logs/*.json` with individual test details

## Commands Read Context

- PLAN.md (component breakdown)
- CLAUDE.md (repo conventions)
- Existing code patterns
- Phase 1 contracts (for integration)

## Cleanup

```bash
# Remove old branch workspace
rm -rf .claude/specs/old-branch

# Remove old Phase 1 proof
rm -rf .claude/specs/current-branch/proofs/component-name

# Remove old Phase 2 task
rm .claude/specs/current-branch/tasks/TASK-P2-*.md
```

## Example Workflow

```bash
# Start new feature
git checkout -b feature-auth-improvements

# Create master plan
/norm-plan "Improve API authentication with OAuth2 + rate limiting"

# Generate Phase 1 parallel proof tasks
/norm-research

# Agent executes Phase 1 tasks independently
# Each produces CONTRACT.md + TESTING.md + 100+ test runs

# Review feedback, update plan if needed
cat .claude/specs/feature-auth-improvements/proofs/*/FEEDBACK.md

# Generate Phase 2 integration tasks
/norm-integrate

# Agent executes Phase 2 integration
# Re-runs Phase 1 harness with real system data
```

## Anti-Patterns

- ❌ Creating Phase 1 dependencies (breaks parallelism)
- ❌ Writing 1000-line docs before running tests
- ❌ Using real system data in Phase 1 (use generic/sample data)
- ❌ Phase 2 referencing proof internals (use CONTRACT.md only)
- ❌ Skipping Phase 1 harness re-run in Phase 2
- ❌ Manual validation (must be automated)

## Files

```
design-kit/
├── templates/commands/        # The 3 commands
│   ├── norm-plan.md
│   ├── norm-research.md
│   └── norm-integrate.md
├── scripts/
│   └── auto-connect-design.sh # Creates branch directory + symlinks
└── install.sh                 # Installs to ~/.claude/
```

## Philosophy: Why This Approach?

Traditional development: Plan → Build → Test → Integrate → Debug → Repeat

Design-Kit approach: **Prove components work independently first**, THEN integrate.

Benefits:
- Parallel execution saves time
- Test failures isolated to specific components
- Contract-based integration reduces coupling
- Feedback loop prevents late-stage surprises
- Empirical evidence drives documentation

## License

MIT
