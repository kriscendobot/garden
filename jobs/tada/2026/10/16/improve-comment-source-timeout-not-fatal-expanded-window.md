**Completion report: `improve-comment-source-timeout-not-fatal-expanded-window`**

The fix is now on main2 as `f46f1c474c0`. The cherry-pick and the push both went through without conflicts. Main2 was at `1e8ccd58d7a` at the time. The side branch `wip/improve-comment-source-timeout-not-fatal` has been deleted from origin.

**What changed** (5 files, +202/−5):
- **`common.sh`:** the gh retry helpers (`gh_api_retry`, `gh_read_retry`, `gh_pr_view_retry`) now treat exit codes 124/137 as transient instead of definitive. These are the gh wrapper's timeout codes, which come with no stderr. The helper retries once after a backoff, then gives up with a WARN carrying the `gh-call-timeout` marker.
- **`comment-source-gh.sh`:** the comment source now exits 124 when every failed fetch was a timeout. The watcher then takes its existing source-timeout path: a WARN, the cursor stays put, that repo backs off, and it exits 0. It no longer dies FATAL and fails the unit. A timeout mixed with a real failure still exits 1.
- **`comment-watcher.sh`:** comment update only.

**Tests:**
- `gh-api-retry-test.sh`: 68 passed, 0 failed.
- `comment-watcher-test.sh` with the fix: 486 passed, 1 failed, on two full runs. The 3 new inner-timeout cases pass. The two fan-out "5s deadline" cases passed this time.
- Base main2 in a full run: 480 passed, 4 failed. All 4 failures belong to the known fan-out 5s-deadline group and are down to this host's speed.

**The 1 failure is in an old test, not this change:**
- **The failing check:** "replay acknowledgment was not exactly once ()" in the busy-verify-lock replay case.
- **Base fails it too:** I cut the case down to a minimal harness and ran it on base main2. It fails there with the same log: "already actioned: live job … (idempotent skip)" and no ack. The full base run passed it only because of timing. The commit doesn't touch the ack or idempotency code.
- **Possible bug:** when the next tick sees the earlier post already on the board, it skips the job but doesn't confirm or ack the comment. That may be a real gap in the watcher, not just a test timing issue.

**Follow-up:** someone should look into that replay case (`comment-watcher-test.sh` around lines 4069–4111, and the "already actioned" skip in `comment-watcher.sh`). I did not post a job for it.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-comment-source-timeout-not-fatal-expanded-window.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (927980 cached reads)
- Output: 6455 tokens
- Cost: $0.733256
- Wall-clock: 2976s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
