---
title: Session State and Encrypted Envelope
source: doc/design/net-session-init-design.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [networking]
status: current
notes: The session-table state shape and AEAD envelope remain current; only the handshake that populates session_key changed (Noise IK per net-crypto.md). The session_key derivation cited in the SessionState blob is the superseded PSK form.
---

> Abstract: The state casknet keeps per session and the envelope that wraps every data packet. Session state lives in caskhead's session table keyed by the 32-byte session_id, with an absolute `expiry` (Unix-nanosecond deadline) and a `SessionState` blob holding `send_ctr` (outgoing counter), `recv_ctr` (highest received counter, for replay protection), `session_key` (32-byte ChaCha20-Poly1305 key), `role` (0=client, 1=server), `mode` (0=member; future guest-session values), and `best_traffic_class` (lowest class this session may claim, default 5). Once a session exists, every message is `session_id (32) || nonce (12) || ciphertext || tag (16)`, where the 16-byte Poly1305 `auth_tag` authenticates the ciphertext (and proves the sender knows the session key; decryption fails if the tag does not verify) and the nonce is the 8-byte `send_ctr` big-endian, zero-padded into the high bytes of the 12-byte nonce. The state and envelope are current; only the handshake that fills `session_key` moved from PSK derivation to the Noise IK exchange of net-crypto.md.

## Session State

Stored in caskhead's session table:

```
session_id  : 32 bytes (lookup key)
expiry      : uint64 (Unix nanoseconds, absolute deadline)
data        : Hash → SessionState blob
```

SessionState blob:

```
send_ctr           : uint64 (outgoing message counter)
recv_ctr           : uint64 (highest received counter for replay protection)
session_key        : [32]byte (ChaCha20-Poly1305 key)
role               : uint8 (0=client, 1=server)
mode               : uint8 (0=member; future values for guest sessions)
best_traffic_class : uint8 (lowest class this session may claim; default 5)
```

## Encrypted Packet Structure

All encrypted packets follow this outer structure:

```
Offset  Size  Field        Description
0       32    session_id   Identifies the session (plaintext)
32      12    nonce        Counter-based nonce (plaintext)
44      N     ciphertext   Encrypted payload
44+N    16    auth_tag     Poly1305 authentication tag
```

The **auth_tag** (16 bytes) is the Poly1305 MAC from ChaCha20-Poly1305; it authenticates the ciphertext and ensures the sender knows the session key (decryption fails if the tag does not verify). The **nonce** is the sender's `send_ctr` (8 bytes) zero-padded to 12 bytes:

```go
func nonceFromCounter(ctr uint64) [12]byte {
    var nonce [12]byte
    binary.BigEndian.PutUint64(nonce[4:12], ctr)
    return nonce
}
```

Source: [doc/design/net-session-init-design.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/net-session-init-design.md) at commit `cdb975d8`.
