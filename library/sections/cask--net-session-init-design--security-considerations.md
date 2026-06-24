---
title: Security Considerations and Transport Boundary
source: doc/design/net-session-init-design.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [networking]
status: current
notes: Replay/rate-limit/expiration and the transport boundary are current. The "PSK Distribution" item and "Future: Option B (DH)" are now realized: net-crypto.md replaces out-of-band PSK distribution with the ed25519 member table and Noise IK DH.
---

> Abstract: The operational security rules around casknet sessions and the plaintext/encrypted boundary. **Replay**: `init` carries a timestamp the server rejects if more than ±30 seconds out; encrypted messages use monotonic counters with the receiver rejecting `nonce <= recv_ctr`. **Rate limiting**: the server should rate-limit `init` per source IP (suggested 10/s, burst 20). **Session expiration**: sessions have a TTL (default 1 hour, max 24 hours), the caskhead session table auto-expires old ones, and clients should re-establish before expiry. The original **PSK distribution** note (PSK shipped out-of-band via config/env, with "Future: Option B (DH)" to remove the PSK) is now superseded: net-crypto.md realizes the DH option, replacing the PSK with ed25519 identities and the member table. **Transport boundary**: all inter-node UDP traffic requires encryption, and the only plaintext on the wire is the `init`/`tini` handshake pair (authentication material, no data); local CLI traffic uses the independent plaintext casksock Unix-socket protocol, which shares no command vocabulary. One open question remained: whether a client should extend TTL without full re-establishment (deferred).

## Replay Protection

- `init` includes a timestamp; the server rejects requests more than ±30 seconds from server time.
- Encrypted messages use monotonic counters; the receiver tracks `recv_ctr` and rejects messages with `nonce <= recv_ctr`.

## Rate Limiting

- The server should rate-limit `init` requests per source IP. Suggested: 10 requests per second per IP, burst of 20.

## Session Expiration

- Sessions have a TTL (default 1 hour, max 24 hours).
- The server's caskhead session table automatically expires old sessions.
- Clients should re-establish before expiry.

## PSK Distribution (superseded)

The original design distributed the PSK out-of-band (config file, environment variable) and named "Future: Option B (DH)" to eliminate the PSK. That future is now the present: `doc/design/net-crypto.md` replaces PSK distribution with per-node ed25519 identities and an authorized-peer member table, and replaces PSK-derived session keys with the Noise IK x25519 Diffie-Hellman exchange.

## Transport Boundary

All inter-node UDP traffic requires encryption; the only plaintext packets on the wire are the `init`/`tini` handshake pair, which carry no data, only authentication material. Local CLI communication uses a separate plaintext protocol over a Unix domain socket (`cask/sock`); the two protocols are independent and share no command vocabulary.

## Open Question

Should a client be able to extend a session's TTL without full re-establishment? Deferred to a future iteration.

Source: [doc/design/net-session-init-design.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/net-session-init-design.md) at commit `cdb975d8`.
