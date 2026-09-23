---
title: Goal, Constraints, and Local-vs-Wire Deadlines
source: doc/design/cryptography.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [networking]
status: current
notes: cryptography.md is the original "minimal proposal" design doc that frames the two options (Option A PSK / Option B one-way DH). Its implementation-status banner (Option A fully implemented) is a snapshot; the current, authoritative casknet crypto is net-crypto.md, which realizes the DH/Noise direction as a two-message Noise IK handshake and explicitly supersedes the PSK handshake. See cask--net-crypto--* for the realized design.
---

> Abstract: The framing of CASK's secure-transport design: add confidentiality and integrity to LOAD/STOR over UDP without TLS/DTLS, using Noise-style primitives (x25519, ed25519, ChaCha20-Poly1305, BLAKE2) while allowing **unordered** messages and storing session state in the CAS until a deadline. The hard constraints: UDP messages can be lost/reordered/duplicated (no FIFO assumption); session key material and replay state live in the content-addressable store (or a small side store keyed by session id) with a deadline after which the session is discarded; and prefer the smallest complication (a single flight, avoiding order-dependent multi-round handshakes). A specific rule governs deadlines: **locally** always store session expiry as absolute Unix nanoseconds and expire when `now_ns >= deadline_ns`, but **on the wire** never send an absolute deadline — send a duration (TTL remaining) so the receiver computes its own `now_ns + duration_ns`, avoiding clock drift between peers. This document is the design predecessor to net-crypto.md, which realizes the DH direction as Noise IK.

> **Implementation status (as of the source doc)**: Option A (PSK) was fully implemented in `cask/net`; see `net/CRYPTO.md` for implementation details and `net/SESSION_INIT_DESIGN.md` for the `init`/`tini` handshake and encrypted command formats (`stor`, `load`, `rots`, etc.). All inter-node UDP traffic is encrypted; only the local Unix domain socket (`cask/sock`) remains plaintext. *(In the current authoritative design — `doc/design/net-crypto.md` — the PSK handshake is superseded by a two-message Noise IK handshake. See `cask--net-crypto--overview-and-identity`.)*

## Goal

Add confidentiality and integrity to CASK LOAD/STOR over UDP without TLS/DTLS, using Noise-style primitives (x25519, ed25519, ChaCha20-Poly1305, BLAKE2) while allowing **unordered** messages and storing session state in the CAS until a deadline.

## Constraints

- **Unordered**: UDP messages can be lost, reordered, duplicated. No FIFO assumption.
- **Session state in CAS**: Session key material and replay state live in the content-addressable store (or a small side store keyed by session id), with a deadline; after the deadline the session is discarded.
- **Smallest complication**: Prefer a single flight where possible, avoid multi-round handshakes that depend on order.

### Deadlines: local vs wire

- **Locally**: Always store the session expiry as **Unix nanoseconds** (absolute time). Expire when `now_ns >= deadline_ns`. No dependency on the other peer's clock.
- **On the wire**: Never send an absolute deadline. Send a **duration** (e.g. TTL remaining in nanoseconds, or seconds) when the protocol needs to communicate how long a session is valid. The receiver computes their own local deadline as `now_ns + duration_ns`. This avoids clock drift between client and server.

Source: [doc/design/cryptography.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/cryptography.md) at commit `cdb975d8`.
