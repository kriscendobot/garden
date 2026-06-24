---
ts: 2026-06-02T18:33:07Z
kind: result
role: liaison
project: garden
refs:
  - entries/2026/06/02/182816Z-dispatch-liaison-2f2807.md
---

Gardener encoded the stale-`origin/master` lesson on main (dispatch `2f2807`), commit `81fb2f56`; gardener result `45281846`.

Three files in one commit:
- `WORKTREES.md` § Adding a fork worktree: once-per-bare-clone `git config remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*'` step + rationale (root cause).
- `skills/dispatch-worktree/dispatch-prepare.sh`: extended the missing-bare-clone recovery hint with the refspec step (echo-only, no control-flow change; `bash -n` clean).
- `skills/pr-handoff/SKILL.md` § Preconditions: verify `rev-parse origin/master` vs `ls-remote` and force the refspec on disagreement, before recomputing; dated Notes-from-the-field line citing the #387 re-ferry.

No inventory change (no role/skill added/renamed/retired). Gardener's main push rebased cleanly over a concurrent `node-parity-test` add and a 2026-05-29 pr-handoff frontmatter bump; mirror-cross-link checklist content intact. Liaison synced its own main checkout forward to origin/main after the push.

Liaison follow-up 3 (bot-side #387 attribution regression) deliberately left unencoded: it is a fixer/retcon concern on the bot-side PR, not meta-evolution. Still open if the maintainer wants it addressed.
