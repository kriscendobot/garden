---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
role: builder

Close the local-verify parity gap exposed by endojs/endo-but-for-bots PR #1077: CI `test-xs` caught hardened262 baseline drift after a rebase, but `scripts/jobs/gardening/local-verify.sh` runs only each workspace primary `test`/`test:unit` and omits the CI-only `test:xs` suite. Extend the deterministic gate and its tests/docs so `test:xs` is covered without using a mismatched host `xst`; endo CI pins Moddable release 5.0.0 (XS 15.5.1), while the current garden host `xst` is XS 17.9.1 and produces a false local baseline change. Preserve silent-on-success and generic behavior.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-08-28T14:35:14Z
