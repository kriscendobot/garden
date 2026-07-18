Already implemented on `origin/main2` (commit `0c940939e7`).

Confirmed bounded retries, timeout kill handling (124/137), WARN + throttled maintainer alert, and clean tick exit. Verified with `scripts/jobs/test/triager-test.sh`: 98 passed, 0 failed. No additional changes needed.
