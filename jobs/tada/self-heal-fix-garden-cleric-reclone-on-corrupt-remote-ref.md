Implemented and pushed `822fb07540` to `main2`.

- Added corrupt-clone signatures and self-healing repair/re-clone flow in `sync_clone`.
- Added null-SHA remote-ref regression coverage.
- Verified with `scripts/jobs/test/fetch-timeout-test.sh`: 16 passed, 0 failed.
- Full `run-test.sh` was not verified: its shared `/home/kris/.garden-test` fixture disappeared during concurrency setup.

Self-improvement: nothing this time.
