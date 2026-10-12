Implemented and pushed commit `fe7f5b4fafb` to `main2`.

- Preserved freshness-sensor diagnostics.
- Converted transient sensor results (`12` or `GARDEN_OFFLINE_RC`) into clean deferred handoffs using `GARDEN_OFFLINE_RC`.
- Added regression coverage for both transient return paths and prevention of premature gauntlet staging.
- Passed auto-gauntlet handoff, panel freshness, completion integration, syntax, shellcheck, and diff checks.
- Follow-ups: none.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-auto-gauntlet-freshness-retry.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 142s

<!-- garden-usage-end -->
