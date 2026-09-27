Fixed and pushed commit `4692b4df0e7` to `main2`.

- Restored soft clone-lock give-up to exit with `75`, preventing `ensure_clone`/`sync_clone` from continuing without a lock.
- Added a caller-scoped cooldown key so ci-watcher retains its shared contention latch without interfering with triager pacing.
- Verified triager pacing: 14/14 passed.
- Verified ci-watcher: 89/89 passed.
- Fetch/clone suites passed: 102/102, 24/24, 47/47; cooldown suite 61/61.
- Candidate gate passed all 622 shell syntax checks and all 12 deploy suites. A test-only empty cgroup fixture was required because this job runs inside a cleric service cgroup.
- The broad common suite reached 391/393; two unrelated gardener-scaler logging assertions failed.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-1570aa85-triager-pacing-contention-regression.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 471s

<!-- garden-usage-end -->
