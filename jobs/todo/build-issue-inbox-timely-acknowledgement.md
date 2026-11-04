---
posted_at: 2026-11-04T06:16:06Z
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Build timely issue-inbox acknowledgement (status pass plus checker fixes)

Role: builder. Garden repo, direct to main2 (no PR for the garden's own repo).

Design: designs/issue-inbox-timely-acknowledgement.md (commit 746d220507c). Trigger: https://github.com/kriscendobot/garden/issues/128

Build, in this order, as separate commits:
1. Latency checker: run the no-API heartbeat classification and its notices before the REST cooldown and budget-deferral exits (design: Fixing lateness, item 1).
2. Heartbeat `detail:` field and the issue watcher's `cursor-busy` outcome (item 2).
3. Align the issue-inbox should-ack predicate with the watcher's exact first-line rule, and check whether the endo-but-for-bots blind notice is the same class (item 3).
4. scripts/jobs/issue-status-pass.sh plus garden-issue-status.{service,timer}, leader-only, shipping with GARDEN_ISSUE_STATUS_DRY_RUN=1 (design: The status pass, Rollout, Test plan). Update skills/issue-inbox/SKILL.md and the CLAUDE.md Monitoring safety section as the design says.

First read the report of diag-issue-inbox-gap-20261104-endolin (jobs/tada on journal2, or your own inbox; it may still be queued). If it names a cause of the 03:37 to 04:32Z gap outside these changes, add a targeted fix. Do not wait on it: the changes above are needed whichever gate was responsible. Say in your report whether the cause was confirmed, and state it plainly if the report never arrived.

Constraints: no LLM in the trigger or text; trust gate before any body is read; no new repo or sender; never close issues. Removing the dry-run flag is a later step after a day of matching logs, so post that as a parked follow-up (scripts/jobs/post-plan.sh).
