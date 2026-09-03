from_host: endolin-garden2-5bcdff64
from: reaper:endolin-garden2-5bcdff64
sent_at: 2026-09-02T18:55:39Z
doom_base: kriscendobot-minion.town-pr78-gauntlet-clean
doom_signature: elapsed-constancy
notice_count: 1
first_seen: 2026-09-02T18:55:39Z
last_seen: 2026-09-02T18:55:39Z
---
DOOM job PARKED in jobs/plan/ (held, gate=go-ahead) after 2 elapsed-constancy confirmations on endolin-garden2-5bcdff64.
The handler repeatedly failed at a near-constant elapsed below its wall-clock budget.
The first confirmation was requeued; the reaper parked only after the 2-confirmation threshold.
Read the handler log for the fast failure cause. Raising the handler budget will not help.
The work is preserved at jobs/plan/kriscendobot-minion.town-pr78-gauntlet-clean; it stays HELD until a human promotes it
(promote-plan.sh kriscendobot-minion.town-pr78-gauntlet-clean) or removes it.
Original job base: kriscendobot-minion.town-pr78-gauntlet-clean

--- original job body ---
---
role: gardener
handler-budget-role: shepherd
handler-timeout: 7200
gauntlet: kriscendobot-minion.town-pr78-gauntlet
gauntlet_stage: clean
gauntlet_iteration: 0
pr: https://github.com/kriscendobot/minion.town/pull/78
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Gauntlet stage: CLEAN — kriscendobot/minion.town PR #78

You are ONE stage of a staged gauntlet (kriscendobot-minion.town-pr78-gauntlet). Do ONLY the clean stage, then STOP.

Garden script names below are repo-relative. Resolve them against THIS claiming
worker's `$GARDEN_ROOT` (known by `scripts/jobs/common.sh`), never against the
posting host's garden root.

1. Idempotence first. `gh pr view https://github.com/kriscendobot/minion.town/pull/78 --json isDraft,state,statusCheckRollup`. If the
   PR is already the right shape (coverage already pushed, CI GREEN at the current
   head), this stage is a NO-OP: skip to the marker with clean=done.
2. Get an ISOLATED project checkout of the PR head:
   `scripts/jobs/ensure-project-worktree.sh kriscendobot-minion.town-pr78-gauntlet-clean <pr-head-owner>/<repo-name> <pr-head-branch>`.
   Resolve the head owner and branch with `gh pr view https://github.com/kriscendobot/minion.town/pull/78 --json headRepositoryOwner,headRefName`;
   do not pass the base repo when the PR head belongs to a fork.
3. In that checkout: run the coverage pass on the touched packages
   (skills/coverage-driven-testing) and remove any dead code the change orphaned.
4. If you changed anything, push follow-ups to the PR head with
   `scripts/jobs/gardening/safe-push-pr-head.sh`.
5. Watch CI to a terminal state, BOUNDED so this handler is never killed mid-wait:
   `GARDEN_CI_DEADLINE_SECS=3600 \
     scripts/jobs/gardening/ci-wait-merge.sh kriscendobot/minion.town 78 --no-merge`
   - rc 0 (GREEN): success.
   - rc 4 (still PENDING at the deadline): CI is not terminal — report still-pending
     so the driver re-posts this stage on a fresh budget (do NOT emit clean=done).
   - rc 3 (RED): this stage FAILS. Begin your report with a line
     `orchestration-failed: true` and describe the failing checks; do NOT emit any
     clean=done marker (the driver halts the gauntlet and surfaces it).

END your completion report with EXACTLY ONE of these marker lines (last line):
  <!-- gauntlet-stage-result: clean=done -->            (coverage clean, CI green)
  <!-- gauntlet-stage-result: clean=still-pending -->   (CI still pending at deadline)
