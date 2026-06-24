---
source: doc/design/net-session-init-design.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
section_count: 5
status: current
notes: Partially superseded. The PSK handshake section is superseded by net-crypto.md's Noise IK design; the command vocabulary, session-state shape, inner-command wire formats, and operational security rules remain current. Flagged at the section level rather than retiring the whole source.
---

> Abstract: The casknet protocol document for establishing sessions and exchanging encrypted data over UDP. It defines the reversed-response command vocabulary (`init`/`tini`, `stor`/`load`/`rots`, `casc`/`csac`, `gcgc`/`cgcg`) and first-4-bytes packet detection, the (now-superseded) two-message **PSK-authenticated** handshake with BLAKE2b-128 auth tags and `K = BLAKE2b-256(PSK || session_id || "cask0")` key derivation, the caskhead session-table state (`send_ctr`, `recv_ctr`, `session_key`, `role`, `mode`, `best_traffic_class`), the AEAD envelope `session_id || nonce || ciphertext || tag`, the byte-exact wire format of every inner command (LOAD/STOR/ROTS/CASC/CSAC/GCGC/CGCG), and the operational security rules (replay, rate limiting, expiration, the plaintext/encrypted transport boundary). The PSK handshake is the **previous** design; the current session cryptography is `doc/design/net-crypto.md` (Noise IK + x25519 DH + forward secrecy). The wire formats and session-state shape this document defines remain current under the new handshake.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [command-vocabulary-and-detection](../sections/cask--net-session-init-design--command-vocabulary-and-detection.md) | networking | current |
| [session-state-and-envelope](../sections/cask--net-session-init-design--session-state-and-envelope.md) | networking | current |
| [inner-command-wire-formats](../sections/cask--net-session-init-design--inner-command-wire-formats.md) | networking | current |
| [security-considerations](../sections/cask--net-session-init-design--security-considerations.md) | networking | current |
| [psk-handshake-packet-formats](../sections/cask--net-session-init-design--psk-handshake-packet-formats.md) | networking | superseded |

## Provenance

- Repository default branch `main`; file last modified 2026-02-14 by Kris Kowal.
- The PSK-handshake section is superseded by `cask--net-crypto--noise-ik-handshake`. Soft-flag overlap (current, different abstraction levels) with the architecture overview's Layer 1 and with net-crypto.md's command inventory and envelope sections; cross-referenced via `notes:` rather than hard-flagged.

Source: [doc/design/net-session-init-design.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/net-session-init-design.md) at commit `cdb975d8`.
