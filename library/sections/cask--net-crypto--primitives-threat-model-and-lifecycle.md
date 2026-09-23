---
title: Primitives, Threat Model, Command Inventory, and Key Lifecycle
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

> Abstract: The reference tail of net-crypto.md: which primitives casknet picks and why, what its threat model does and does not protect, the wire-command inventory, and the key lifecycle. Primitives: ed25519 identity keys, x25519 (birational from ed25519) for Diffie-Hellman, BLAKE2b-256 handshake hashing, HMAC-BLAKE2b for the Noise HKDF, and ChaCha20-Poly1305 AEAD for both handshake and payload encryption with counter-based nonces. **Protected**: confidentiality and integrity/authenticity of every packet, replay of data packets, initiator identity hiding, and forward secrecy. **Not protected**: traffic analysis (packet sizes, timing, and the stable session_id are visible, though the session_id reveals no key material), denial of service (an attacker can flood `init`, each forcing a server DH; rate limiting recommended), and responder identity hiding (an observer who already knows the responder's public key can confirm it). All data commands ride inside the AEAD; responses are the request reversed (`stor`/`load`/`rots`, `casc`/`csac`, `gcgc`/`cgcg`); only the `init`/`tini` handshake pair is partly cleartext. The key lifecycle runs `cask init` → `cask invite` → `cask accept <pubkey>` → automatic Noise IK handshake on first command → TTL-based renewal (default 1 hour, re-established ~1 minute before expiry). Future work: phase-locked-clock PING/PONG to keep relays warm, measure RTT, and maintain clock agreement.

## Primitives

| Purpose | Primitive | Why |
|---------|-----------|-----|
| Identity keys | ed25519 | Widely deployed, compact (32B pub), signable for future use |
| Key exchange | x25519 (Diffie-Hellman) | Birational map from ed25519; standard Noise choice |
| Handshake hashing | BLAKE2b-256 | Fast, no length-extension, 256-bit output matches key size |
| Handshake KDF | HMAC-BLAKE2b (Noise HKDF) | Two-output HKDF per Noise spec |
| Handshake encryption | ChaCha20-Poly1305 AEAD | Encrypts static keys and payloads within Noise |
| Payload encryption | ChaCha20-Poly1305 AEAD | Fast in software (no AES-NI), constant-time, 256-bit key |
| Nonce construction | Counter-based (8 bytes in 12-byte nonce) | Simple, no randomness, replay protection built in |

## Threat Model

**Protected**: confidentiality of all block data, hashes, and capability tokens in transit; integrity and authenticity of every packet (AEAD tag); replay of data packets (monotonic counter); initiator identity hiding from passive observers (encrypted in Noise message 1); forward secrecy (ephemeral DH keys discarded after handshake).

**Not protected**: traffic analysis (an observer sees packet sizes, timing, and the stable session_id, which reveals no key material); denial of service (an attacker can flood `init`, though the server must perform a DH per packet; rate limiting recommended); responder identity hiding (the IK pattern assumes the initiator already knows the responder's public key, so an observer who knows it can confirm it).

## Command Inventory

All data commands are inside the AEAD ciphertext; response commands are the request reversed.

| Wire code | Direction | Purpose |
|-----------|-----------|---------|
| `stor` | C↔S | Store a block (also used as load response) |
| `load` | C→S | Request a block by hash |
| `rots` | S→C | Acknowledge received blocks (mirror of stor) |
| `casc` | C→S | Compare-and-swap a cell |
| `csac` | S→C | CAS response (mirror of casc) |
| `gcgc` | C→S | Trigger garbage collection |
| `cgcg` | S→C | GC result (mirror of gcgc) |

The only partially-cleartext commands are the handshake pair (`init`, `tini`), carrying Noise-encrypted identity material and key-exchange parameters. No application data is transmitted in the clear.

## Key Lifecycle

1. **`cask init`**: generates ed25519 keypair, writes `.cask/id` and `.cask/id.pub`.
2. **`cask invite`**: prints local ed25519 public key (hex) for out-of-band exchange.
3. **`cask accept <pubkey>`**: adds a peer's ed25519 public key to the local member table.
4. **Session establishment**: `ensureSession` automatically performs the Noise IK handshake before any command, using the stored identity and member table.
5. **Session renewal**: sessions have a configurable TTL (default 1 hour); `ensureSession` re-establishes when the renewal margin is reached (default 1 minute before expiry).

## Future Work: Phase-Locked Clocks (NTP)

Peers should exchange PING and PONG packets to keep relays from expiring the session and port assignment and, more importantly, to actively measure round-trip time (essential for tuning retransmission timers and congestion control). Phase-locked clocks would serve both needs with one mechanism: periodic time-stamped exchanges that keep the relay path warm, measure RTT, and maintain clock agreement.

Source: [doc/design/net-crypto.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/net-crypto.md) at commit `cdb975d8`.
