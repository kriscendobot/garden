Implemented and pushed commit `d318785ef0` to `main2`.

- First-cycle transients no longer emit shared progress entries.
- Bounded elapsed history now persists in claim/requeue metadata.
- Repeated failures remain visible, and early wedge detection is preserved.
- Outage/productive cycles clear stale elapsed history; promotion clears all related metadata.
- Relevant regression suites passed: 159 assertions, 0 failures.
- Follow-ups: none.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-gardener-transient-silence.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 946s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
