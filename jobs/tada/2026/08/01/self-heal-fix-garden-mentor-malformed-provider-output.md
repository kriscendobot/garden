Job complete.

## Completion report

**Context.** When I claimed this self-heal job (mentor failing ~24% of ticks with "malformed semantic output"), two commits had already landed concurrently — `a958e8cd14` and `2d2655f068` — that fully implemented **requirement #2** (treating a zero-`JOB`-line reply as the valid no-op, tolerating fences/preamble/decorated paths, naming the reject reason in the FATAL) and *partially* implemented **requirement #1** (evidence preservation). The line numbers in the spec (87–105, 152, 162) no longer matched the file. So I completed only the genuine remaining gap rather than redoing landed work.

**The gap I closed.** The prior fix wrote evidence to a single `$GARDEN_STATE/{mentor,foreman}/last-malformed.txt` that *each new rejection clobbers* — defeating the job's core intent ("eight failures have left no artifact"), since only the most recent failure ever survives.

**Changes (all in the two handlers + their tests):**
- `scripts/jobs/handlers/mentor-claude.sh` — `record_malformed_reply` now also writes `rejected/<utc-timestamp>-<provider>.txt`: one 4000-byte-capped capture *per failure*, nanosecond-resolution timestamp (unique + chronologically sortable), pruned to the most recent N (`GARDEN_MENTOR_REJECTED_KEEP`, default 20) via a sorted glob. `last-malformed.txt` retained as a stable "latest" pointer. The logged excerpt is now a small first+last-few-lines, byte-capped snippet (fits a supervisor's context).
- `scripts/jobs/handlers/foreman-claude.sh` — same treatment applied (the identical `trap`-destroys-evidence gap at the foreman validator), low-risk mirror keeping its `(provider, raw)` signature.
- `scripts/jobs/test/mentor-provider-order-test.sh` — new SUBTEST 18 (prose-only reply is a no-op that posts **nothing** — asserted via before/after board count) and SUBTEST 19 (a rejection writes the durable `rejected/` capture carrying the raw output). SUBTEST 4 (trailing prose after a valid block rejected, no second model) untouched.
- `scripts/jobs/test/foreman-provider-order-test.sh` — SUBTEST 11 gains the durable-capture assertion.

**Verification.** `bash -n` + shellcheck clean (no new warnings; the SC2010 `ls|grep` I introduced was replaced with a glob). Mentor suite **29/29**, foreman suite **21/21**. Manually confirmed pruning: 4 rejections with `KEEP=2` leaves exactly 2 captures plus `last-malformed.txt`. Committed as `9831cdf0e4`, pushed to `main2` on the first CAS attempt.

**Follow-ups:** none required. Note that `foreman-claude.sh`'s validator still does not compute a named `reject_reason` the way the mentor's now does (commit `2d2655f068` was mentor-only); that was out of scope here and is a separate, larger change if desired.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/self-heal-fix-garden-mentor-malformed-provider-output.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 33 tokens (1297670 cached reads)
- Output: 24232 tokens
- Cost: $1.9787340000000004
- Wall-clock: 386s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
