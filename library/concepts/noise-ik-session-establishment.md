---
id: noise-ik-session-establishment
aliases: ["Noise IK", "Noise Protocol", "noise handshake", "Noise_IK_25519_ChaChaPoly_BLAKE2b", "session establishment", "init tini", "init/tini", "ensureSession", "forward secrecy", "x25519", "ed25519", "directional keys", "WireGuard-style handshake", "PSK handshake", "ChaCha20-Poly1305", "AEAD envelope", "session key", "casknet session", "BLAKE2b session key", "transport keys", "Split", "nonceFromCounter", "counterFromNonce", "counter nonce", "send counter", "recv counter", "recvCtr", "sendCtr", "ErrReplayDetected", "replay protection", "monotonic counter nonce"]
topics: [networking]
status: current
---

# noise-ik-session-establishment

How casknet (CASK's encrypted-UDP inter-node protocol) sets up a secure session before any data flows. The **current** mechanism (`doc/design/net-crypto.md`) is a two-message **Noise IK** handshake, `Noise_IK_25519_ChaChaPoly_BLAKE2b`: the client sends `init` (~144 bytes: session_id, requested TTL, its ephemeral x25519 public key, its AEAD-encrypted static x25519 key, and an encrypted timestamp), the server decrypts the static key, checks it against the member table, and replies `tini` (~89 bytes: echoed session_id, granted TTL, its ephemeral x25519 public key, encrypted status). Both sides then `Split()` the Noise symmetric state into two 32-byte **directional** transport keys via HMAC-BLAKE2b HKDF (initiator encrypts with `k1`/decrypts with `k2`, responder the reverse). Because each handshake uses fresh ephemeral x25519 keypairs, the session has **forward secrecy**: compromising a node's long-term ed25519 key does not reveal past session keys. Thereafter every data packet is a ChaCha20-Poly1305 AEAD envelope `session_id (32B) || nonce (12B) || ciphertext (incl. 16B Poly1305 tag)`, with replay protection via monotonic counter nonces and a configurable TTL (default 1 hour). The design is WireGuard-like (two messages, Noise-based) and needs no DNS/TLS/CA; the local casksock protocol is plaintext, protected by filesystem permissions.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [cask--net-crypto--overview-and-identity](../sections/cask--net-crypto--overview-and-identity.md) | Current crypto overview; ed25519 identity at `.cask/id`, x25519 birational map. |
| [cask--net-crypto--noise-ik-handshake](../sections/cask--net-crypto--noise-ik-handshake.md) | The two-message Noise IK handshake, init/tini byte layouts, tini-lost retry. |
| [cask--net-crypto--transport-keys-and-forward-secrecy](../sections/cask--net-crypto--transport-keys-and-forward-secrecy.md) | `Split()` directional keys via HMAC-BLAKE2b HKDF; ephemeral-DH forward secrecy. |
| [cask--net-crypto--encrypted-packet-and-replay](../sections/cask--net-crypto--encrypted-packet-and-replay.md) | The AEAD envelope and per-direction monotonic-counter replay protection. |
| [cask--readme--noise-cryptography](../sections/cask--readme--noise-cryptography.md) | ChaCha20-Poly1305 AEAD over a two-message Noise IK handshake; no DNS/TLS/CA. |
| [cask--net-session-init-design--psk-handshake-packet-formats](../sections/cask--net-session-init-design--psk-handshake-packet-formats.md) | The **previous** PSK + BLAKE2b-128 handshake (superseded). |
| [cask--net-crypto-go--counter-nonce-and-replay-protection](../sections/cask--net-crypto-go--counter-nonce-and-replay-protection.md) | **Implementation source-of-truth**: the 12-byte nonce is the 8-byte big-endian send counter; the receive counter is a single strictly-increasing high-water mark; directional keys make the two counters independent. |
| [cask--net-crypto-go--command-constants-and-mirror-convention](../sections/cask--net-crypto-go--command-constants-and-mirror-convention.md) | The Noise-IK handshake packet sizes as the code defines them (176 / 121); the init payload carries the encrypted ed25519 identity key the member check authorizes. |
| [cask--net-peer-go--session-renewal-single-flight](../sections/cask--net-peer-go--session-renewal-single-flight.md) | **Initiator-side orchestration** around the handshake: `ensureSession` single-flights concurrent callers (one handshake runs, the rest wait on a channel and retry), renews proactively before expiry (default TTL 1h, margin 1m), and `establishSession` retransmits the init packet every 500ms over unreliable UDP until a response or a 10s timeout. |
| [cask--architecture--layers-0-1-block-transfer-and-session](../sections/cask--architecture--layers-0-1-block-transfer-and-session.md) | Layered overview describing the older PSK init/tini form. |
| [cask--architecture--ledger-sampling-and-security](../sections/cask--architecture--ledger-sampling-and-security.md) | The layered security model: ed25519/x25519/Noise authentication. |
| [cask--cryptography--option-b-one-way-dh](../sections/cask--cryptography--option-b-one-way-dh.md) | The design predecessor: one-way x25519 DH + optional ed25519 auth that Noise IK realizes. |
| [cask--cryptography--option-a-pre-shared-secret](../sections/cask--cryptography--option-a-pre-shared-secret.md) | The design predecessor's PSK option — origin of the superseded PSK handshake. |

## See also

- [[member-table-authorization]] — the authorized-peer table the Noise IK server checks the decrypted static key against.
- [[casknet-wire-protocol]] — the reversed-response command set and AEAD envelope the session carries.
- [[content-addressed-block-store]] — the 1KB blocks the AEAD envelope carries.
- [[codel-send-buffer-shedding]] — scheduling of the encrypted datagrams once a session exists.
- [[gc-quarantine-store]] — ephemeral session state lives in the deadline-based retention regime, evicted on TTL.

## Common confusions

- **Resolved (2026-06-24).** Two design docs at the same commit describe different handshakes. `net-crypto.md` is the **current** design: a Noise IK handshake with ephemeral x25519 Diffie-Hellman and forward secrecy. It explicitly calls the PSK + BLAKE2b-128 form "the previous PSK-based design." The PSK form (no DH, `K = BLAKE2b-256(PSK || session_id || "cask0")`) appears in `net-session-init-design.md` (now section-flagged `superseded`) and in the `architecture.md` Layer-1 overview. **Use the Noise IK form as casknet's session-init mechanism.** The session-table state shape and the AEAD envelope from net-session-init-design.md remain current; only the handshake that fills `session_key` changed.
