---
posted_at: 2026-11-14T11:51:24Z
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/gardening/pre-push-gates/probes/spell-out-identifiers.sh
The blocklist at scripts/jobs/gardening/pre-push-gates/probes/spell-out-identifiers.sh:109 omits `n`, `id`, `ms`, and `p`, allowing fresh abbreviated identifiers through the deterministic gate. Add their spelled-out mappings and regression cases so the gate catches them before panel review; the 2026-11-14T11:37:39Z stylist result reported all four classes on one PR.

<!-- garden-productive-cycle -->
<!-- garden-transient-elapsed: kind=exit0 through=0 values=234 -->
<!-- garden-reap-now -->
---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-11-14T11:51:36Z
