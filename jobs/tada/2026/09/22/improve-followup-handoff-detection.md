Implemented and pushed commit `a47b3c2d6e` to `main2`.

- Follow-up gate now infers a handoff when a successor was posted after the job’s first claim and is unambiguous.
- Inferred successors receive the standard handoff marker, so completion records `handed-off` and `deliverable-complete: false`.
- Pre-existing, unrelated, and ambiguous board entries remain blocked.
- Added regression coverage for inferred, sole, ambiguous, unrelated, and pre-existing successors.

Verification: `followup-posted-gate-test.sh`, shell syntax checks, and `git diff --check` passed. `completion-signal-test.sh` did not provide usable evidence because its gardener fixtures remained unclaimed in `todo`, including cases unrelated to this change.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-followup-handoff-detection.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 453s

<!-- garden-usage-end -->
