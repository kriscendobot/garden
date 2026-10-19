---
role: shepherd
tier: mentor
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-10-19T15:16:24Z cleared=none -->

---
role: shepherd
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Shepherd https://github.com/endojs/endo-but-for-bots/pull/288 (`@endo/cbor-frame`) to green CI after its weave onto a frozen `llm-<sha>` base. Before the weave, the only red check was `test (24.x, ubuntu-latest)`; treat a Codeberg-clone failure in the Guile interop job as an external flake. Maintainer (kriskowal) approved and asked: rebase, shepherd, conduct.

