---
posted_at: 2026-11-01T04:51:25Z
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/foreman.sh
At foreman.sh:707-708, a post-job.sh exit of rc=75 (a transient journal clone-lock timeout) is logged as an ERROR and counted as a failed tick. The same base, 'ironhorse-test262-ratchet-coverage-crank-fifth-slice-20261101', failed at 04:25:02, 04:25:59, 04:32:29, 04:42:30 and 04:44:47. Treat rc=75 as a retryable tempfail. Retry post-job.sh in place with backoff before recording the outcome, and log a WARN rather than an ERROR if the retries are exhausted. Do not touch the anti-flap LAST_STEP state on a tempfail. Consider also checking whether the long-lived holder of producer/journal.lock is itself missing a timeout.
