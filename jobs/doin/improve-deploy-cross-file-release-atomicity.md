---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/deploy-garden.sh
Harden deploys against the recurring fleet-wide rc=127 restart storm. Per-file rename protects each script inode but still permits a running entrypoint to source a mismatched common/helper version during the multi-file release. Make the deploy script establish a deterministic coherent-release boundary for every garden-* unit (including non-gardener timers/services), then verify units restart from one release; retain a recovery path if that boundary cannot be established.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 2
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-23T03:17:33Z
