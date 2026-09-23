---
title: Encrypted Packet Format and Replay Protection
source: doc/design/net-crypto.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [networking]
status: current
---

> Abstract: The wire shape of every casknet data packet once a session exists, and how replays are rejected. After establishment all data packets are `session_id (32B) || nonce (12B) || ChaCha20-Poly1305 ciphertext (variable, includes the 16-byte Poly1305 tag)`. The session_id is cleartext so the receiver can pick the session keys before decrypting; the nonce is cleartext because AEAD nonces are not secret, only unique-per-key. Everything else (the 4-byte command tag, hashes, block data, capability tokens) is inside the authenticated ciphertext. **Replay protection** uses an independent counter per direction: `sendCtr` increments before each `Encrypt`, `recvCtr` tracks the highest accepted counter, and the nonce is `nonce[4:12] = big-endian(sendCtr)`. On receipt the receiver extracts the counter and drops the packet if `counter <= recvCtr` (a strict monotonic high-water check; out-of-order packets below the mark are dropped, acceptable for a UDP protocol that already tolerates loss and retransmits at the application layer). A retransmission re-encrypts with a fresh counter, so a late-arriving original is rejected as a replay while the higher-counter retransmit is accepted.

## Encrypted Packet Format

After session establishment, all data packets use this envelope:

```
 0                   32                  44
 +-------------------+-------------------+------------------+
 | session_id (32B)  | nonce (12B)       | AEAD ciphertext  |
 +-------------------+-------------------+------------------+
                                          | plaintext:       |
                                          |  command (4B)    |
                                          |  payload (var)   |
```

| Component | Size | Description |
|-----------|------|-------------|
| session_id | 32 bytes | Identifies which session keys to use |
| nonce | 12 bytes | Counter-based, monotonically increasing |
| ciphertext | variable | ChaCha20-Poly1305 AEAD output (includes 16-byte Poly1305 tag) |

The session_id is in cleartext so the receiver can look up the session keys before decrypting. The nonce is cleartext because AEAD nonces are not secret: they only need to be unique per key. Everything else (the command tag, hashes, block data, capability tokens) is inside the AEAD ciphertext and authenticated.

## Replay Protection

Each direction of a session maintains an independent counter:

- **sendCtr**: incremented by the sender before each `Encrypt` call.
- **recvCtr**: tracked by the receiver; updated after each successful `Decrypt`.

The nonce is derived from the counter: `nonce[4:12] = big-endian(sendCtr)`.

On receipt the receiver extracts the counter from the nonce and rejects the packet if `counter <= recvCtr`. This is a strict monotonic check: out-of-order packets with a counter below the high-water mark are dropped, acceptable for a UDP protocol that already tolerates loss and retransmits at the application layer.

When a packet is retransmitted (due to a lost acknowledgement), the sender re-encrypts with a fresh counter. The original packet, if it arrives late, is rejected as a replay; the retransmitted packet, with its higher counter, is accepted.

Source: [doc/design/net-crypto.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/net-crypto.md) at commit `cdb975d8`.
