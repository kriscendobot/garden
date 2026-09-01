---
withdrawn: true
withdrawn_reason: orphaned gauntlet STAGE fragment: its parent gauntlet already halted, so promoting a lone stage cannot advance anything — the remedy for the underlying PR is a fresh gauntlet, not this stage (2026-09-01 muster, maintainer-authorized)
withdrawn_by: producer
withdrawn_at: 2026-09-01T20:08:42Z
withdrawn_from_gate: go-ahead
---

---
gate: go-ahead
priority: normal
role: gardener
handler-budget-role: shepherd
handler-timeout: 7200
token-budget: 250000
doomed: true
doom_signature: requeue-exhausted
doom_count: 1
requeue_cycles: 5
deadline_overruns: 0
elapsed_constancy_confirmations: 0
doomed_at: 2026-08-27T12:53:06Z
doomed_on: endolin-garden-ece02cb4
posted_by: reaper:endolin-garden-ece02cb4
posted_at: 2026-08-27T12:53:06Z
---

---
role: gardener
handler-budget-role: shepherd
handler-timeout: 7200
gauntlet: endor-host-hook-surface-20260827-gauntlet
gauntlet_stage: clean
gauntlet_iteration: 0
pr: https://github.com/endojs/endo-but-for-bots/pull/282
---

# Gauntlet stage: CLEAN — endojs/endo-but-for-bots PR #282

You are ONE stage of a staged gauntlet (endor-host-hook-surface-20260827-gauntlet). Do ONLY the clean stage, then STOP.

Garden script names below are repo-relative. Resolve them against THIS claiming
worker's `$GARDEN_ROOT` (known by `scripts/jobs/common.sh`), never against the
posting host's garden root.

1. Idempotence first. `gh pr view https://github.com/endojs/endo-but-for-bots/pull/282 --json isDraft,state,statusCheckRollup`. If the
   PR is already the right shape (coverage already pushed, CI GREEN at the current
   head), this stage is a NO-OP: skip to the marker with clean=done.
2. Get an ISOLATED project checkout of the PR head:
   `scripts/jobs/ensure-project-worktree.sh endor-host-hook-surface-20260827-gauntlet-clean <pr-head-owner>/<repo-name> <pr-head-branch>`.
   Resolve the head owner and branch with `gh pr view https://github.com/endojs/endo-but-for-bots/pull/282 --json headRepositoryOwner,headRefName`;
   do not pass the base repo when the PR head belongs to a fork.
3. In that checkout: run the coverage pass on the touched packages
   (skills/coverage-driven-testing) and remove any dead code the change orphaned.
4. If you changed anything, push follow-ups to the PR head with
   `scripts/jobs/gardening/safe-push-pr-head.sh`.
5. Watch CI to a terminal state, BOUNDED so this handler is never killed mid-wait:
   `GARDEN_CI_DEADLINE_SECS=3600 \
     scripts/jobs/gardening/ci-wait-merge.sh endojs/endo-but-for-bots 282 --no-merge`
   - rc 0 (GREEN): success.
   - rc 4 (still PENDING at the deadline): CI is not terminal — report still-pending
     so the driver re-posts this stage on a fresh budget (do NOT emit clean=done).
   - rc 3 (RED): this stage FAILS. Begin your report with a line
     `orchestration-failed: true` and describe the failing checks; do NOT emit any
     clean=done marker (the driver halts the gauntlet and surfaces it).

END your completion report with EXACTLY ONE of these marker lines (last line):
  <!-- gauntlet-stage-result: clean=done -->            (coverage clean, CI green)
  <!-- gauntlet-stage-result: clean=still-pending -->   (CI still pending at deadline)
