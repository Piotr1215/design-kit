# Design-Kit

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Python Version](https://img.shields.io/badge/python-3.11+-blue.svg)](https://www.python.org/downloads/)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)

> Test-driven, parallel-execution framework for building complex systems with confidence

**Stop sequential debugging. Start parallel validation.**

Design-Kit is a revolutionary workflow framework for Claude AI that transforms how you build complex systems. Instead of the traditional "build → test → debug" cycle, it introduces a **prove-then-integrate** approach where components are validated independently before integration.

## Why Design-Kit?

Traditional development is inherently sequential and slow:
```
Plan → Build → Test → Debug → Fix → Repeat (6-12 weeks)
```

Design-Kit enables parallel execution and reduces risk:
```
Plan → Prove (parallel) → Integrate with contracts (2-4 weeks)
```

### Key Benefits

- **3x Faster Development**: Independent proofs run in parallel, not sequentially
- **Zero Integration Surprises**: Validate approaches in isolation before integration
- **Contract-Based Design**: Black-box integration via `CONTRACT.md` reduces coupling
- **Test-First Mindset**: 100+ diverse tests BEFORE documentation
- **Automatic Context Switching**: One plan per git branch, automatic workspace management

## Quick Start

### Installation

```bash
git clone https://github.com/Piotr1215/design-kit.git
cd design-kit
./install.sh
```

### Your First Workflow

```bash
# Start a new feature branch
git checkout -b feature-auth-improvements

# Create master plan
/norm-plan "Improve API authentication with OAuth2 + rate limiting"

# Generate Phase 1 parallel proof tasks
/norm-research

# Claude executes all proofs independently
# Each produces CONTRACT.md + TESTING.md + 100+ test runs

# Review feedback and update plan if needed
cat .claude/specs/feature-auth-improvements/proofs/*/FEEDBACK.md

# Generate Phase 2 integration tasks
/norm-integrate

# Claude integrates proven components with real system
```

## How It Works

### The Three-Phase Flow

#### Phase 1: Research (Parallel)
All tasks run **simultaneously** with zero dependencies:
- Each proves ONE component works in isolation
- Uses generic/sample test data (NOT real system)
- Produces `CONTRACT.md` + `TESTING.md` + 100+ automated test runs
- **Done when**: All proofs have ≥98% pass rate

#### Phase 1.5: Feedback Loop
- Review all `FEEDBACK.md` files from proofs
- Update `PLAN.md` based on discoveries
- Adjust Phase 2 approach if needed

#### Phase 2: Integration
Connect proven components to actual system:
- References ONLY `CONTRACT.md` + `TESTING.md` (black-box)
- Re-runs Phase 1 test harness with REAL system data
- Creates REFINEMENT tasks if contract gaps found

### Workspace Structure

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
│   │   │   └── results/         # Test outputs
│   │   └── auth-api/
│   └── tasks/            # Task definitions
└── feature-xyz/
    ├── PLAN.md
    ├── proofs/
    └── tasks/
```

**Switch branch = switch plan.** Automatic symlinks via `.claude/current-plan.md`.

## Commands

| Command | Purpose | Output |
|---------|---------|--------|
| `/norm-plan` | Create master plan with component breakdown | `PLAN.md` with phases |
| `/norm-research` | Generate Phase 1 parallel proof tasks | Independent `TASK-P1-*.md` files |
| `/norm-integrate` | Generate Phase 2 integration tasks | Integration `TASK-P2-*.md` files |

## Core Principles

### 1. Testing is the Primary Deliverable
**NOT**: Write 1000 lines of testing philosophy → Run 3 tests → Done
**CORRECT**: Design minimal test strategy → Run 100+ diverse tests → Document from evidence

### 2. 100% Parallelism in Phase 1
All Phase 1 tasks must be executable simultaneously:
- ✅ Independent components with generic test data
- ✅ Zero cross-task dependencies
- ❌ NO integration with actual system (that's Phase 2)

### 3. Contract-Based Integration
Phase 2 integration uses ONLY:
- `CONTRACT.md` - Interface/API specification
- `TESTING.md` - Validation strategy
- NEVER internal implementation details

### 4. Automated Validation
Every Phase 1 proof must implement:
- `run.sh` exits 0 on success, 1 on failure
- `results/summary.json` with pass/fail metrics
- `results/logs/*.json` with individual test details

## Real-World Example

Building a REST API with OAuth2 + PDF generation:

**Traditional Approach (Sequential)**:
1. Week 1: Build OAuth2 implementation
2. Week 2: Build PDF generator
3. Week 3: Integrate both
4. Week 4: Debug integration issues
5. Week 5: Fix OAuth2 edge cases
6. Week 6: Fix PDF rendering bugs

**Design-Kit Approach (Parallel)**:
1. Day 1: Create plan with 2 components
2. Week 1: **Parallel execution**
   - Prove OAuth2 validation works (100+ tests with sample tokens)
   - Prove PDF generation works (100+ tests with sample HTML)
3. Week 2: Integrate both with real system using contracts
4. Done in 2 weeks vs 6 weeks

## Who Should Use Design-Kit?

**Perfect for**:
- Complex systems with multiple independent components
- Teams needing to explore uncertain technical approaches
- Projects requiring high quality and reliability
- Parallel development workflows

**Not ideal for**:
- Single-file changes or trivial updates
- Well-understood problems with clear solutions
- Quick prototypes or experiments
- Time-sensitive hotfixes

## Documentation

- **[Design-Driven Development Philosophy](design-driven.md)** - Deep dive into the methodology
- **[Installation Guide](install.sh)** - Detailed setup instructions
- **[Contributing Guide](CONTRIBUTING.md)** - How to contribute
- **[Changelog](CHANGELOG.md)** - Version history

## Comparison with Other Approaches

| Approach | Parallelism | Testing | Integration | Iteration Speed |
|----------|-------------|---------|-------------|-----------------|
| Traditional TDD | Sequential | After code | Ad-hoc | Slow |
| Behavior-Driven | Sequential | Scenarios first | Coupled | Medium |
| **Design-Kit** | **Parallel** | **100+ runs first** | **Contract-based** | **Fast** |

## Philosophy

Traditional development follows a linear path plagued by late-stage surprises.

Design-Kit inverts this: **Prove components work independently first**, THEN integrate.

**Key insight**: Validate approaches in isolation BEFORE integration. The feedback loop is faster, failures are isolated, and contracts reduce coupling.

## Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

### Quick Contribution Ideas
- Share your workflow examples in `examples/`
- Improve documentation and guides
- Add test harness templates
- Report bugs and suggest features

## Community & Support

- **Issues**: [GitHub Issues](https://github.com/Piotr1215/design-kit/issues)
- **Discussions**: Share your workflows and ask questions
- **PRs**: Contributions are always welcome!

## License

MIT License - see [LICENSE](LICENSE) file for details.

---

**Design-Kit**: Build complex systems with confidence through parallel validation.

*Powered by Claude AI*
