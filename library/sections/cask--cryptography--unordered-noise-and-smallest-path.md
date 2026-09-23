---
title: Unordered Delivery, Noise, the Smallest Path, and Primitives
source: doc/design/cryptography.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [networking]
status: current
notes: The two-round mutual-auth/forward-secrecy handshake floated as "optional later" here is what net-crypto.md adopts as the default (Noise IK). See cask--net-crypto--noise-ik-handshake.
---

> Abstract: How CASK reconciles secure sessions with unordered UDP, and the recommended rollout. Standard Noise handshakes (e.g. XX) assume ordered delivery, which CASK avoids: Option A has no handshake (PSK + session_id + counters), and Option B uses a single-flight "handshake" (client sends ephemeral + encrypted payload, server creates the CAS session) after which all messages are transport-only with `session_id` + nonce and unordered. Replay is handled by the monotonic nonce counter plus CAS `max_recv_ctr` state (optionally a small out-of-order window), needing no ordered FIFO; the session in CAS is keyed by `session_id` and holds `K`, `send_ctr`, `max_recv_ctr`, and a local Unix-ns `deadline`, with wire-side expiry always expressed as a duration. The suggested smallest path: implement Option A (PSK) first (only BLAKE2b + ChaCha20-Poly1305), add Option B if a pre-shared secret is undesirable, and — optionally later, for mutual auth and forward secrecy — run a two-round handshake once over UDP with retries, storing the resulting transport keys in CAS keyed by session id. The reference primitives are ChaCha20-Poly1305 (AEAD, 12-byte nonce, 16-byte tag), BLAKE2b (32-byte KDF output), x25519 (DH), and ed25519 (optional static server auth), all available in the Go standard library and/or `golang.org/x/crypto`.

## Unordered and Noise

- **Noise** handshakes (e.g. XX) assume ordered delivery of handshake messages. CASK avoids that by: **Option A** — no handshake; PSK + session_id + counters; **Option B** — a single-flight "handshake" (client sends ephemeral + encrypted payload; server creates the session and stores it in CAS), after which all later messages are transport-only with `session_id` + nonce, unordered.
- **Replay**: handled by a monotonic nonce (counter) and CAS state: `max_recv_ctr` (and optionally a small window for out-of-order). No ordered FIFO needed.
- **Session in CAS**: key = `session_id` (or hash); value = `K`, `send_ctr`, `max_recv_ctr`, `deadline` (Unix ns, local). TTL chosen so sessions expire; new sessions get a new `session_id` and a new `K`. When sending expiry info on the wire, use a duration (TTL remaining), not an absolute time.

## Suggested "smallest" path

1. **Implement Option A (PSK)** first: config = PSK (32 bytes) + session TTL; packet format `session_id || nonce || ChaCha20-Poly1305(plaintext)`; CAS session schema key = `session_id`, value = `send_ctr`, `max_recv_ctr`, `deadline` (Unix ns local; wire uses duration), optional role. No new crypto beyond BLAKE2b and ChaCha20-Poly1305.
2. **Add Option B** if you need no pre-shared secret: server static x25519 (or ed25519→x25519); client ephemeral; one message to establish the session; then the same transport as A, with session state in CAS until the deadline.
3. **Optional later**: for mutual auth and forward secrecy, a two-round handshake (client → server, server → client) can be run once over UDP with retries; the resulting transport keys are stored in CAS keyed by session id and used for all subsequent unordered LOAD/STOR. This stays compatible with "session in CAS until deadline" and unordered transport.

## Primitives (reference)

- **ChaCha20-Poly1305**: AEAD; 12-byte nonce, 16-byte tag.
- **BLAKE2b**: e.g. 32-byte output for key derivation.
- **x25519**: DH for Option B.
- **ed25519**: optional static server auth; combine with x25519 via ed25519→x25519 if desired.

All of these are available in the Go standard library and/or `golang.org/x/crypto` (ChaCha20-Poly1305, BLAKE2, x25519, ed25519).

Source: [doc/design/cryptography.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/cryptography.md) at commit `cdb975d8`.
