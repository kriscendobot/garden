I fixed the race in `scripts/jobs/comment-latency-watch.sh`: when another watcher opens the shared REST cooldown partway through a sweep, the sweep now stops quietly instead of logging one failure per repository. The fix is pushed to `main2` as `474e93f0984`, with a new regression test. The test passes against the fixed script and fails against the old one.

**What changed in the script:**
- **New check after a failure:** a new helper, `source_failed`, runs after any source failure. If the failure was a primary-quota hit (stderr said the hourly limit ran out), it just stops the sweep. Otherwise it rechecks the shared REST cooldown with `api_cooldown_active rest`. If the cooldown is active it records that and stops the sweep without logging. If not, it logs the usual `WARN: latency source failed for <repo>` and moves on to the next source.
- **All four source types use it:** per-repo comments, the issue inbox, mentions, and the test-only source. Before, the issue-inbox and mention sources had no failure branch at all.
- **Cooldown heartbeat:** after collection, if the sweep stopped because of the shared cooldown, the tick writes a `cooldown` heartbeat and exits 0. It does not re-arm or extend the other watcher's cooldown. The existing start-of-sweep check and the primary-quota handling work as before.

**The new test** (`scripts/jobs/test/comment-latency-watch-test.sh`): a stub source opens the cooldown the way another watcher would, then fails with no quota message. The test checks that the tick exits 0, logs no WARN, writes a `cooldown` heartbeat, sends no notices, and leaves the other watcher's cooldown entry in place. A second case checks that the same silent failure with no cooldown active still logs the WARN.

**Follow-up:**
- The test only covers the single test-only source. The loop over many repositories, where the per-repo log flood actually happened, reads the repo list from the journal and has no test hook, so it isn't tested directly. Its fix uses the same `source_failed` helper.
- The latency-watch paragraph in CLAUDE.md says the cooldown is "honored before every sweep". It could also say the cooldown is rechecked after a source failure; I left it unchanged.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-latency-watch-cooldown-race.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (1063423 cached reads)
- Output: 10921 tokens
- Cost: $1.1173206000000002
- Wall-clock: 234s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
