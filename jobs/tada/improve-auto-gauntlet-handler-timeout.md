Implemented and pushed `6963e506db`.

- Auto-gauntlet handoffs now stamp `handler-timeout: 7200`.
- Comment-triggered gauntlets use the same shared timeout as shepherds.
- Added regression coverage for both producers.

Verified: `bash -n`, `auto-gauntlet-handoff-test.sh`, and `comment-watcher-test.sh` (236 passed).

Self-improvement: nothing this time.
