---
id: member-table-authorization
aliases: ["member table", "membertable", "caskhead membertable", "cask accept", "cask invite", "authorized peer", "peer public key", "node identity", "ed25519 identity", "session gating", "status=2 not authorized", ".cask/id", "node_id", "cask member add", "cask member rm", "cask member ls", "set-traffic-class", "trafficClasses", "AddWithTrafficClass", "best traffic class", "membership set", "membership root", "GetMembershipRoot", "SetMembershipRoot", "statusNotMember", "Has(node_id)", "byKey lookup", "MemberAdd", "MemberAddFunc", "MemberLookupFunc", "mutual membership", "statusNotAuthorized", "MemberLookup", "ed25519 consistency check", "Ed25519PublicToX25519", "handleInit authorization", "responder mutual membership", "statusAuthFailed"]
topics: [networking, capability-security]
status: current
---

# member-table-authorization

How a casknet node decides which peers may open a session. Each node holds a long-lived **ed25519 identity** keypair (`.cask/id` private, `.cask/id.pub` public, from `cask init`) and a **member table** of authorized peer ed25519 public keys. A key enters the table via `cask accept <hex-pubkey>`; `cask invite` prints the local node's public key in hex for out-of-band exchange. During the Noise IK handshake the server decrypts the initiator's static public key from message 1 and checks it against the member table; an unknown key gets a plaintext rejection with `status=2` (not authorized). This is the authorization layer realized by the `membertable` package (node_id → presence, used for session gating) and the session table's `mode` field (0=member; future guest-session values). The member table replaced the earlier out-of-band PSK distribution: instead of a shared secret, authorization is per-peer public-key admission.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [cask--net-crypto--authorization-member-table](../sections/cask--net-crypto--authorization-member-table.md) | The member table, `cask accept`/`cask invite`, and the server's static-key check. |
| [cask--net-crypto--overview-and-identity](../sections/cask--net-crypto--overview-and-identity.md) | The ed25519 node identity the member table admits. |
| [cask--net-session-init-design--session-state-and-envelope](../sections/cask--net-session-init-design--session-state-and-envelope.md) | The session-table `mode` field that records member vs guest. |
| [cask--package-taxonomy--package-categories](../sections/cask--package-taxonomy--package-categories.md) | The `membertable` and `caskhead` packages in the taxonomy. |
| [cask--membertable-design--structure-and-operations](../sections/cask--membertable-design--structure-and-operations.md) | The member table's parallel-array structure (allocator/keys/byKey/trafficClasses) and its Has/Add/Remove/traffic-class operations. |
| [cask--membertable-design--cli-root-and-server-integration](../sections/cask--membertable-design--cli-root-and-server-integration.md) | The `cask member` CLI, the caskhead membership link, and the server's per-ini6 Has() check. |
| [cask--membership-next-steps--membership-mvp-roadmap](../sections/cask--membership-next-steps--membership-mvp-roadmap.md) | How the membership set comes to be: node_id identity, the CASK_MEMBERSHIP MVP, CASK_ROOT bootstrap, statusNotMember. |
| [cask--net-crypto-go--membership-mutuality-traffic-class-and-key-asymmetry](../sections/cask--net-crypto-go--membership-mutuality-traffic-class-and-key-asymmetry.md) | **Implementation note**: `MemberLookupFunc` gates on the initiator's ed25519 key (transmitted in the Noise payload), and `MemberAddFunc` makes membership mutual — a successful handshake records both peers (must be idempotent). |
| [cask--net-peer-go--session-renewal-single-flight](../sections/cask--net-peer-go--session-renewal-single-flight.md) | The initiator's side of mutual membership: after a successful handshake the initiator calls `MemberAdd` with the responder's ed25519 key (a failure is logged, not fatal), the symmetric counterpart to the responder's add. |
| [cask--net-peer-go--responder-handshake-consistency-and-authorization](../sections/cask--net-peer-go--responder-handshake-consistency-and-authorization.md) | **The responder side**: `Server.handleInit` proves the initiator's ed25519 key converts to the handshake's x25519 key (binding the ed25519-keyed table to the x25519 DH), checks `MemberLookup` and rejects non-members with `statusNotAuthorized`, then calls `MemberAdd` to record the initiator — the responder half of mutual membership. |

## See also

- [[noise-ik-session-establishment]] — the handshake that consults the member table.
- [[content-addressed-block-store]] — the store the authorized peer gains access to.
- [[cask-three-gate-access]] — the member table realizes gate 1 (membership) of the three-gate model.
- [[cask-caskhead-root]] — the caskhead `Links[2]` membership link the member table roots at.
- [[swap-to-end-allocation]] — the allocator the member table reuses for stable slot indexes.
- [[cask-cluster-provisioning]] — how two nodes' member tables come to permit each other.
