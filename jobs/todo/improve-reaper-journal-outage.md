---
posted_at: 2026-11-04T22:50:47Z
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/reaper.sh
scripts/jobs/reaper.sh:761-762 lets a transient journal clone/fetch failure fail the oneshot unit; `garden-reaper.service` failed repeatedly at 09:43:31, 10:03:04, 10:13:19, and 10:33:10 during the journal outage.
Handle unavailable clone synchronization as a rate-limited, fail-open tick: unlock any clone state, preserve claims untouched, and exit cleanly so the timer retries without recording a systemd failure.
