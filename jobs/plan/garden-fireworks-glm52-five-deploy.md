---
gate: orchestrated
orchestrated_by: garden-fireworks-glm52-five-rollout
priority: normal
posted_by: producer
posted_at: 2026-07-30T00:12:21Z
---

---
tier: mentor
role: gardener
fallback-tier: minion
dispatch: automatic
---
# Deploy GLM 5.2 support locally

After garden-fireworks-glm52-register-retry succeeds, deliberately deploy its landed main2 revision on endolin-garden-ece02cb4. This deploy is explicitly authorized by maintainer kriskowal on 2026-07-30. Verify the exact GLM 5.2 mentor inventory entry and provider-constrained tier resolution are present, drains are restored, the expanded Kimi pool remains configured, and no garden units are failed.
