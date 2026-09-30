---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/auto-gauntlet-handoff.sh
`scripts/jobs/auto-gauntlet-handoff.sh:47` turns a transient GitHub TLS handshake timeout into a failed producer completion (2026-09-30T05:03:31Z). Add bounded backoff retries for retryable `gh pr view` transport/API failures, preserving the immediate no-op for a non-PR and failing only after exhaustion. Extend `scripts/jobs/test/auto-gauntlet-handoff-test.sh` with a transient-first-attempt stub case.
