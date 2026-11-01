---
posted_at: 2026-11-01T04:51:15Z
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/watchman.sh
Line 138 dies with "could not broadcast reread notice" whenever send-msg.sh fails to get the producer journal clone lock ("cannot acquire clone lock .../producer/journal.lock after 3 waits of 60s", 04:32:29). That fails the unit, and systemd then logs "Failed to start garden-watchman.service" at 04:32:50, 04:33:02 and 04:35:02. Retry the send a few times with backoff when the exit code is the transient lock code (75). Also move the `SEEN` update so the advance is re-attempted on the next tick instead of failing the unit. A lock timeout should log a WARN and exit 0, not mark the service failed.
