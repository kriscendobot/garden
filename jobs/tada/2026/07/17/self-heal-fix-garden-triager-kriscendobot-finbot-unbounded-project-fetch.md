Implemented and pushed `a24e3c92c6` to `main2`.

- Bound triager steady-state fetches with timeout, kill-after, retry, and backoff knobs.
- Retained `die "fetch failed for $slug"` only after retries exhaust.
- Updated regression test; `scripts/jobs/test/triager-test.sh` passes (82 checks).
