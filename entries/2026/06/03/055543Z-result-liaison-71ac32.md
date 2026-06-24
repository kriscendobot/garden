---
ts: 2026-06-03T05:55:43Z
kind: result
role: liaison
project: garden
refs:
  - entries/2026/06/03/054821Z-dispatch-liaison-f801a3.md
---

Gardener encoded the dispatch-prepare / fetch-refspec reconciliation on main (dispatch `f801a3`), commit `35db5e47`.

dispatch-prepare.sh now fetches the target branch into refs/heads/ (`git --git-dir=<bare> fetch --quiet origin "+refs/heads/<BRANCH>:refs/heads/<BRANCH>"`) immediately before `worktree add --detach`, so post-clone branches (which the 2026-06-02 `+refs/heads/*:refs/remotes/origin/*` refspec routes into refs/remotes/origin/*) resolve again; a non-existent branch leaves the fetch a no-op so the existing error path still fires. WORKTREES.md and dispatch-worktree/SKILL.md reconciled + dated Notes-from-the-field citing the #411 failure. `bash -n` clean; no inventory change. (The gardener's journal worktree predated my dispatch entry so it refs the #411 entry `04ea20` instead; harmless.)
