Implemented and pushed commit `ab41be8455` to `main2`.

- Captured Claude JSONL records preserve the weekly/session refusal wording verbatim in `message.content[].text`; metadata remains generic (`error: rate_limit`, HTTP 429) with no richer structured limit class. No actual capped terminal `--output-format json` envelope remained in the spool.
- Unified session, usage, weekly, and 5-hour signatures behind one shared definition, eliminating classifier drift.
- Added limit-type and reset-time extraction. Fleet notices now expose the specific limit class.
- Added reset-aware reaper backoff: claims remain held until their named reset and requeue immediately afterward.
- Added regression coverage for fast weekly and 5-hour refusals. Reverting the shared types to the pre-fix session/usage set made the integration test fail by classifying both as deterministic failures; restored code passes.
- Validation passed: classifier 40/40, elapsed-constancy 39/39, backoff 7/7, notice 23/23, and related reaper suites 16/16. Syntax and diff checks passed.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/quota-limit-type-differentiation.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 1536s

<!-- garden-usage-end -->
