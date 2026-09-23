---
tier: mentat
dispatch: manual
---
role: fixer
handler-timeout: 10800

# Carry endojs/endo-but-for-bots#1100 over the line (mentat fixer, then a fresh gauntlet)

PR: https://github.com/endojs/endo-but-for-bots/pull/1100, "feat(exo-stream)!: use one stream method for
byte streams" (DRAFT, +1407/-671 across 96 files, base pinned `llm-387ea66`, CI `unstable`, idle since 2026-09-17).
Maintainer directive (kriskowal, 2026-09-23 muster): *attempt to carry the gauntlet over the line*,
with the fixer pinned to a higher tier. That is why this is a manual **mentat** job.

## History
Gauntlet `ebfb-exo-stream-drop-base64-stream-methods-gauntlet-resume-at-fix-20260917` HALTED at
**fix round 6 of 6**: stage `…-fix-6` failed 3× with reaper `requeue-exhausted`, classification
**transient** (the 2026-09-17→19 fleet outage), not a code verdict. The parked stage job is
`jobs/plan/ebfb-exo-stream-drop-base64-stream-methods-gauntlet-resume-at-fix-20260917-fix-6.md`. Panel
history lives in `journal/panel-runs/endojs-endo-but-for-bots-1100/`, and the round-5 panel summary
message is in `inbox/maintainer/read/msg-ebfb-exo-stream-drop-base64-stream-methods-gauntlet-resume-at-fix-20260917-panel-5-*.md`.
A handler-budget overrun watchdog also fired on this PR; hence the larger handler-timeout.

## Procedure
1. **Supersession check FIRST.** Several exo-stream/blob PRs this month were overtaken by
   reimplementations on `origin/llm` (see the memory notes on #1089 and #1097). Compare #1100's intent
   (drop the base64 stream methods; one byte-stream method) with current `origin/llm`. If `llm`
   already contains the change or a replacement, STOP: do not rebase. Leave a courteous PR comment
   explaining the supersession, and report "close as superseded" with the deciding evidence (commits
   and files). Do not close the PR yourself.
2. Otherwise **re-pin and rebase:** snapshot a fresh `llm-<sha>` base
   (skills/frozen-base-branch, skills/verify-upstream-state-before-pinning), repoint the PR base,
   rebase the head, and resolve conflicts (skills/conflict-resolution).
3. **Do the stalled fix work yourself:** read the latest panel findings (round 5, plus whatever the
   fix-6 stage was addressing) and fix every must-fix finding, as review-feedback follow-up commits
   (skills/review-feedback-followup-commits). Run local verification (`scripts/jobs/gardening/local-verify.sh`,
   which now selects the package manager itself), and drive CI to green (skills/pr-ci-watch). Watch
   for the known ws-relay node-22/ubuntu flake: re-run it; don't treat it as a failure.
4. **Withdraw the dead fix-6 stage job** (`scripts/jobs/withdraw-plan.sh --by fixer <that base> "<reason>"`).
   Then **start a fresh gauntlet** for the review pass and un-draft:
   `scripts/jobs/post-gauntlet.sh --by fixer ebfb-exo-stream-pr1100-gauntlet-20260923 https://github.com/endojs/endo-but-for-bots/pull/1100`.
   Pass the PR's current `baseRefOid` to the panel, not a stale `origin/<baseRef>` (memory note on panel base-ref gotchas).
5. Report: supersession verdict, new base, commits pushed, findings fixed, CI state, and the gauntlet you posted.

Follow the garden's upstream etiquette for endojs/endo-but-for-bots (roles/COMMON.md). Complete the
job via the normal completion path when done.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-23T21:04:11Z
