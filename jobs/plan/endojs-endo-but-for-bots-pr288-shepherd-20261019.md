---
gate: orchestrated
orchestrated_by: endojs-endo-but-for-bots-pr288-weave-shepherd-conduct-orch-20261019
priority: normal
posted_by: producer
posted_at: 2026-10-19T13:40:31Z
---

---
role: shepherd
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Shepherd https://github.com/endojs/endo-but-for-bots/pull/288 (`@endo/cbor-frame`) to green CI after its weave onto a frozen `llm-<sha>` base. Before the weave, the only red check was `test (24.x, ubuntu-latest)`; treat a Codeberg-clone failure in the Guile interop job as an external flake. Maintainer (kriskowal) approved and asked: rebase, shepherd, conduct.

