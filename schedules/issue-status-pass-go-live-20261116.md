once: 2026-11-16T06:00:00Z
job_basename_prefix: issue-status-pass-go-live-20261116
---
---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Go live with the issue status pass (second observation window)

Role: builder. Garden repo, direct to main2. Successor of `issue-status-pass-go-live`
(2026-11-14), which found a false would-post on kriscendobot/garden#51 (arrival
6859154429, bot replied after 12 min, dry run still flagged it) and fixed it in
main2 66ab9cc2018 (gh_api_retry's unterminated last line was dropped by `read`).

1. Confirm the leader's deployed root contains 66ab9cc2018
   (`git -C <worktree> merge-base --is-ancestor 66ab9cc2018 <deployed HEAD>`; find
   the deployed HEAD without running git in the garden root, e.g. via the
   deploy record). Only logs AFTER that deploy count; if it has been under a day,
   re-defer with set-schedule-once.sh.
2. Compare `journalctl --user -u garden-issue-status` "DRY RUN would post" lines
   (post-deploy, at least a day) against the kriscendobot/garden issue threads.
   Every would-post must be a maintainer arrival (issue, or comment whose first
   line begins `@kriscendobot `) with no bot comment for 20+ min (5+ under a deep
   queue). Nothing answered in time may appear.
3. If they match: delete `Environment=GARDEN_ISSUE_STATUS_DRY_RUN=1` from
   scripts/systemd/garden-issue-status.service, flip the script default
   (`: "${GARDEN_ISSUE_STATUS_DRY_RUN:=0}"`), update the unit/script/design/
   context/operations/systemd-units.md wording, run
   scripts/jobs/test/issue-status-pass-test.sh, push. If not, fix and restart.
Trigger: https://github.com/kriscendobot/garden/issues/128
