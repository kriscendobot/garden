Implemented deterministic review-miss recurrence escalation and pushed commit `7264859283` to `main2`.

- Alerts fire only after the recurrence CAS commit succeeds, using per-cluster dedup keys.
- Drain reopens do not alert; delivery failures remain best-effort.
- Prosecutors retain no general maintainer-inbox capability.
- Updated prosecutor role and retrospective skill guidance.
- Added hermetic coverage for genuine recurrence, drain reopen, CAS retry, rerun idempotency, deduplication, and notification failure.
- Verification: `review-miss-record-test.sh` passed 48/48; all repository checks and five pre-push probes passed.
- Follow-ups: none.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/harden-review-miss-recurrence-escalation.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 350s

<!-- garden-usage-end -->
