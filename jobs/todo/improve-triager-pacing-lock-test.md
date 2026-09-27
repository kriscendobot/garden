---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/test/triager-pacing-test.sh
scripts/jobs/test/triager-pacing-test.sh:201-205 relies on `sleep 1` to assume its lock holder is ready; the deploy gate rejected this suite at 03:06:54Z. Replace the timing assumption with a deterministic readiness handshake before running the contention assertion.
