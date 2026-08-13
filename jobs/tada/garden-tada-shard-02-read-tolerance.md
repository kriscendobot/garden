Implemented and pushed commit `a9adf2ea42` to `main2`.

- Centralized flat/sharded tada path building, lookup, existence, tree lookup, listing, and recent-window handling in `common.sh`.
- Converted all readers, including post-job dedup, orchestration, gauntlet, follow-up, unblock, watchers, dashboards, metrics, and lifecycle guards.
- Re-keyed follow-up state by basename to prevent migration notification storms.
- Kept every completion writer flat; no migration or writer switch occurred.
- Added flat, dated, and undated helper coverage plus sharded regressions for post-job, orchestration, gauntlet, follow-up, unblock, and cost.
- Verified: main suite 369/369, orchestration 42/42, gauntlet 34/34, post-job dedup 20/20, helper suite 10/10, cost 12/12; all shell scripts passed `bash -n`.
- Follow-up: deploy this reader-tolerance stage to every host before enabling sharded writers.

Self-improvement: added focused cross-layout regression coverage around the silent-failure paths.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/garden-tada-shard-02-read-tolerance.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 1023s

<!-- garden-usage-end -->
