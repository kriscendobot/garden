---
posted_at: 2026-11-01T07:02:27Z
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/*.sh (garden main2)
Follow-up to improve-unblock-post-loop-deadline (main2 af7b58c191b). That job added `post_deadline_exceeded <loop-start> <what> <attempt>` to common.sh. post-job, post-plan, post-orchestration, promote-plan, unblock and watchdog-notice now use it. Several push-CAS loops still run up to GARDEN_POST_ATTEMPTS (50) attempts with no wall-clock bound, so a degraded journal remote can hold a clone lock for tens of minutes: annotate-plan.sh, remove-schedule.sh, withdraw-plan.sh, review-miss-record.sh (two loops), mirror-closer.sh, record-mirror.sh, defer-doomed-plan.sh, doom-notice.sh, post-gauntlet.sh, unarchive-gauntlet.sh, set-arc-budget.sh, set-road.sh, set-apportionment.sh, seed-ironhorse-press.sh, panel-run-record.sh, ironhorse-fuzz.sh. For each loop:
- Record `loop_start=$SECONDS` before the loop.
- Call `post_deadline_exceeded ... && exit "$GARDEN_OFFLINE_RC"` at the top of each attempt. Inside a function whose caller must keep going, use `return` instead of `exit`.
- Check how each caller treats rc=75.
Extend scripts/jobs/test/unblock-post-loop-deadline-test.sh or post-loop-wallclock-deadline-test.sh with an unreachable-push case (GARDEN_PUSH_CMD failing, GARDEN_POST_DEADLINE_SECS=1) for the producer-clone ones.
