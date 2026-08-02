---
order: serial
children: minion-town-weblet-gateway-increment-2 minion-town-weblet-gateway-increment-3 minion-town-weblet-gateway-increment-4
on-child-failure: halt
state: running
created_by: builder
created_at: 2026-08-02T01:40:07Z
---

# Orchestration — carry the *.minion.town weblet gateway to completion (Increments 2→4)

Serial, halt-on-failure (each increment's edge evidence gates the next), per
designs/weblet-gateway.md § 10. Increment 1 (DNS + wildcard on-demand TLS +
endo-gateway :3002 + fail-closed /gateway/ask + isolation floor) is MERGED and
edge-verified LIVE (kriscendobot/minion.town#22, main 2b83906; kriskowal/garden#58).

Children in run order:
- minion-town-weblet-gateway-increment-2 — CAS content origin (content plane, § 5)
- minion-town-weblet-gateway-increment-3 — powers plane (OCapN/CapTP bootstrap, § 6)
- minion-town-weblet-gateway-increment-4 — publish capability + stubbed charge (§ 7)

Each child carries the #58 ISSUE NOTE verbatim and reports SHA/PR + probe evidence
on the issue thread as it deploys+verifies. Never close the issue (kriskowal closes it).
