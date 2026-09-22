Implemented and pushed `6fbfd0834e` to `main2`.

- Rolling deploy now uses `budget/live/<pool>/<host>` heartbeats with a tunable 30-minute offline threshold.
- Offline peers are skipped before token release, alerted through coalesced per-host watchdog notices, and recorded with reasons in roll completion records.
- Returning active peers automatically rejoin; archived peers require explicit operator unarchival.
- All-offline/drained fleets visibly hold the leader unvalidated.
- Operator drains remain honored, while real validation failures still halt deployment.
- Updated the rolling-deploy design and regression coverage.

Validation: `scripts/jobs/test/rolling-deploy-test.sh` passed 52/52; `git diff --check` passed.

Follow-ups: none.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-rolling-deploy-skip-offline-peers-20260922.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 695s

<!-- garden-usage-end -->
