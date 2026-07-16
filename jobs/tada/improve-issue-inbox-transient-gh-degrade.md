Implemented and pushed `273b75f1dd` to `main2`.

- Added transient network and gh-api source-error WARN-skip handling to `issue-inbox-watcher.sh`.
- Preserved fatal behavior for structural source failures.
- Verified with `bash -n` and `scripts/jobs/test/issue-inbox-watcher-test.sh` (38 passed, 0 failed).
