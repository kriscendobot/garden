---
id: cask-three-gate-access
aliases: ["three gates", "three-gate access", "order of gates", "invited guest", "known friend", "membership gate", "session gate", "capability gate", "membership session capability", "CASK is not an open service", "statusNotMember", "CASK_ROOT", "CASK_MEMBERSHIP", "root user", "membership MVP"]
topics: [capability-security, networking]
status: current
---

# cask-three-gate-access

CASK's layered access-control model: access to a node passes through three ordered gates. **Membership** ("known friend") decides whether a peer may connect at all — only peers whose 32-byte `node_id` is in the membership set may send `ini6` and establish a session; an absent peer gets `statusNotMember` and no session. **Session** is the authenticated, encrypted Noise-IK channel, opened only for members. **Capability** ("invited guest") decides what a session may do: each LOAD/STOR is authorized by a `cap_token` scoped to a cell or subtree (the CELLS.md model). The guiding principle is that CASK is not an open service — even establishing a session is an imposition permitted only for known friends, and membership is the prerequisite that keeps non-invited peers from ever reaching the point of presenting capabilities. The membership gate's MVP is a `CASK_MEMBERSHIP` file/env of hex node_ids plus a `CASK_ROOT` bootstrap root user, with persistence (caskset / Rabin-chunked sorted array) and cryptographic node_id proof deferred. The membership set itself is realized by the [[member-table-authorization]] member table.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [cask--membership-next-steps--three-gate-access-model](../sections/cask--membership-next-steps--three-gate-access-model.md) | The invited-guest principle and the membership → session → capability gate order. |
| [cask--membership-next-steps--membership-mvp-roadmap](../sections/cask--membership-next-steps--membership-mvp-roadmap.md) | Node_id identity, Option A/B proof, CASK_ROOT bootstrap, the CASK_MEMBERSHIP MVP, ini6/statusNotMember, the staged steps. |
| [cask--membership-next-steps--capability-gated-read-write](../sections/cask--membership-next-steps--capability-gated-read-write.md) | Gate 3: session is transport only; each LOAD/STOR needs a cap_token for the target cell. |
| [cask--membertable-design--cli-root-and-server-integration](../sections/cask--membertable-design--cli-root-and-server-integration.md) | The server's ini6 membership check that enforces gate 1. |

## See also

- [[member-table-authorization]] — the member table that realizes the membership gate (gate 1).
- [[noise-ik-session-establishment]] — the session gate (gate 2): the Noise IK handshake.
- [[cask-cell-facets]] — the capability gate (gate 3): the cryptographic cap-token cell model.
- [[cask-entry-type-capability]] — the structural-local half of CASK's capability layer.
- [[cask-cluster-provisioning]] — how membership tables on two nodes come to permit each other.
