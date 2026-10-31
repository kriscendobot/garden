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
updated: 2026-10-31
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
- **Implementation PR (first slice):** endo-but-for-bots#1560
  (`@endo/exo-agent-factory` coordinator state machine over a `PrivateHost` port;
  stacked on #1558's frozen design branch; open). Built by
  `build-endo-claude-agents-capability-20261026` — the build for this record has
  **already been dispatched**; do not post another `build-endo-claude-agents-capability*`.
- **Remaining slices:** parked on the board as
  `build-endo-child-agent-factory-slice-2` (blocked on #1560). The `pr:` field
  tracks #1560 only; a #1560 merge alone does not finish the design — keep this
  record In Progress until the remaining slices land.
- **Ledger PR:** endo-but-for-bots#1127 (the groom that carved this into M3).

---
_Reconciled 2026-10-31 by `reconcile-endo-claude-agents-capability-plan-status`:
status Proposed → In Progress; `pr` #1102 (closed) → #1560 (successor
implementation), to stop duplicate design/build dispatch against this record._
