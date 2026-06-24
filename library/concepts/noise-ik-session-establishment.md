---
id: noise-ik-session-establishment
aliases: ["Noise IK", "Noise Protocol", "noise handshake", "session establishment", "init tini", "init/tini", "PSK handshake", "ChaCha20-Poly1305", "AEAD envelope", "session key", "casknet session", "BLAKE2b session key"]
topics: [networking]
status: current
---

# noise-ik-session-establishment

How casknet (CASK's encrypted-UDP inter-node protocol) sets up a secure session before any data flows. The architecture document describes the implemented form as a two-message PSK-authenticated handshake: the client sends `init` (82 bytes: session_id, TTL, IPv6 address, timestamp, and a BLAKE2b-128 tag proving PSK knowledge), the server replies `tini` (65 bytes: session_id, granted TTL, status, its own tag), and both derive the session key `K = BLAKE2b-256(PSK || session_id || "cask0")` with no Diffie-Hellman. Thereafter every data packet is a ChaCha20-Poly1305 AEAD envelope `session_id (32B) || nonce (12B) || ciphertext (incl. 16B Poly1305 tag)`, with replay protection via monotonic counter nonces and a configurable TTL (default 1 hour). The README and the security section frame the cryptographic posture as Noise-style (ChaCha20-Poly1305 over a Noise IK handshake, ed25519 node identity, x25519 key exchange) with no DNS/TLS/CA dependency; the local casksock protocol is plaintext, protected by filesystem permissions, never encrypted.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [cask--readme--noise-cryptography](../sections/cask--readme--noise-cryptography.md) | ChaCha20-Poly1305 AEAD over a two-message Noise IK handshake; no DNS/TLS/CA; plaintext only on the local socket. |
| [cask--architecture--layers-0-1-block-transfer-and-session](../sections/cask--architecture--layers-0-1-block-transfer-and-session.md) | The init/tini PSK handshake, BLAKE2b session-key derivation, and the AEAD envelope layout. |
| [cask--architecture--ledger-sampling-and-security](../sections/cask--architecture--ledger-sampling-and-security.md) | The layered security model: transport/session/application encryption, ed25519/x25519/Noise authentication. |

## See also

- [[content-addressed-block-store]] — the 1KB blocks the AEAD envelope carries.
- [[codel-send-buffer-shedding]] — scheduling of the encrypted datagrams once a session exists.

## Common confusions

- The architecture document's *implemented* handshake is PSK + BLAKE2b auth tags with **no DH**; the README and security section describe the cryptographic posture as Noise IK with x25519 key exchange. Treat the PSK/BLAKE2b form as the current casknet session-init mechanism and the Noise IK framing as the protocol family it belongs to. The full reconciliation lives in `doc/design/net-crypto.md` and `doc/design/net-session-init-design.md`, deferred to a follow-on cask ingest; revisit this page once those are ingested.
