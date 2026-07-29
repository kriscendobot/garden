---
gate: orchestrated
orchestrated_by: garden-fireworks-glm52-rollout
priority: normal
posted_by: producer
posted_at: 2026-07-29T22:45:39Z
---

---
tier: mentor
role: gardener
fallback-tier: minion
dispatch: automatic
---
# Deploy GLM 5.2 fireworker support locally

After garden-fireworks-glm52-register succeeds, deliberately deploy its landed main2 revision on host endolin-garden-ece02cb4. This local deploy is explicitly authorized by maintainer kriskowal on 2026-07-29. Use the drain, quiesce, deploy, lift, and restart procedure. Verify the deployed revision contains the exact GLM 5.2 mentor inventory entry and provider-constrained tier resolution, the host is not unintentionally left draining, the existing cleric and mystic pools remain positively live, and no garden units are failed. Do not enable a fireworker until this verification passes.
