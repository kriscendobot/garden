---
title: PSK Handshake Packet Formats (superseded)
source: doc/design/net-session-init-design.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [networking]
status: superseded
superseded_by: cask--net-crypto--noise-ik-handshake
superseded_on: 2026-06-24
superseded_reason: net-crypto.md replaces the PSK + BLAKE2b-128 handshake with a Noise IK / x25519 DH handshake that adds forward secrecy. net-crypto explicitly calls this "the previous PSK-based design."
notes: The previous casknet handshake. Recorded for historical and wire-archaeology value; the current mechanism is the Noise IK handshake in cask--net-crypto--noise-ik-handshake.
---

> Abstract: The **previous** (superseded) casknet session handshake: a two-message PSK-authenticated exchange with no Diffie-Hellman. `init` (client→server, 82 bytes plaintext) carries the command, a 32-byte client-generated session_id, requested TTL, the client's IPv6 address and UDP port (NAT-traversal hints), a Unix-nanosecond timestamp, and a 16-byte `auth_tag = BLAKE2b-128(PSK || session_id || timestamp_ns)`; the timestamp blocks replay (server rejects if more than ±30 seconds off). `tini` (server→client, 65 bytes plaintext) echoes session_id, grants a (possibly reduced) TTL, carries the server timestamp, a status byte (0=success, 1=auth_failed, 2=rate_limited), and its own `auth_tag = BLAKE2b-128(PSK || session_id || server_time_ns || status)`. Both sides derive the session key as `K = BLAKE2b-256(PSK || session_id || "cask0")` ("CRYPTOGRAPHY.md Option A"). This whole mechanism is replaced by the Noise IK handshake in `cask--net-crypto--noise-ik-handshake`, which adds forward secrecy via ephemeral x25519 DH; consult that section for the current design.

## INIT Request (Client → Server, plaintext)

```
Offset  Size  Field          Description
0       4     command        "init"
4       32    session_id     Client-generated random session ID
36      4     ttl_seconds    Requested session TTL (big-endian uint32)
40      16    client_ipv6    Client's IPv6 address (NAT traversal hints)
56      2     client_port    Client's UDP port (big-endian uint16)
58      8     timestamp_ns   Client timestamp (big-endian uint64, Unix ns)
66      16    auth_tag       BLAKE2b-128(PSK || session_id || timestamp_ns)
```

**Total**: 82 bytes. The `auth_tag` proves the client knows the PSK without revealing it; the timestamp prevents replay (server rejects if more than ±30 seconds from server time).

## TINI Response (Server → Client, plaintext)

```
Offset  Size  Field           Description
0       4     command         "tini"
4       32    session_id      Echo of client's session_id
36      4     ttl_seconds     Granted TTL (may be less than requested)
40      8     server_time_ns  Server timestamp (clock sync hints)
48      1     status          0=success, 1=auth_failed, 2=rate_limited
49      16    auth_tag        BLAKE2b-128(PSK || session_id || server_time_ns || status)
```

**Total**: 65 bytes.

## Session Key Derivation (CRYPTOGRAPHY.md Option A)

```go
// K = BLAKE2b-256(PSK || session_id || "cask0")
func deriveSessionKey(psk [32]byte, sessionID [32]byte) [32]byte {
    h, _ := blake2b.New256(nil)
    h.Write(psk[:])
    h.Write(sessionID[:])
    h.Write([]byte("cask0"))
    var key [32]byte
    copy(key[:], h.Sum(nil))
    return key
}
```

## Protocol Flow

```
Client                                  Server
   |  init(session_id, ttl, addr, auth)    |
   |-------------------------------------->|
   |                                       | Verify auth_tag
   |                                       | Create session in table
   |                                       | Store peer address
   |  tini(session_id, ttl, status, auth)  |
   |<--------------------------------------|
   | Verify auth_tag                       |
   | Create session in table               |
```

Source: [doc/design/net-session-init-design.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/net-session-init-design.md) at commit `cdb975d8`.
