---
id: member-table-authorization
aliases: ["member table", "membertable", "caskhead membertable", "cask accept", "cask invite", "authorized peer", "peer public key", "node identity", "ed25519 identity", "session gating", "status=2 not authorized", ".cask/id"]
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

## See also

- [[noise-ik-session-establishment]] — the handshake that consults the member table.
- [[content-addressed-block-store]] — the store the authorized peer gains access to.
