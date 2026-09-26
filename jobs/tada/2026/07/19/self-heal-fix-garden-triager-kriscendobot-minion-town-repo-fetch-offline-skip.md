Implemented and pushed `562646237c` to `main2`.

- Triager fetch now uses shared timeout safeguards, captures stderr, clean-skips transient/offline failures with exit 75, and preserves fatal handling for structural errors.
- Restored `--all --prune` refresh behavior.
- Verified: `bash scripts/jobs/test/triager-test.sh` (96 passed, 0 failed).

Self-improvement: nothing this time.
