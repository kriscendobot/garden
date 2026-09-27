## Completion report: improve-triager-pacing-lock-test

I replaced the `sleep 1` timing guess in `scripts/jobs/test/triager-pacing-test.sh` with a readiness handshake, and pushed it to `main2` as **586aee8196b**. The suite now passes 14 of 14, and gave the same result on each of 3 consecutive runs.

**What changed (test file only):**
- **New `await_lock_holder <ready-fifo> <lock-file>` helper.** The lock holder writes `ready` to a named pipe only after `flock -x` returns. The test waits up to 20s to read that signal, then checks with `flock -n` that the lock really is held. Only then does it run the contention assertion. If the handshake fails, the test records a clear FAIL instead of racing.
- **Applied in two places:** the fail-fast/open contention block (the lines the job named) and the contention-backoff block further down, which had the same `sleep 1` pattern.
- **Holder cleanup:** the holder now runs `exec sleep`, so the cleanup `kill` hits the process that actually owns the lock. Before, an orphaned `sleep` child could keep holding the lock after the kill.

**A related runtime bug:** once the race was gone, the two contention-backoff cases still failed. The cause was in the code, not the test. `1570aa85a47` had changed the soft `clone_lock` give-up from exiting to returning. The triager's pacing refresh runs where errors don't stop the script, so it ignored that return and did the refresh without holding the lock. I wrote a fix, but while I was pushing, `4692b4df0e7` landed upstream and restores the exit behaviour, which fixes the same thing. I dropped my runtime changes and pushed only the test change. With that upstream fix plus my handshake, all 14 cases pass. The neighbouring suites (`ci-watcher-test`, `cursor-outage-cooldown-test`, `journal-contention-watch-test`) also passed.

**Follow-ups:** none needed. If anyone switches the soft give-up back to returning, `journal-contention-watch.sh`'s cleanup would also need a `clone_lock … || exit $?` guard before its `mv`: it runs inside `if ( … )`, where a returned failure is ignored, so the `mv` would run without the lock.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-triager-pacing-lock-test.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 44 tokens (1506039 cached reads)
- Output: 10166 tokens
- Cost: $1.1163437999999999
- Wall-clock: 227s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
