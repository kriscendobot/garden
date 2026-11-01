The deadline fix for `unblock.sh` is on main2 as `af7b58c191b`, and the worktree is clean. Before the requeue I had committed and pushed, so this run only confirmed that and checked on the follow-up job.

**Shared helper:** `post_deadline_exceeded <loop-start> <what> <attempt>` in `scripts/jobs/common.sh` logs and returns 0 once a push loop has run for `GARDEN_POST_DEADLINE_SECS` (default 300s). Callers then do `&& exit "$GARDEN_OFFLINE_RC"`.

**`scripts/jobs/unblock.sh`:**
- The `hold_failed` retry loop (the one at line 89) now checks the deadline at the top of each attempt. When it expires, the tick exits 75 and the plan stays `gate: blocked` for the next tick.
- The unblock tick's other path, promoting a plan to todo, goes through `promote-plan.sh`. That script holds the producer clone lock and had the same unbounded 50-attempt loop, so I gave it the deadline too.
- When `promote-plan.sh` returns 75, `unblock.sh` now ends the tick. Before, it went on to try every remaining plan against the same unreachable remote.

**Existing deadline checks:** `post-job.sh`, `post-plan.sh`, `post-orchestration.sh` and `watchdog-notice.sh` now use the helper. Their behaviour is unchanged; `watchdog-notice.sh`'s log line now ends "skipping tick" instead of "giving up this delivery".

**Regression test:** the new `scripts/jobs/test/unblock-post-loop-deadline-test.sh` passes 14 of 14 checks:
- A deadline that has already expired exits 75 on the hold path.
- With fetches working but every push failing with a "Could not resolve host" error and 50 attempts allowed, the hold path and the promote path each exit 75 in about 1–2 seconds.
- In those cases the plans stay parked, the tick stops at the first failed promotion, and the producer clone is free afterwards for the next post.
- A healthy tick still holds the declined plan and promotes the others.

Against the old code, 9 of the 14 checks fail.

These existing tests still pass: `post-loop-wallclock-deadline-test` (16/16), `watchdog-notice-cas`, `watchdog-notice-dedup` (23/23), `promote-plan-doom-reset` (35/35), `promote-plan-shepherd-budget` (9/9), `awaiting-maintainer-gate` (9/9) and `orchestrate-test` (83/83). `bash -n` and shellcheck at warning level are clean on the touched files.

**Follow-up:** I posted `improve-post-loop-deadline-remaining-loops` for the other loops still bounded only by attempt count: `annotate-plan`, `remove-schedule`, `withdraw-plan`, `review-miss-record`, `mirror-closer`, `record-mirror`, and the rest of the list in that job. The journal now shows it in `jobs/tada/`, completed by another worker.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-unblock-post-loop-deadline.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s) (1 unmetered)
- Input: 8 tokens (478775 cached reads)
- Output: 1834 tokens
- Cost: $1.8223057999999996 (1 engagement(s) unpriced)
- Wall-clock: 2428s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
