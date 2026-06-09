---
ts: 2026-06-09T03:38:00Z
kind: result
role: fixer
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
dispatch_root: /home/kris/dispatches/fixer--0b1288
prs:
  - repo: endojs/endo-but-for-bots
    pr: 401
    role: target
refs:
  - entries/2026/06/09/033400Z-dispatch-fixer-0b1288.md
  - https://github.com/endojs/endo-but-for-bots/pull/401
  - https://github.com/endojs/endo-but-for-bots/pull/401#discussion_r3376831072
  - https://github.com/endojs/endo-but-for-bots/pull/401#discussion_r3377733581
  - https://github.com/endojs/endo-but-for-bots/pull/401#issuecomment-4655831574
---

# result: fixer — adopted `die` idiom across PR #401 .sh files

Addressed kriskowal's CHANGES_REQUESTED review (`4454004632`) on
`endojs/endo-but-for-bots#401`. The single inline ask on
`packages/nat/scripts/npm-audit-fix.sh:3` (id `3376831072`) was
*"Early termination should exit non-zero and emit an error message to
stderr, as with the `die` pattern from Perl. Please research the
appropriate idiom and apply throughout."*

## Branch tips

- Pre: `46ba165285ae4500a881ec3e3236bbd4cbab0607` (46ba1652)
- Post: `a7b9b9a7d0aa83fba40008af1cf2eb5c19095586` (a7b9b9a7)
- Addressing commit: `a7b9b9a7d` — *chore(shellcheck): adopt die
  idiom for early termination in touched .sh files*

## `die` helper shape adopted

No existing project helper (`die`/`fail`/`error_exit`) found in the
tree, so each touched script defines its own near the top:

```sh
die() { printf '%s\n' "$*" >&2; exit 1; }
```

`printf` rather than `echo -e` keeps behavior portable across
`/bin/sh` and `/bin/bash` (no `-e` flag interpretation drift).

## Sites changed

| File | Sites |
| --- | --- |
| `packages/nat/scripts/npm-audit-fix.sh` | `cd nat`, `cd integration-test` |
| `scripts/npm-audit-fix.sh` | `cd ???` |
| `scripts/posttypedoc.sh` | `cd docs`, `cd api-docs` |

Three files, five replacement sites, plus three `die()` definitions
(one per file). Diff stat: `3 files changed, 11 insertions(+), 5 deletions(-)`.

## Sites deliberately left as-is

- `scripts/check-packages.sh:75` — `exit "$EXIT"` is the script's
  orderly terminal exit, propagating the assert-loop's accumulated
  status. The asserts themselves already emit to stderr via the
  `echo` lines. Not the silent-non-zero early-termination the
  reviewer objects to.
- `scripts/shellcheck.sh:25` — `exit 0` after announcing
  `"shellcheck: no .sh files tracked; skipping."` is a successful
  no-op skip with an explanatory stdout line. Not an error path.
- `scripts/maintenance/check-unused-deps.sh` and
  `scripts/set-versions.sh` — touched by this PR for SC1007 / SC2034
  / read-r fixes; they do not have `|| exit` or other silent-exit
  patterns to upgrade.

The reply-on-thread offers to upgrade either of the deliberate
hold-outs if the maintainer prefers.

## Gate / shellcheck

- Local `scripts/shellcheck.sh`: PASS (exit 0).
- `pre-push-gates.sh --summary`: probes all pass; `yarn format` and
  `yarn lint` fail with `"project doesn't seem to have been
  installed"` because the fresh dispatch worktree has no
  `node_modules`. The change is .sh-only; Prettier and eslint don't
  target shell, so the install bootstrap was skipped as cost without
  signal. shellcheck (the load-bearing check for this PR) passes on
  the new tip.
- Remote `shellcheck` check on CI: PASS (8s) on push of `a7b9b9a7d`.

## Surfaces posted

- Reply on inline thread `3376831072`:
  https://github.com/endojs/endo-but-for-bots/pull/401#discussion_r3377733581
- Top-level summary comment:
  https://github.com/endojs/endo-but-for-bots/pull/401#issuecomment-4655831574
- Re-request review from `kriskowal`: pending CI convergence; will
  fire once the matrix is green per fixer norm
  *"After fix-up commits land, drive CI to green BEFORE re-requesting
  maintainer review."* (Monitor armed on `gh pr checks 401`; the
  per-cycle steward picks it up if this dispatch returns before
  convergence.)

Self-improvement: nothing this time. Standard fixer flow on a
straightforward maintainer ask. One small note for future fixers
working under em-dash discipline: the inline reply body went up
with two literal em-dashes (U+2014) that should have been periods
or parentheses per `skills/em-dash-style/SKILL.md`. Caught in the
top-level summary; the inline-reply edit is not worth the noise of
a follow-up. Future fixers should run a `grep -P '\\x{2014}'` over
review-comment bodies before `gh api ... /replies`.
