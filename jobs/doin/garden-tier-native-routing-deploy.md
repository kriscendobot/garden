---
role: gardener
model: gpt-5.6-terra
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-29T21:55:05Z cleared=none -->

---
model: gpt-5.6-terra
role: gardener
---
# Deploy tier-native routing fleet-wide

After garden-tier-native-routing succeeds, deliberately deploy its landed main2 revision to every active garden host. Maintainer kriskowal explicitly authorized this fleet routing rollout on 2026-07-29; use authorized_by: kriskowal for sysop deploy operations. Verify every reachable host runs the tier-native revision, has no failed units, preserves intentional drain state, and retains a positively live non-Claude worker pool. Endolin hosts keep gardeners: 0. Do not deploy the earlier concrete-pin implementation by itself; the target must support tier: and fallback-tier: end to end.

<!-- garden-reaped: 2 -->

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-07-29T22:24:14Z
