---
slug: endo-claude-agents-capability
repository: endo-but-for-bots
status: Proposed
size: M
milestone: M3
roadmap_relevance: 100
depends_on: [endo-claude]
pr: endo-but-for-bots#1102
created: 2026-09-03
updated: 2026-09-03
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
`@endo/claude` design and its draft builder (#1015); separates Endo's generic
daemon/factory work from Minion Town's account UX, identity mapping, credential
custody, quotas, and rollout policy.

- **Design PR:** endo-but-for-bots#1102 (open draft; design-only). Requested in the
  minion.town #64 maintainer review.
- **Ledger PR:** endo-but-for-bots#1127 (the groom that carved this into M3).
