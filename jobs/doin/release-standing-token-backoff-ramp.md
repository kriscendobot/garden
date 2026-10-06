---
role: gardener
tier: mentor
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=high at=2026-10-06T19:59:52Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Deploy the standing token-backoff ramp implementation

Deploy the implementation produced by orchestration sibling `build-standing-token-backoff-ramp`, under kriskowal's explicit authorization in https://github.com/kriscendobot/garden/pull/116#pullrequestreview-5432482973.

Read the build's fresh dated completion report through `tada_find`, recover its exact green `main2` implementation SHA, and confirm that SHA is still an ancestor of the current `origin/main2`. Never run git in the deployed root and never invoke `deploy-garden.sh` directly from a busy gardener. Use the garden's durable rolling-release/sysop path, with `authorized_by=kriskowal` and an exact target where the operation supports one, to hand the implementation to every active garden host. Record the durable release/sysop artifact IDs and any acknowledgments.

Confirm the rollout is durably owned before completing. Where the standing release machinery must finish after this gardener exits to permit quiescence, treat the durable accepted operation as the handoff, name it precisely, and do not falsely claim the deployed SHA was observed. If safe external evidence shows the rollout completed, report the observed deployed SHA per host and one post-deploy `budget-level` result whose reasons show ramp-derived per-pool backoff.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 4
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-06T20:00:09Z
