---
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
# Go live with the issue status pass (third observation window)

Role: builder. Garden repo, direct to main2. Successor of
`issue-status-pass-go-live-20261116`, which checked the leader on 2026-11-16 at
06:06 UTC and found its recorded deployed SHA was still
`c2a2b3c899aa9770491212d2a60107f64404f38d` (marker mtime
2026-11-12T21:15:39Z), so fix `66ab9cc2018` was not yet deployed. The host's
upgrade-ready record named `c4766a84510b81a84541434d3ffba17b10e8d4ce`, 10
commits ahead, at 2026-11-16T06:02:01Z.

1. Confirm the leader's deployed root contains `66ab9cc2018`
   (`git -C <worktree> merge-base --is-ancestor 66ab9cc2018 <deployed HEAD>`;
   find the deployed HEAD without running git in the garden root, using
   `$GARDEN_ROOT/.garden-state/deploy/deployed-sha`). Only logs AFTER that deploy
   count; if it has been under a day, re-defer with `set-schedule-once.sh`.
2. Compare `journalctl --user -u garden-issue-status` "DRY RUN would post" lines
   (post-deploy, at least a day) against the `kriscendobot/garden` issue threads.
   Every would-post must be a maintainer arrival (issue, or comment whose first
   line begins `@kriscendobot `) with no bot comment for 20+ min (5+ under a deep
   queue). Nothing answered in time may appear.
3. If they match: delete `Environment=GARDEN_ISSUE_STATUS_DRY_RUN=1` from
   `scripts/systemd/garden-issue-status.service`, flip the script default
   (`: "${GARDEN_ISSUE_STATUS_DRY_RUN:=0}"`), update the unit/script/design/
   context/operations/systemd-units.md wording, run
   `scripts/jobs/test/issue-status-pass-test.sh`, commit, and push. If not, fix
   and restart the observation window.

Trigger: https://github.com/kriscendobot/garden/issues/128

<!-- garden-transient-elapsed: kind=exit0 through=0 values=370 -->

<!-- garden-reaped: 1 -->
<!-- garden-plain-retry-not-before: 2026-11-17T08:03:25Z -->

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-11-17T08:27:58Z
