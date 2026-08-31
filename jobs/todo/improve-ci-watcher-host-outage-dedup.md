---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/ci-watcher.sh
Make the journal-fetch outage latch atomic and genuinely shared across per-repo watcher processes. The same outage emitted several “further warnings deduped” messages, so emit one warning per host outage episode and one recovery notice.
