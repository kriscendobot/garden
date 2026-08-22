Implemented and pushed commit `387ad5cd49` to `main2`.

- Enforced `provider.data_collection="deny"` and `provider.zdr=true` on every OpenRouter inference request through a fail-closed loopback adapter.
- Replaced the inactive DeepSeek/Llama free rows with the sole current zero-price, tool-capable public ZDR entry: `openrouter/z-ai/glm-5.2:free`.
- Updated routing, inventory, tests, design, operations, catalog, and model-selection documentation.
- Verification: OpenRouter harness 18/18, routing 32/32, worker spine 215/215, API-key handoff 7/7, plus syntax/config checks. Full suite reached 372/373; its sole failure was an unrelated issue-inbox diagnostic expectation.
- Follow-up: authenticated inference canary remains required after key provisioning; OpenRouter’s account-level content-logging opt-ins must remain disabled.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/openrouter-zdr-data-policy.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 1194s

<!-- garden-usage-end -->
