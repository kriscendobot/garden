---
slug: endo-claude-agents-capability
repository: endo-but-for-bots
status: In Progress
size: M
milestone: M3
roadmap_relevance: 100
depends_on: [endo-claude]
pr: endo-but-for-bots#1560
created: 2026-09-03
updated: 2026-11-01
source: carved into M3 by groom-carve-mcp-bridge-milestone (2026-09-03)
---

# endo-claude-agents-capability — provision Claude-backed child guests (client-side bridge, M3 top priority)

The **provisioning half** of the confined in-guest agent, carved to the head of
M3 on 2026-09-03 alongside [[endo-claude]] and the capability-addressed git
remote ([[git-remote-capability]]).

A portable Endo capability for provisioning Claude-backed child guests **without
granting guests credentials, arbitrary host access, or authority over unrelated
guest namespaces**: namespace-scoped recursive factory facets, per-account-family
credential sources, single-use per-child credential leases, durable child
revocation, and fail-closed restart behavior, with the invariant that reusable
credentials never cross a guest-facing capability. Composes with the landed
`@endo/claude` confinement core (#1015, merged 2026-09-29); separates Endo's
generic daemon/factory work from Minion Town's account UX, identity mapping,
credential custody, quotas, and rollout policy.

- **Original design PR:** endo-but-for-bots#1102 — **closed unmerged
  2026-09-29**. Do not re-weave, re-gauntlet, or re-dispatch it.
- **Successor design PR:** endo-but-for-bots#1558
  (`designs/endo-child-agent-factory.md`, provider-neutral, capability-authorized
  durable child-agent factory; open, un-drafted after its gauntlet, awaiting
  maintainer approval). Posted by `design-endo-claude-agents-capability-20261026`.
- **Implementation: every step of the design's § Implementation plan is built**
  (audited 2026-11-01 by `build-endo-claude-agents-capability-slice-after-1573`).
  There is **no unbuilt slice**. Do **not** post another
  `build-endo-claude-agents-capability*` / `build-endo-child-agent-factory*` job.
  The open stack, all on endojs/endo-but-for-bots:
  - #1560 core coordinator, guards, policy, journal (plan step 1), out of draft;
  - #1561 daemon wiring: pinned coordinator, durable facet formulas (step 3);
  - #1562 child topology, Fae spawner adapter, inference/Fae/Lal/Claude makers (steps 2, 4);
  - #1563 driver turn ledger + worked provider-backed issuance example (step 5);
  - #1564 Fae/Lal reader-side reply collapse (step 6);
  - #1625 `coordinatorFacet` (`boundFacet`/`lifecycleFor`) on #1560;
  - #1626 #1562+#1564 merged and run on a real daemon (inference runner durable).
  Every bullet in the design's § Verification has a test in this stack (fake
  host recovery matrix, real-daemon restart/removal/revocation, turn-ledger
  crash cuts, Fae+Lal single-view reply test).
- **Next actions are review and restack, not build:** maintainer approval of
  design #1558 → land #1560 → weave #1561/#1563 (based on the stale
  `build/exo-agent-factory-core-8c4a87e` snapshot) and #1625 onto it with dated
  bases → land the rest. #1625's coordinator facet overlaps #1561's
  `daemon-coordinator.js` `boundFacet`; reconcile when weaving.
- **Out of scope here:** #1543 (API-key providers) and its builds #1573/#1587 are
  the companion *consumer* design (`designs/claude-api-key-agents.md`), not slices of this one; #1576/#1593 are
  unrelated. A live Claude turn is credential-gated backend acceptance, not a
  gate for this design.
- **Parked `build-endo-child-agent-factory-slice-2`** duplicated #1561–#1564/#1626
  and was withdrawn 2026-11-01.
- **Ledger PR:** endo-but-for-bots#1127 (the groom that carved this into M3).

---
_Reconciled 2026-10-31 by `reconcile-endo-claude-agents-capability-plan-status`:
status Proposed → In Progress; `pr` #1102 (closed) → #1560 (successor
implementation), to stop duplicate design/build dispatch against this record._
