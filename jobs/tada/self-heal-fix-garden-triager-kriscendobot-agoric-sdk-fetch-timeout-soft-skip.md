Implemented and pushed `467ca35f5c` to `main2`.

- Triager fetch now targets only `origin`, bounded by `GARDEN_TRIAGE_FETCH_TIMEOUT` (default 600s).
- Fetch failures warn, alert with the throttled key, and exit 0.
- Added regression coverage for clean skip and origin-only fetch.

Verified: `scripts/jobs/test/triager-test.sh` (83 passed, 0 failed).

Self-improvement: nothing this time.
