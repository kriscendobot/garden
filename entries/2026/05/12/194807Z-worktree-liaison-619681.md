---
ts: 2026-05-12T19:48:07Z
kind: worktree
role: liaison
worktree: worktrees/endojs-endo-but-for-bots/integrate--liaison--20260512-194515
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: "*"
refs: []
---

Cloned endojs/endo-but-for-bots (bare) at worktrees/endojs-endo-but-for-bots.git
and added a worktree on the `garden` branch at
`worktrees/endojs-endo-but-for-bots/integrate--liaison--20260512-194515/` for
integration work. HEAD at `cc79140a6`.

Discovery: the `garden` branch is a far more developed instance of the same
garden concept this scaffold is building. 26 roles, ~47 skills, a per-PR state
machine, a `steward` top-level orchestrator, watchmen for cadence/events/
schedule, and a `process/` directory for tracking state. Their `liaison` is
narrower than ours — it handles GitHub issues — and their `steward` is closer
to what we currently call `liaison`.

Notes from the field that should land in WORKTREES.md before the next worktree
gets created from a bare clone:

- `<worktree>/.git` is a *file* (worktree pointer), not a directory. The
  bootstrap recipe's `echo .garden/ >> .git/info/exclude` fails. Append to
  `<bare>/info/exclude` instead — affects every worktree created from that
  bare clone, which is what we want.

Integration not yet performed. Asking the user about scope and shape before
applying any changes to `main`.
