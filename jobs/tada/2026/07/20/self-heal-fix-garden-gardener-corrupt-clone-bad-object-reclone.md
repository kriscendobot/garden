Implemented and pushed `822fb07540` to `main2`.

- `ensure_clone` now health-checks present clones for bad `origin/journal2` refs and `.git/gc.log`, then atomically re-clones corrupt clones under the existing lock.
- Added regression coverage for bad remote ref plus stale `gc.log`.
- Cleared gardener/14's wedged journal clone.
- Ran `scripts/jobs/test/fetch-timeout-test.sh`: 16 passed, 0 failed.

Self-improvement: nothing this time.
