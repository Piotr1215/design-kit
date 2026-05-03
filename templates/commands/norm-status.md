---
name: norm-status
description: "Show project state and the next recommended command (read-only, project, gitignored)"
---

Read-only state-machine entry point for design-kit. The user shouldn't have to remember the sequence — this command inspects the current project, prints where it stands, and recommends the next command to run.

## Setup

```bash
# Resolve global spec dir via the per-repo pointer (does not error if unbound — we report the unbound state too)
output=$(~/.claude/design-kit/auto-connect-design.sh)
SPEC_DIR=$(echo "$output" | awk '/^SpecDir:/ {print $2}')
SLUG=$(echo "$output" | awk '/^Slug:/ {print $2}')
```

## State Detection

Inspect the project on disk. **Do not write or mutate anything.** Determine which state the project is in:

| State | Detected by | Next command |
|-------|-------------|--------------|
| **unbound** | No `<repo>/.claude/current-project` pointer | `/norm-plan "<idea>"` |
| **bound, no plan** | Pointer exists, no `$SPEC_DIR/PLAN.md` | `/norm-plan` |
| **plan, no tasks** | `PLAN.md` exists, `$SPEC_DIR/tasks/` empty | `/norm-research` |
| **tasks, no proofs** | TASK-P1-* files exist, `$SPEC_DIR/proofs/` empty or no CONTRACT.md | execute Phase 1 (run agents on `TASK-P1-*` files) |
| **phase 1 in flight** | Some proofs have CONTRACT.md, some don't | finish remaining Phase 1 proofs |
| **phase 1 done, replan needed** | All proofs have CONTRACT.md+TESTING.md, no `.phase-1.5-complete` marker | `/norm-replan` |
| **phase 1.5 stale** | Marker exists but a `FEEDBACK.md`, `PLAN.md`, or `SCHEMA.md` is newer | `/norm-replan` (re-synthesize) |
| **phase 1.5 done, no P2 tasks** | Marker fresh, no `TASK-P2-*` files | `/norm-integrate` |
| **phase 2 in flight** | TASK-P2-* files exist | execute Phase 2 |
| **phase 2 done** | All P2 tasks have integration evidence (subjective — surface counts, let user decide) | wrap up / new project |

## Output Format

Print one block. Keep it scannable — this is the user's "where am I?" command.

```
Project: <slug> (or "no project bound")
Spec dir: <SPEC_DIR>
Linear:   <yes — link / no>

State: <state name>
  - PLAN.md:       <yes/no> [mtime: <ISO>]
  - SCHEMA.md:     <yes/no/n.a.>
  - Tasks:         <P1: N done / M total> | <P2: N done / M total>
  - Proofs:        <component: ✓ ✓ ✓ — CONTRACT TESTING FEEDBACK> per row
  - Phase 1.5:     <not run | done <ISO> | STALE — newer files: ...>

Next: <one-line recommended command, with example args>

Why: <one sentence rationale based on what's missing>
```

For per-proof rows, use the symbols:
- `✓` = file present
- `·` = file missing
- check `CONTRACT.md` `TESTING.md` `FEEDBACK.md` in that order

## Implementation Notes

- Pure inspection: only `ls`, `find`, `stat`, `cat`. No edits, no Linear writes.
- Counts:
  - P1 done = proofs with both `CONTRACT.md` and `TESTING.md`
  - P1 total = TASK-P1-*.md count under `$SPEC_DIR/tasks/`
  - P2 done = TASK-P2-* files with associated PR/branch markers (best-effort; surface counts only)
- Stale detection mirrors `/norm-integrate`'s gate: marker missing, or any `FEEDBACK.md` / `PLAN.md` newer than the marker
- If unbound, skip every project-specific row and just print the unbound block + suggestion

## Verification

After running:
- ✅ Nothing on disk changed
- ✅ User can read the recommended next command and run it as-is
- ✅ Stale Phase 1.5 is surfaced even when the marker exists

## Anti-Patterns

❌ Running the recommended command automatically — this is a guidance command, not an executor
❌ Editing files (this includes "fixing" a stale marker — that's `/norm-replan`'s job)
❌ Hiding partial state behind a single status word — list the per-proof rows so the user sees what's actually missing
