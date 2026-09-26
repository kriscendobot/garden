Promoted local `qwen3.6` to `minion` with reviewed `pull_bytes` `23938333577`. Updated model-selection documentation and routing tests, including stale role-default assertions.

Committed and pushed to `main2`: `38a5a6715e`.

Verification:
- `model-routing-test.sh`: 32 passed
- `tier-vocabulary-routing-test.sh`: passed
- `worker-spine-kinds-test.sh`: 147 passed
- `sysop-test.sh`: 56 passed

Deployment required: the tier inventory has no journal override and is read only from the deployed `$GARDEN_ROOT`; fleet behavior will not change until a deliberate garden deploy. Model routing’s journal override does not apply here.

Risk recommendation: use a raised `handler-timeout: 7200` for minion-tier hermit experiments. A CPU-only 36B Q4_K_M model is likely to exceed the ordinary 2400-second budget and amplify existing panel-stage stalls. Record end-to-end handler duration, generation throughput, stage, and termination reason across representative jobs; retain or revise the higher default based on successful-run p95 duration and whether failures cluster at the timeout wall.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/promote-qwen36-to-minion-tier.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 408s

<!-- garden-usage-end -->
