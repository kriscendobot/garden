once: 2026-11-18T07:50:00Z
job_basename_prefix: issue-status-pass-go-live-20261118
---
---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Go live with the issue status pass (fourth observation window)

Role: builder. Garden repo, direct to main2. Successor of `issue-status-pass-go-live-20261117`, which checked the leader on 2026-11-17 at 07:40 UTC and found its recorded deployed SHA was still `c2a2b3c899aa9770491212d2a60107f64404f38d` (marker mtime 2026-11-12T21:15:39Z), so fix `66ab9cc2018` was not yet deployed. The host upgrade-ready record named `0dda301cbeb484d69447f7c60214788924464f8c`, 13 commits ahead, at 2026-11-17T07:37:02Z.

1. Confirm the leader deployed root contains `66ab9cc2018` by reading `$GARDEN_ROOT/.garden-state/deploy/deployed-sha` and running `git merge-base --is-ancestor 66ab9cc2018 <deployed SHA>` only in the per-job worktree. Only logs after that deploy count. If the deployment has been live for less than a day, re-defer with `set-schedule-once.sh`.
2. Compare post-deploy (at least one day) `journalctl --user -u garden-issue-status` `DRY RUN would post` lines against `kriscendobot/garden` issue threads. Every would-post must be a maintainer arrival (issue, or comment whose first line begins `@kriscendobot `) with no bot comment for 20+ minutes (5+ under a deep queue). Nothing answered in time may appear.
3. If they match, remove `Environment=GARDEN_ISSUE_STATUS_DRY_RUN=1` from `scripts/systemd/garden-issue-status.service`, change the script default to `: "${GARDEN_ISSUE_STATUS_DRY_RUN:=0}"`, update unit/script/design/context/operations/systemd-units.md wording, run `scripts/jobs/test/issue-status-pass-test.sh`, commit, and push. If they do not match, fix and restart the observation window.

Trigger: https://github.com/kriscendobot/garden/issues/128
