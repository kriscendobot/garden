Added `designs/ironhorse-fuzz-triage-and-batch.md` and pushed commit `4ebfd12ac3` to `main2`.

The design specifies bounded triage, artifact suppression, root-cause clustering, batch repair jobs, backlog hysteresis, legacy-job migration, and deliberate two-part re-arming. It explicitly supersedes `ironhorse-fuzz-repromote-quarantined`.

Checks: all five pre-push probes passed; remote `main2` matches the landed commit.

Follow-up: implement the design, migrate the backlog, then re-arm the timer.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/design-ironhorse-fuzz-triage-and-batch.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 703s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
