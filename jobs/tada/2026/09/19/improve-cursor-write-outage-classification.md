Implemented and pushed commit `917115c9b77` to `main2`.

- Cursor writes now detect sync, push, and verification-fetch transport outages, latch the shared host cooldown, and return `EX_TEMPFAIL` without exhausting CAS retries.
- Bounded ambiguous `rc=1` fetches are classified conservatively.
- Authentication, local-state, corruption, and missing-upstream failures remain loud.
- Shared read/write classification logic prevents cursor-get/cursor-set drift.
- Added comprehensive cursor-write outage and retry coverage.

Verification:
- Cursor outage suite: 49 passed, 0 failed.
- Full jobs suite: 386 passed, 0 failed.
- Shellcheck warning-level and `git diff --check`: clean.
- Remote `main2` confirmed at `917115c9b77`.

Follow-ups: none.
Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-cursor-write-outage-classification.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 463s

<!-- garden-usage-end -->
