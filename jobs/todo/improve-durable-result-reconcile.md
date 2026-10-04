---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/gardener.sh
entries/2026/10/04/054334Z-result-builder-83f4f1.md records completion at 05:43:36, but entries/2026/10/04/054400Z-progress-gardener-dc686b.md:7 requeues the same build after rc=75. scripts/jobs/gardener.sh:751-760 rescues only verified handoffs; add a claim-scoped durable-result verification path before scripts/jobs/gardener.sh:1552-1567 leaves a failed handler for reaping. Require the result to name the claimed job and claim fingerprint, then complete idempotently instead of rerunning already-finished work.

<!-- garden-reaped: 0 -->
