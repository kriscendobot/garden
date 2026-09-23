---
title: Session Establishment (Noise IK Handshake)
source: doc/design/net-crypto.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [networking]
status: current
supersedes: [cask--net-session-init-design--psk-handshake-packet-formats]
notes: The current session-establishment mechanism. Replaces the PSK + BLAKE2b-128 auth-tag handshake described in net-session-init-design.md and the architecture overview.
---

> Abstract: casknet establishes sessions with a two-message **Noise IK** handshake, `Noise_IK_25519_ChaChaPoly_BLAKE2b`. The IK pattern ("I know your key") lets the initiator encrypt its identity to the responder in the first message, hiding it from passive observers; the responder's static key is known to the initiator ahead of time from the member table. Message 1 (`init`, ~144 bytes) carries the 4-byte command, 32-byte client-chosen session_id, requested TTL, the initiator's ephemeral x25519 public key, the encrypted initiator static x25519 key (32B + 16B AEAD tag), and an encrypted timestamp payload (8B + 16B tag). Message 2 (`tini`, ~89 bytes on success) echoes session_id and granted TTL, carries the responder's ephemeral x25519 public key, and an encrypted status (1B + 16B tag); rejections are a shorter plaintext packet with the status byte at offset 40. Two messages suffice because Noise binds each message to its predecessor via the chaining key and handshake hash (no timestamp replay protection needed for the handshake itself), mirroring WireGuard's two-message handshake. If `tini` is lost, `ensureSession` retries `init` every 500ms (with a fresh session_id) until a response or the 10-second timeout; the orphaned server session expires after its TTL. Session establishment is infrequent (once per peer per hour by default), so the retry cost is acceptable.

## Session Establishment: Noise IK

Sessions are established with a two-message Noise IK handshake:

```
Noise_IK_25519_ChaChaPoly_BLAKE2b

Pre-message:
  <- s                          (initiator knows responder's static key)

Message 1 (init, client -> server):
  -> e, es, s, ss

Message 2 (tini, server -> client):
  <- e, ee, se
```

The IK pattern ("I know your key") allows the initiator to encrypt its identity to the responder in the first message, providing initiator identity hiding from passive observers. The responder's static key is known to the initiator ahead of time (from the member table).

On message 1 the server parses the Noise IK message, decrypts the initiator's static key, checks the member table (authorize), derives transport keys, and creates a server-role session. On message 2 the client parses the response, derives transport keys, and creates a client-role session. After that the session is ready for `stor`, `load`, `rots`, `casc`, … traffic.

### Why two messages suffice

The Noise IK pattern completes in exactly two messages. Unlike the previous PSK-based design, no timestamp-based replay protection is needed for the handshake itself: the Noise framework binds each message cryptographically to its predecessor through the chaining key and handshake hash. The two-message design is similar to WireGuard's handshake (also two messages, also Noise-based). Security rests on the Diffie-Hellman key exchange and the pre-known static keys, not on clock synchronization.

### What each message contains

**init** (client → server, ~144 bytes):

| Field | Size | Description |
|-------|------|-------------|
| command | 4B | `"init"` |
| session_id | 32B | Random, chosen by client |
| ttl_seconds | 4B | Requested session lifetime (big-endian uint32) |
| ephemeral_pub | 32B | Initiator's ephemeral x25519 public key |
| enc_static | 48B | Encrypted initiator static x25519 key (32B + 16B AEAD tag) |
| enc_payload | 24B | Encrypted timestamp payload (8B + 16B AEAD tag) |

The encrypted static key proves the initiator's identity to the server while hiding it from passive observers; the encrypted payload carries a timestamp for informational purposes.

**tini** (server → client, ~89 bytes for success):

| Field | Size | Description |
|-------|------|-------------|
| command | 4B | `"tini"` |
| session_id | 32B | Echoed from init |
| ttl_seconds | 4B | Granted session lifetime |
| ephemeral_pub | 32B | Responder's ephemeral x25519 public key |
| enc_payload | 17B | Encrypted status (1B + 16B AEAD tag) |

For rejections (not authorized, no identity) the server sends a shorter plaintext packet with just the status byte at offset 40.

### What if tini is lost?

UDP is unreliable. If `tini` is lost, `ensureSession` retries the `init` packet every 500ms until a response is received or the 10-second timeout expires. The server has already created its session, but the client sends a fresh `init` with a new session_id; the old server-side session expires after its TTL. This is acceptable because session establishment is infrequent (once per peer, per hour by default).

Source: [doc/design/net-crypto.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/net-crypto.md) at commit `cdb975d8`.
