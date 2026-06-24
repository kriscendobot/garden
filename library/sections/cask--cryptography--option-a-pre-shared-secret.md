---
title: Option A — Pre-Shared Secret (the smallest)
source: doc/design/cryptography.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [networking]
status: current
notes: Option A (the PSK approach) is the conceptual origin of the PSK handshake that net-session-init-design.md documented and that net-crypto.md's Noise IK design now supersedes. See cask--net-session-init-design--psk-handshake-packet-formats (marked superseded) and cask--net-crypto--noise-ik-handshake (the current handshake).
---

> Abstract: The smallest secure-transport variant — no asymmetric crypto and no handshake — good for controlled deployments where a key is injected out-of-band. A 32-byte pre-shared secret (or `KDF(password, salt)`) is shared by client and server; the client picks a 32-byte `session_id` and derives the AEAD key `K = BLAKE2b(PSK || session_id || "cask-v1")`. Per-session state stored *locally* in the CAS (keyed by `session_id`) holds `send_ctr`, `max_recv_ctr`, an absolute Unix-ns `deadline`, and optional `role`. The wire format is `session_id (32) || nonce (12) || ciphertext || tag (16)`, where the nonce is a per-direction monotonic counter (8-byte big-endian, zero-padded to 12) used both as the ChaCha20-Poly1305 nonce and as the replay check (`recv_ctr > max_recv_ctr`). Lifecycle: the server allocates session state on the first packet with an unknown `session_id` (with `deadline = now_ns + TTL_ns`), both sides update counters per message, and the session is deleted when `now_ns >= deadline_ns`. Per-packet overhead is 60 bytes (32 session_id + 12 nonce + 16 tag) with no handshake — the first packet is already encrypted. This is the origin of the PSK handshake later superseded by net-crypto's Noise IK.

No asymmetric crypto, no handshake. Good for controlled deployments (e.g. single tenant, key injected out-of-band).

## Setup

- **PSK**: 32-byte shared secret (or `KDF(password, salt)`). Same value on client and server.
- **Session id**: 32 random bytes, chosen by client, sent in clear on first message and on every message (or only until the server has echoed it).

## Keys

- `session_id` = 32 random bytes (client-generated).
- `K = BLAKE2b(PSK || session_id || "cask-v1")` → 32 bytes for ChaCha20-Poly1305.
- Session state in CAS (keyed by `session_id` or `H(session_id)`), stored **locally**: `send_ctr` (8 bytes BE), `max_recv_ctr` (8 bytes BE), `deadline` (8 bytes, Unix ns — absolute expiry), optional `role` (client vs server, to separate counters per direction).

## Message format (on the wire)

```
session_id (32) || nonce (12) || ciphertext || tag (16)
```

- **Nonce**: For unordered delivery, use a **counter** per direction. The sender increments `send_ctr`, encodes it as a 12-byte big-endian (zero-padded) value, and uses it as the nonce. The receiver looks up the session, gets `max_recv_ctr`, checks `recv_ctr > max_recv_ctr` (replay check), decrypts, then updates `max_recv_ctr = recv_ctr` in CAS. So nonce = 8-byte counter padded to 12 bytes (or a 12-byte counter to allow 2^96 messages per session).
- **Plaintext**: the existing CASK payload (e.g. 4-byte command + hash + block + metadata).
- **Ciphertext**: `ChaCha20-Poly1305(plaintext, K, nonce)`; length = len(plaintext) + 16.

## Session lifecycle

1. **Create**: Client picks `session_id`, derives `K`, initializes `send_ctr = 0`. Server, on the first packet with an unknown `session_id`, allocates session state in CAS with `max_recv_ctr = 0`, `deadline = now_ns + TTL_ns` (stored as Unix ns locally). If the server needs to tell the client how long the session is valid, it sends a **duration** (`ttl_remaining_ns`), not an absolute time; the client sets its local `deadline = now_ns + ttl_remaining_ns`.
2. **Use**: Every LOAD/STOR carries `session_id` and nonce; both sides update counters in CAS after send/recv.
3. **Expire**: Background or on lookup — if `now_ns >= deadline_ns`, delete session state from CAS. New messages with that `session_id` are rejected (trigger re-key or new session).

## Overhead

- Per packet: 32 (session_id) + 12 (nonce) + 16 (tag) = 60 bytes.
- No handshake; the first packet is already encrypted (after session creation on the server side).

Source: [doc/design/cryptography.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/cryptography.md) at commit `cdb975d8`.
