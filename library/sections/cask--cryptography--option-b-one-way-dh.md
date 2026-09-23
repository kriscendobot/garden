---
title: Option B — One-Way DH (no pre-shared secret)
source: doc/design/cryptography.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [networking]
status: current
notes: Option B (one-way x25519 DH with optional ed25519 server auth) is the direction the current authoritative design realizes. net-crypto.md upgrades this single-flight DH sketch into a full two-message Noise IK handshake with mutual authentication via a member table and directional forward-secret transport keys. See cask--net-crypto--noise-ik-handshake and cask--net-crypto--transport-keys-and-forward-secrecy.
---

> Abstract: The no-pre-shared-secret variant. The server holds a long-term x25519 keypair `(s_pub, s_priv)` and publishes `s_pub`; the client knows `s_pub` and generates an ephemeral `(e_pub, e_priv)` per session. A **single message** from the client establishes a shared secret with no round-trip handshake: the client computes `shared = X25519(e_priv, s_pub)`, `K = BLAKE2b(shared || session_id || "cask-v1")`, and sends `e_pub (32) || session_id (32) || nonce (12) || ChaCha20-Poly1305(payload, K, nonce)`; the server recovers `shared = X25519(s_priv, e_pub)`, derives the same `K`, and creates the CAS session. All subsequent messages in both directions use Option A's transport envelope (`session_id || nonce || ciphertext || tag`) with the stored `K` and counters, unordered. Optional server authentication: the long-term key can be an ed25519 key (`s_ed_pub`) used for DH via `ed25519_private_to_curve25519` (Noise-style "ed25519 for auth, x25519 for DH"), or the server signs a static payload with ed25519 in its first reply so the client can verify the server identity. This single-flight DH sketch is the conceptual ancestor of net-crypto's Noise IK handshake.

The server has a long-term x25519 key pair; the client knows the server's public key. One message from the client establishes a shared secret; no round-trip handshake.

## Setup

- **Server**: long-term `x25519` key pair `(s_pub, s_priv)`. Publish `s_pub`.
- **Client**: has `s_pub`; generates ephemeral `(e_pub, e_priv)` per session.

## Session establishment (first message only)

- Client: `session_id = H(e_pub)[:32]` or 32 random bytes; `shared = X25519(e_priv, s_pub)`; `K = BLAKE2b(shared || session_id || "cask-v1")`.
- Client sends: `e_pub (32) || session_id (32) || nonce (12) || ChaCha20-Poly1305(payload, K, nonce)`.
- Server: receives `e_pub`, computes `shared = X25519(s_priv, e_pub)`, derives `K`, creates session in CAS keyed by `session_id` with `K`, `deadline = now_ns + TTL_ns` (Unix ns, local only), and counters. Any reply that communicates session lifetime uses **duration** on the wire.

## Subsequent messages (both directions)

Same as Option A: `session_id (32) || nonce (12) || ciphertext || tag (16)`. Server and client look up the session by `session_id` in CAS, using the stored `K` and counters. Unordered handling is identical to A.

## Optional: server authentication

The server's long-term key can be an **ed25519** key; publish `s_ed_pub`. Use `x25519(ed25519_private_to_curve25519(s_ed_priv), e_pub)` for DH so the same key is "ed25519 for auth, x25519 for DH" (Noise style). Or sign a static payload with ed25519 and send it in the first reply so the client can verify they're talking to the right server.

Source: [doc/design/cryptography.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/cryptography.md) at commit `cdb975d8`.
