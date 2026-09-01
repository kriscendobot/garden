Completed and pushed to `main2` at `5f228f9ffbd3670f9bfb3df9855c85819b2eda0d`.

- Enforced `data_collection: "deny"` and `zdr: true` on every stable and promo OpenRouter request.
- Kept the named inventory to reviewed `z-ai/glm-5.2:free`; excluded a newer candidate pending authenticated review.
- Completed the isolated `openrouter-promo` lane, 24-hour attestation expiry, automatic stale/404 disable, rip-cord tooling, and auditable reputation-arm migration.
- Added a forced two-turn live tool canary to the daily promo recheck and registered the journal schedule.
- Verified with `run-test.sh` (379 passed), promo lifecycle (15 passed), OpenRouter harness (25 passed), worker spine (260 passed), and reputation migration (24 passed).
- No authenticated inference ran because no API key is installed. Both pools remain zero as required.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/openrouter-zdr-policy-and-stealth-lane.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s) (2 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (2 engagement(s) unpriced)
- Wall-clock: 3109s

<!-- garden-usage-end -->
