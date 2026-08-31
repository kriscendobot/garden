---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/deploy-garden.sh
Add the Codex policy-refusal quarantine and resume regression suites to the default fast candidate gate. Repeated Ironhorse repair failures carried the provider policy-block envelope, while the deployed fleet predates the quarantine fix; this behavior must be deployment-gated so a future regression cannot reintroduce retry-and-inbox-error storms.
