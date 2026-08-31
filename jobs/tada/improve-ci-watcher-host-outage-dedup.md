Implemented and pushed commit `f214a1399a` to `main2`.

- Serialized the host-shared journal-outage latch with `flock`.
- Suppressed duplicate outage observations entirely.
- Emits exactly one warning and one recovery notice per episode.
- Added six-process concurrent outage and recovery regression coverage.
- Tests: `ci-watcher-test.sh` passed 62/62 three consecutive times; syntax and diff checks passed.
- Follow-ups: none.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-ci-watcher-host-outage-dedup.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 283s

<!-- garden-usage-end -->
