Existing fix already covers this; deployment is the only remaining gap.

Commit: `1d6cdc5a14c907b6d911de43c64019a6340e4d5e` (`fix(comment-watcher): don't let a completed tada job swallow a fresh verb directive`), already on `main2`.

Evidence: ran `scripts/jobs/test/comment-watcher-test.sh`: 234 passed, 0 failed, including fresh directive after completed `tada/` and idempotent re-poll coverage.

No code changes or push needed. Follow-up: deploy `main2` to update the running watcher.

Self-improvement: nothing this time.
