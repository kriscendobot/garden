## Completion report: improve-post-loop-deadline-remaining-loops

All 16 scripts named in the job now stop their push retry loop once `GARDEN_POST_DEADLINE_SECS` has passed, and exit with rc=75 (`GARDEN_OFFLINE_RC`). The change is pushed to main2 as `6c28bb5812b`, and the tests I ran all pass.

**What changed** (18 loops in 16 scripts): each loop records `loop_start=$SECONDS` before it starts and calls `post_deadline_exceeded` at the top of each attempt.
- **Script-level loops exit 75:** annotate-plan, remove-schedule, withdraw-plan, defer-doomed-plan, doom-notice, post-gauntlet, unarchive-gauntlet, set-arc-budget, set-road, set-apportionment, seed-ironhorse-press, record-mirror. review-miss-record's two loops also exit; they sit inside subcommand functions, but nothing runs after those functions.
- **mirror-closer `mark_resolved`:** it exits 75, which ends the tick. Every later mapping write would wait on the same remote, and the next tick reconciles any closed mirror whose mapping didn't get stamped. Before this change it died after running out of attempts. I added a comment explaining this.
- **panel-run-record (both loops):** these run in a subshell, so `exit 75` only leaves the subshell and the caller's existing best-effort WARN path runs (it still returns 0).
- **ironhorse-fuzz `journal_put`:** it uses `return 75`, because its callers keep going and already treat any non-zero result as a failed write.
- I updated the exit-code note in remove-schedule's header.

**How callers treat rc=75:** none needed changes. `sync_clone` already exits 75 when the journal is offline, so every caller already copes with it:
- reaper's `surface_doom` saves the notice in its spool and retries it next tick.
- comment-watcher and mention-watcher leave the cursor in place and retry next tick.
- dependabotany-preflight logs a WARN and keeps the schedule.
- screen-delegated-prs and design-pr-gauntlet-coverage-audit log a WARN and retry next tick.
- auto-gauntlet-handoff passes the rc up to its caller.
- self-heal-run treats 75 as "skip this tick".

**Test:** I added case 7 to `post-loop-wallclock-deadline-test.sh`. It runs nine of the scripts that use the producer clone (annotate-plan, withdraw-plan, remove-schedule, post-gauntlet, unarchive-gauntlet, set-arc-budget, defer-doomed-plan, doom-notice, record-mirror) against a journal where every push fails (`GARDEN_PUSH_CMD=false`, 50 attempts, a 1-second deadline). Each one has to return 75 within 30 seconds, log the deadline, and leave the journal tip unchanged. Then a normal `post-job` has to go through, which shows the producer clone was released. The whole file passed 26/0. I didn't confirm that case 7 fails without the fix.

**Other tests run, all passing:** unblock-post-loop-deadline, mirror-closer, panel-run-record, panel-run-record-migrate, review-miss-record, defer-doomed-plan, accountant-arc-apportionment, scheduler-preflight-retire, ironhorse-fuzz (73/0) and dependabotany-preflight (60/0). shellcheck reports nothing on the changed lines; its remaining notices are on lines this change didn't touch.

**Follow-ups:**
- set-road, set-apportionment, seed-ironhorse-press, review-miss-record, panel-run-record and ironhorse-fuzz have the deadline check, but no test covers it yet. They are left out of case 7 because they need maintainer-allowlist or policy fixtures, or have their own test harness.
- I didn't search for push loops beyond the 16 scripts the job named.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-post-loop-deadline-remaining-loops.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 44 tokens (2169661 cached reads)
- Output: 16057 tokens
- Cost: $1.6890402
- Wall-clock: 674s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
