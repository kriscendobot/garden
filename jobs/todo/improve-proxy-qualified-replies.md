---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/handlers/proxy-claude.sh
Validate each generated ANSWER before delivery; on rejected bare issue/PR references, perform one bounded repair pass with the validator diagnostics, then defer that question with a deduplicated maintainer note if it remains invalid. This prevents the same malformed proxy reply from crash-looping garden-proxy every five minutes.
