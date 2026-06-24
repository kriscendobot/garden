---
title: Layer 0 (Block Transfer) and Layer 1 (Session & Security)
source: doc/design/architecture.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [networking]
status: current
notes: High-level architectural view; the cryptography and session-establishment depth is in doc/design/net-crypto.md and doc/design/net-session-init-design.md (deferred to a follow-on cask ingest).
---

> Abstract: The two foundation layers of casknet. Layer 0 is raw 1KB-block transfer (LOAD/STOR and their reversed-tag responses) over UDP within a 1500-byte MTU, the unchanging foundation. Layer 1 establishes secure authenticated sessions: a two-message PSK-authenticated handshake (`init` 82 bytes, `tini` 65 bytes) derives a session key `K = BLAKE2b-256(PSK || session_id || "cask0")` with no Diffie-Hellman, after which every data packet is wrapped in a ChaCha20-Poly1305 AEAD envelope of the form `session_id (32B) || nonce (12B) || ciphertext (incl. 16B Poly1305 tag)`. Response command tags are the request tag reversed (`stor`/`rots`, `casc`/`csac`, `gcgc`/`cgcg`).

## Layer 0: Block Transfer

Raw block transfer between peers. The foundation; no additions needed.

- 1024-byte block body + 12-byte metadata footer (height:8, numLinks:1, dataLen:2, reserved:1).
- All inter-node traffic encrypted via ChaCha20-Poly1305 AEAD (PSK sessions).
- Encrypted commands: `stor`, `load`, `rots`, `casc`, `csac`, `gcgc`, `cgcg`.
- Plaintext `init`/`tini` for session establishment only.
- UDP transport, 1500-byte MTU.

Use cases: direct block synchronization; low-level block storage and retrieval.

## Layer 1: Session & Security

### Session Establishment

Sessions use a two-message PSK-authenticated handshake:

- **`init`** (82 bytes): client sends session_id, TTL, IPv6 address, timestamp, and a BLAKE2b-128 auth tag proving knowledge of the PSK.
- **`tini`** (65 bytes): server responds with session_id, granted TTL, status, and its own auth tag.

Session key: `K = BLAKE2b-256(PSK || session_id || "cask0")`.

### Encryption

After establishment, all data packets use an AEAD envelope:

```
session_id (32B) || nonce (12B) || AEAD ciphertext (includes 16B Poly1305 tag)
```

The plaintext inside the AEAD carries a 4-byte command tag followed by command-specific payload. Response commands are the request reversed: `stor`/`load`/`rots` (store ack), `casc`/`csac` (CAS), `gcgc`/`cgcg` (GC).

### Session Management

- Sessions are keyed by a 32-byte random session_id chosen by the client.
- The session key is derived deterministically from PSK + session_id (no DH).
- Replay protection via monotonic counter-based nonces.
- Sessions expire after a configurable TTL (default 1 hour).

Source: [doc/design/architecture.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/architecture.md) at commit `cdb975d8`.
