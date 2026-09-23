---
title: The counter-derived nonce and per-direction monotonic replay protection
source: net/crypto.go
source_kind: comment-fragment
source_repo: kriskowal/cask
source_path: net/crypto.go
source_line_range: "177-500"
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
comment_subject: How the 12-byte AEAD nonce is built from an 8-byte send counter, and how a strictly-increasing receive counter gives replay protection on the ChaCha20-Poly1305 envelope
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-26
ingested_by: scholar
topics: [networking, capability-security]
status: current
notes: |
  Implementation-side realization of cask--net-crypto--encrypted-packet-and-replay.
  The nonce-is-the-counter discipline and the recvCtr<=current rejection are the
  authoritative source for the replay-protection invariant.
---

> Abstract: casknet's per-packet nonce is not random: the 12-byte ChaCha20-Poly1305 nonce is four zero bytes followed by the 8-byte big-endian **send counter** (`nonceFromCounter` / `counterFromNonce`). `Encrypt` increments the session's send counter, seals the plaintext under the session's `sendKey`, and frames `session_id (32) || nonce (12) || ciphertext+tag`. `Decrypt` extracts the counter from the received nonce and **rejects any packet whose counter is not strictly greater than the highest counter already seen on that session** (`recvCtr <= currentRecvCtr` returns `ErrReplayDetected`), then opens under `recvKey` and advances the receive high-water mark. Because send and receive use the **directional** transport keys produced by the Noise split, the two counters are independent per direction. This is the implementation of the replay-protection invariant that [[noise-ik-session-establishment]] and [[casknet-wire-protocol]] describe in prose.

This section carries the nonce and replay comments. Concept: [[noise-ik-session-establishment]] (the AEAD envelope and directional keys); the design-doc counterpart is [cask--net-crypto--encrypted-packet-and-replay](cask--net-crypto--encrypted-packet-and-replay.md).

## The nonce is the counter

```go
// nonceFromCounter creates a 12-byte nonce from an 8-byte counter.
func nonceFromCounter(ctr uint64) [12]byte {
	var nonce [12]byte
	binary.BigEndian.PutUint64(nonce[4:12], ctr)
	return nonce
}

// counterFromNonce extracts the counter from a 12-byte nonce.
func counterFromNonce(nonce [12]byte) uint64 {
	return binary.BigEndian.Uint64(nonce[4:12])
}
```

The high 4 bytes of the nonce are always zero; the counter lives in the low 8 bytes, big-endian. Because the nonce is transmitted in the packet (offset 32-44 of the encrypted envelope), the receiver recovers the sender's counter directly from the wire and does not have to track it speculatively — it only has to remember the highest counter it has accepted.

## Encrypt: increment, seal, frame

`Encrypt` takes the session lock, increments `cached.sendCtr`, marks the session dirty, then builds the AEAD under the session `sendKey` and frames the packet:

```text
packet = session_id (32) || nonce (12) || ciphertext (plaintext + 16-byte Poly1305 tag)
```

The counter increment and the nonce derivation are the same operation viewed twice: the new send counter becomes the nonce, so no two packets on one session-direction ever reuse a nonce (the AEAD security requirement) as long as the counter does not wrap.

## Decrypt: replay rejection before open

```go
// Decrypt decrypts an encrypted packet and returns the plaintext.
// Also updates the receive counter for replay protection.
...
recvCtr := counterFromNonce(nonce)
...
if recvCtr <= currentRecvCtr {
	return cask.Hash{}, nil, ErrReplayDetected
}
```

The replay check is **strict monotonicity**: a counter equal to or below the current high-water mark is rejected as a replay before the AEAD open is even attempted. Only after a successful `aead.Open` under `recvKey` does `UpdateRecvCtr` advance the high-water mark (and only upward — `UpdateRecvCtr` itself guards `recvCtr > cached.recvCtr`). The window is therefore a single high-water mark, not a sliding bitmap: casknet assumes in-order-enough delivery per session and trades reordering tolerance for a one-`uint64` replay state. Any genuinely reordered or duplicated datagram below the mark is dropped.

## Directional keys make the two counters independent

`sendKey` and `recvKey` are the two 32-byte directional keys the Noise `Split()` produced (see [[noise-ik-session-establishment]]); `Encrypt` seals under `sendKey`, `Decrypt` opens under `recvKey`. The send counter and receive counter are therefore counting two different key streams, so the same numeric counter value on the two directions is not a reuse. The cached session holds both keys and both counters; the persisted session state holds only the send-side (see the key-asymmetry section of this source).

Source: [net/crypto.go](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/net/crypto.go) at commit `cdb975d8` (lines 177-500).
