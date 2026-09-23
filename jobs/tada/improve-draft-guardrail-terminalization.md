Implemented and pushed commit `5d514a7e6a` to `main2`.

- Draft-gate hits now terminalize completed jobs after posting one deduplicated maintainer action.
- PRs remain untouched: no re-draft and no automatic gauntlet staging.
- Failed action delivery remains retryable.
- Added regression coverage and updated lifecycle documentation.
- Passed draft-guardrail, terminalization, follow-up-gate, and completion-signal tests (31/31).
- Full check suite remains blocked by unrelated pre-existing `CLAUDE.md` inventory drift.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-draft-guardrail-terminalization.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 521s

<!-- garden-usage-end -->
