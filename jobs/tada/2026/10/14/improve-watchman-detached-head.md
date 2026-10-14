Implemented and pushed commit `2c19a13ded7` to `main2`.

- Watchman now resolves deployed `HEAD` with the existing bounded retry; `origin/main2` remains the upstream comparison.
- Added detached-HEAD coverage with no local `main2` ref.
- Verification: `wedge-resolve-test.sh` passed 37/37; watchman integration subtest passed. The broader suite encountered unrelated fixture failures.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-watchman-detached-head.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 754s

<!-- garden-usage-end -->
