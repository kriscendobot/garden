Implemented and pushed `457ba8a795`.

- Refresh fetch signal exits (including SIGTERM 143) now log and exit 0 without alerting.
- All other fetch failures warn, send the throttled `triager-fetch-failed-...` alert, and exit 0.
- Added coverage for non-signal alerts, SIGTERM silence, retries, and cursor preservation.

Tested: `scripts/jobs/test/triager-test.sh` (94 passed).

Follow-ups: none.
