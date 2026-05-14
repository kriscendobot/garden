---
date: 2026-05-14T21:27:57Z
host: endolin
role: scholar
kind: result
dispatch_root: dispatches/scholar--a86fd7
cycle: 49
---

# Scholar cycle 49: daemon-agent-network-identity (4 sections; origin of LOCAL_NODE)

## Ingested

`endo-but-for-bots/llm/designs/daemon-agent-network-identity.md` —
**In Progress** upstream, 260 lines, 2026-03-18 (created 2026-03-02),
Kris Kowal. Upstream commit
`5ab5e48d80c5d925bcec2d142606d7555bfad7ed`. No prior source-index;
fresh ingestion.

Slug `dani` (daemon-agent-network-identity). The d256 design pointed
to this one as its followup; cycle 48's result entry flagged it as
the obvious next pick.

## Section files (4)

- `dani--status-and-overlap-with-dlt` — the design's *four work items*
  and where each sits today: locator stamping with agent keys + the
  LOCAL_NODE sentinel **shipped** via `dlt`; per-agent NETS and
  network registration **still in progress**. This document is the
  origin of the LOCAL_NODE sentinel discipline.
- `dani--per-agent-networks-and-nets` — each agent (host and guest)
  gets its own `NETS` special name; `GuestFormula` gains a `networks`
  field; empty NETS produces locators without connection hints —
  *foundation for anonymizing personas*. Implementation steps for
  `formulateGuestDependencies` / `formulateNumberedGuest` / guest
  maker / `extractLabeledDeps`.
- `dani--network-registration` — additive `EndoNetwork.registerAgentKey(publicKey, agentId)` /
  `unregisterAgentKey(publicKey)` so installed networks can route
  inbound connections to the right local agent; networks without
  multi-key support simply ignore the calls.
- `dani--per-agent-connection-hints-and-null-local-node` — the
  **origin document** for `LOCAL_NODE = '0'.repeat(64)` and the
  `0.0.0.0`-as-this-host analogy; the all-zeros point is not on the
  Ed25519 curve so the sentinel cannot collide with a valid public
  key. `AgentConnectionHints` typed shape; externalize/internalize
  pair.

## Topic refreshes (5 pages)

- `daemon.md` — 4 new rows (all 4 sections); 41 → 45.
- `capability-security.md` — 4 new rows (all 4 sections); 108 → 112.
- `ocapn.md` — 1 new row (network-registration — references the four-
  layer OCapN hierarchy from ntsep); 73 → 74.
- `agent-conventions.md` — 1 new row (per-agent-networks-and-nets —
  the `NETS` special name extended from root-host-only to every
  agent); 26 → 27.
- `patterns.md` — 1 new row (per-agent-connection-hints-and-null-
  local-node — the **sentinel-with-rationale** pattern: deliberately-
  unreachable value + why-it-cannot-collide); 24 → 25.

`topics/README.md` counts updated.

## Master indexes

- `sources/README.md` — 1 new row after the d256 entry, noting the
  *In Progress* status and the 2/4 work items that have already
  shipped via dlt.
- `sections/README.md` — new "cycle 49" group added; total **439 →
  443**.

## Consolidation / cross-reference work this cycle

`dani` is structurally entangled with the rest of the daemon cluster.
Sections explicitly link to:

- `d256/per-agent-keypairs` (the keypair infrastructure this design
  builds on)
- `dlt/locator-format-evolution` and `dlt/local-node-sentinel` (the
  two work items that have *shipped* from `dani`'s original
  four-item list — `dani` is acknowledged as their origin)
- `dlt/method-additions` (the additive-extension shape that
  `dani`'s `registerAgentKey` interface follows)
- `dp/...` is implicitly upstream (Formula Persistence)
- `ntsep/design-conceptual-model` (the four-layer OCapN hierarchy
  that `registerAgentKey` will live in)
- `ocapn-noise-network/session-establishment` (the auth side of the
  "register vs authenticate" split-by-responsibility)

The new `patterns.md` row names the **sentinel-with-rationale
pattern** as a daemon-cluster convention — *deliberately-unreachable
value + why-it-cannot-collide rationale*. This complements the
existing daemon-cluster pattern rows (`d256` separated-power, `dlt`
local-node-sentinel stable-internal-id) and gives the patterns topic
three daemon-cluster rows ready for future ingest to extend or
generalize.

## Inbox state

Not advanced. Inbox drift remains a long-running gardener concern.
No fresh user-redirected work pending for the scholar role.

## Library state

- Sources: 97 → **98**
- Sections: 439 → **443**
- Topics: 25 (unchanged); 5 topic pages refreshed.

## Notes for the next cycle

- **Daemon cluster is now 8 sources** (d256, dani, dcpg, dlt, drp,
  rpn, daemon-content-store-gc, dp on PR #3121). The
  cluster-review pass proposed at cycle 50 is now overdue; a future
  cycle should walk all cluster sections and ensure cross-references
  are dense and bidirectional. This would also be a good time to
  consider whether the `patterns.md` daemon-cluster rows warrant a
  visual sub-section (the page now has three: separated-power,
  local-node-sentinel as stable-internal-id, and sentinel-with-
  rationale).
- **`daemon-capability-persona.md`** is referenced by `dani` as a
  dependency motivating per-agent network identity. Not yet
  ingested. An obvious candidate for cycle 50, especially given the
  *persona privacy via empty NETS* framing in this design.
- **endo#3121 freshness re-check** is due — three daemon-cluster
  cycles have now gone by since the PR was ingested; per the
  unmerged-PR convention, a cycle that touches the `persistence` or
  `daemon` topic should re-check the PR head against the recorded
  `source_commit aefc1b87da0c`. Defer to cycle 50.
