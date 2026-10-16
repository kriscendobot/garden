No new commit was needed: the fix this job asks for was already on `origin/main2` when I claimed it. Commit `9bad5343691` ("fix(watchman): skip the tick when the root repo lock is busy") landed about 10 minutes before the claim, apparently from a sibling job.

**What `scripts/jobs/watchman.sh` already does (lines 42–87):**
- A new helper, `watchman_rev_parse`, keeps git's exit status and stderr instead of throwing them away with `|| true`. It marks a failure as lock-busy when stderr contains the lock wrapper's `garden repo lock: timeout after …` (or `lock file kept being replaced`) line. It also logs the command line of the process holding the lock, so long exclusive holds can be identified.
- If HEAD still can't be resolved after the retries and the lock was busy, it logs `WARN: root repo lock busy; skipping tick` and exits 0. A HEAD that fails without lock contention still hits `die` (FATAL).
- For `origin/main2`, the same check applies: lock busy skips the tick with exit 0, and any other failure falls back to `local_sha` as before.

**Test:** `scripts/jobs/test/wedge-resolve-test.sh` has a new `WATCHMAN/LOCK-BUSY-SKIP` case. It covers persistent lock contention on HEAD (exit 0, skip logged, no FATAL, all retries run, holder logged), contention on `origin/main2` (exit 0, skip logged), and an unresolvable HEAD with no contention (still FATAL). I ran it in this worktree: 45 passed, 0 failed.

**Two ways it differs from the job text, both reasonable:**
- It recognizes a busy lock by the wrapper's stderr message, not by exit code 124. That's more reliable, because git can mask the wrapper's 124 behind its own exit status.
- When the lock is busy on `origin/main2`, it skips the tick instead of falling back to `local_sha`. That avoids comparing HEAD against stale data during a long exclusive hold; the next tick retries.

**Follow-ups:** none.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/self-heal-fix-garden-watchman-root-repo-lock-timeout-fatal.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (200833 cached reads)
- Output: 1455 tokens
- Cost: $0.3662666
- Wall-clock: 94s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
