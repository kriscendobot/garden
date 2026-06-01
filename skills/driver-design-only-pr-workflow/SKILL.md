---
created: 2026-06-01
updated: 2026-06-01
author: builder
---

# Skill: driver-design-only-pr-workflow

The Phase-2 design-only PR workflow's states and transition predicates.
A design-only PR touches only paths under `<project>/designs/` (typically
`designs/<slug>.md` plus minor README updates); it has no source-touching
CI to wait on, no cleaner pass, and no fixer-loop. The state machine is
the strict subset of
[`skills/driver-state-machine/SKILL.md`](../driver-state-machine/SKILL.md)
that the design-only branch needs.

This is the simplest workflow shape and the natural Phase-2 target per
the design's migration plan.

## States

| State                | Meaning                                                                 |
| -------------------- | ----------------------------------------------------------------------- |
| `initial`            | A design document exists in the worktree; no PR yet.                    |
| `build`              | The PR is being opened in DRAFT (builder-equivalent run).               |
| `panel`              | DRAFT PR is open; the solicitor (design judge) is to run.               |
| `verdict`            | A `kriscendobot` review was posted; classify it.                        |
| `fixer-design`       | Verdict has `must-fix-loop` items; designer worker amends the design.   |
| `appellate`          | Terminating verdict; appellate considers promotions.                    |
| `un-draft`           | Run `gh pr ready <n>` deterministically.                                |
| `await-maintainer`   | PR is OPEN + not-DRAFT; wait for a maintainer review event.             |
| `changes-requested`  | Maintainer review carries `CHANGES_REQUESTED` or substantive `COMMENTED`. |
| `approved+green`     | Maintainer review `APPROVED` (no green CI requirement for design-only). |
| `merged`             | Terminal.                                                               |
| `closed`             | Terminal (PR closed without merging).                                   |
| `abandoned`          | Terminal.                                                               |

Differences from the PR-creation workflow:

- No `[design]` state. The maintainer (or a separately-dispatched
  designer) authored the design document before the driver runs; the
  driver picks up at `[initial]` with a design file already on disk.
- No `[clean]` state. Design-only PRs do not have source-touching changes
  to format-fix.
- No `[fixer]` / `[justice]` loop. The judge is the **solicitor**, not
  the barrister or justice; the solicitor's must-fix-loop dispatches a
  **designer** worker (not a fixer) and returns to `[panel]` after the
  push.
- `approved+green` ignores CI (design-only PRs run only the lightest CI,
  and that CI is not blocking).

## Transition predicates

The predicates re-use the procedure from
[`skills/driver-state-machine/SKILL.md`](../driver-state-machine/SKILL.md)
with these substitutions:

| Step                    | PR-creation flow                | Design-only flow              |
| ----------------------- | ------------------------------- | ----------------------------- |
| Builder dispatch verb   | `build`                         | `build-design-only`           |
| Cleaner                 | dispatched after build           | skipped                      |
| Panel judge             | `barrister` first, then `justice` | `solicitor`                |
| Must-fix-loop worker    | `fixer`                          | `designer`                  |
| CI green check          | required for `approved+green`    | bypassed                    |

## State file shape

Identical to the PR-creation workflow's state file, with
`workflow: design-only-pr` in the frontmatter.

## Happy path (the path the tests exercise)

```
initial → build → panel → verdict(approve) → un-draft → await-maintainer → approved+green → merged
```

The mock-garden tests in `tests/driver/test_design_only_happy_path.sh`
drive this path through, with stub `gh` returning the appropriate JSON
at each predicate evaluation and stub worker scripts that complete their
posted jobs by writing the expected result entries.

## Non-happy paths (not exercised in Phase 2 tests but documented for
later work)

- `verdict(must-fix-loop)` → `fixer-design` → (designer push) → `panel`:
  the loop terminates when the next `verdict` classifies as `approve`
  or `appeal-ok`.
- `await-maintainer` → `changes-requested` → (designer push) →
  `await-maintainer`: a maintainer's `CHANGES_REQUESTED` review re-opens
  the design-amend loop.
- `closed` from any state: the maintainer closed the PR without merging.
  The driver exits.

These paths follow the same predicate shape; they're left untested in
Phase 2 to keep the test surface focused. Phase 3 tests would extend
the harness with `must-fix-loop` and `changes-requested` cases.

## Pitfalls

- **A "design-only" PR with a stray source-file change.** The driver
  predicate checks `gh pr view --json files` and rejects the workflow
  classification when files outside `designs/` are touched. The
  rejection routes back to the PR-creation workflow (or escalates).
- **Solicitor verdict ambiguity.** The verdict classification escalates
  to the LLM the same way the PR-creation workflow does; this skill
  does not redefine the escalation path.
