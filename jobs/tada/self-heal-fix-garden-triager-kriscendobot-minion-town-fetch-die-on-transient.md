Implemented and pushed `9730e56259` to `main2`.

- Captured fetch stderr in `ERRF` and classified network and GitHub-source transients as clean skips.
- Preserved loud `die` behavior for structural fetch failures.
- Extended triager tests for transient GitHub HTML-source signatures and structural failures.

Verified: `scripts/jobs/test/triager-test.sh` (93 passed, 0 failed).

Self-improvement: nothing this time.
