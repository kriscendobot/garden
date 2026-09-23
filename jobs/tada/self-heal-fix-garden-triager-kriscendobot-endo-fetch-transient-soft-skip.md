Implemented and pushed `8d83681ebe` to `main2`.

- Steady-state triager fetches remain timeout-bounded and retried.
- Any exhausted fetch failure now logs the requested WARN, sends a throttled per-slug maintainer alert, and exits 0.
- Updated triager tests; `scripts/jobs/test/triager-test.sh` passes (93/93).
