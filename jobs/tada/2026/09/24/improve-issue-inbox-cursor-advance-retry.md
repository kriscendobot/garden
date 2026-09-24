Both the issue-inbox and mention watchers now retry a failed cursor advance within the same tick instead of stalling until the next one. The change is pushed to `main2` as commit `fe918d22339`, and all related test suites pass.

**What changed**
- **`scripts/jobs/issue-inbox-watcher.sh` (cursor-advance block, ~line 874):** the single `cursor-set.sh` call that gave up on any error is replaced by `advance_cursor_with_retry "$CURSOR_KEY"`, set up the same way as in `comment-watcher.sh`.
  - A transient write collision (the `rc=1` seen at 17:03, 17:18 and 17:20) is now retried with backoff.
  - A journal outage (`GARDEN_OFFLINE_RC`) is skipped quietly. Before, it logged a warning every tick.
  - A definite failure such as auth drift logs one warning with its cause and is not retried.
- **`scripts/jobs/mention-watcher.sh` (~line 513):** same fix for the identical pattern.
- **`scripts/jobs/common.sh` (`advance_cursor_with_retry`):** the issue-inbox watcher has time limits that the helper didn't know about, so I added two optional hooks for callers:
  - **Per-attempt time limit:** a caller can pass a command prefix that wraps every attempt. The issue-inbox watcher passes its existing `CURSOR_STAGE_TIMEOUT`, so each attempt is still capped at about 360s.
  - **Deadline:** a caller can set `GARDEN_CURSOR_ADVANCE_DEADLINE`, and no retry starts after it. The issue-inbox watcher passes its tick deadline (480s), so retries can't add up past the unit's 900s timeout, when systemd kills the run.

  Callers that don't use these behave exactly as before.

**Tests**
- **Issue-inbox (8 new checks):** a collision that clears on the third attempt still advances the cursor in the same tick, with no warning. When every attempt fails, it stops at the retry limit, warns once as transient, and exits cleanly. No retry starts once the deadline has passed.
- **Mention watcher (5 new checks):** the same retry and give-up cases.
- **Results:** issue-inbox 54/0, mention 41/0, comment-watcher 381/0, issue-inbox-tick-bounds 23/0, issue-inbox-journal-linkage 17/0, triager 160/0 (passed/failed). Shellcheck is clean.

**Follow-ups:** none needed. The change takes effect on each host's next deploy.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-issue-inbox-cursor-advance-retry.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (1200530 cached reads)
- Output: 19591 tokens
- Cost: $1.2606860000000006
- Wall-clock: 279s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
