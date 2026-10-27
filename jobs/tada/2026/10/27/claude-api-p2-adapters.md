Implemented Phase 2 and opened draft PR: https://github.com/endojs/endo-but-for-bots/pull/1575

- Added Anthropic API-key issuer, strict pre-secret validation, three-scope accounting, model discovery, limits, and durable settlement.
- Added credential-free Lal/Fae brokered Messages adapters with cancellation and SSE/tool/usage handling.
- Added comprehensive tests; targeted suites, type checks, lint, pre-push probes, and all relevant CI tests pass.
- Sole CI failure is unrelated runner infrastructure: missing `tred`, also failing on the phase-1 base PR.
- Updated arc tracker #227 and landed an `inference-provider-broker` library concept.
- Pushed commit `2515a686ffef19eec160bf655adc003c38219351`.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/claude-api-p2-adapters.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 2503s

<!-- garden-usage-end -->
