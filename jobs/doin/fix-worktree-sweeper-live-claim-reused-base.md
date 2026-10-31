---
posted_at: 2026-10-31T14:50:16Z
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Fix `scripts/jobs/worktree-sweeper.sh` (garden repo, main2): it destroys a LIVE claim's
worktrees when the job base also has an older completed record in `jobs/tada/`.

Observed 2026-10-31 on oros-studio-garden-ce242c49, job `build-daemon-rename-to-manager`
(claimed 13:00Z, in `jobs/doin/`). A July job with the same base left
`jobs/tada/2026/07/02/build-daemon-rename-to-manager.md`, which names only MERGED PRs
(endojs/endo-but-for-bots#598). `sweep_terminal_base` matched that tada record and
removed the live run's `scratch/gardener-wt-build-daemon-rename-to-manager` (13:13:41)
and its `scratch/project-wt-build-d-336bc1c0876b-*` project checkout three times
(13:17, ~13:44, 13:46). The last removal happened even though a live process had its
cwd inside the checkout: `has_live_process` was evaluated before a `git worktree remove`
that blocked behind the repo lock for minutes, and `scratch_cleanup` then deleted the tree.

Fix so that:
1. `sweep_terminal_base` skips any base that currently has a live claim (`jobs/doin/<base>.md`),
   or a queued `todo/`/`plan/` record, before touching anything; a tada record for a reused
   base is not proof the current attempt is terminal.
2. Liveness is re-checked right before the destructive step, after any lock wait.
Add a regression test in scripts/jobs/test/ (a tada record plus a doin record for the same
base: the sweeper must keep the worktrees).

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-10-31T15:22:30Z
