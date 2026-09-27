Implemented and pushed to `main2` at `9dbda9d5573`.

- Live clone-lock contention now exits quietly with `GARDEN_OFFLINE_RC` before outage classification.
- It does not latch the host-wide journal outage cooldown.
- Definite local/auth/corruption failures remain loud.
- Consolidated concurrent overlapping fixes and removed contradictory tests.
- Verification: `cursor-outage-cooldown-test.sh` passed all 61 tests; syntax and diff checks passed.
- Broader `run-test.sh`: 391 passed, with 2 unrelated gardener-scaler logging failures.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/self-heal-fix-garden-ci-watcher-kriscendobot-endo-but-for-bots-clonelock-busy-not-quiet.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 410s

<!-- garden-usage-end -->
