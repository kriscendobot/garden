---
gate: deferred
not_before: 2026-11-05T12:00:00Z
priority: normal
posted_by: builder
posted_at: 2026-11-04T08:42:19Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Go live with the issue status pass (remove GARDEN_ISSUE_STATUS_DRY_RUN)

Role: builder. Garden repo, direct to main2.

`scripts/jobs/issue-status-pass.sh` (garden-issue-status, leader-only) shipped in
7f0c3f7cd1c with `GARDEN_ISSUE_STATUS_DRY_RUN=1` in
`scripts/systemd/garden-issue-status.service`. Design:
designs/issue-inbox-timely-acknowledgement.md § Rollout. Trigger:
https://github.com/kriscendobot/garden/issues/128

Promote once at least a day of deployed leader logs exists. Before removing the flag:
compare the leader's `journalctl --user -u garden-issue-status` "DRY RUN would post"
lines against the issue threads on kriscendobot/garden for that day. Every would-post
must be an arrival from a maintainer (an issue, or a comment whose first line begins
`@kriscendobot `) with no bot comment for 20+ minutes (5+ under a deep queue). Nothing
answered in time may appear. If they match, delete the Environment= line (the script
default is 1, so also flip the script default to 0 or set the env to 0 explicitly) and
push. If they do not match, fix the rule and restart the day's observation.
