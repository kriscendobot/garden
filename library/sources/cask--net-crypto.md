---
source: doc/design/net-crypto.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
section_count: 6
status: current
---

> Abstract: The **current, authoritative** casknet cryptography design. casknet encrypts all inter-node UDP traffic with ChaCha20-Poly1305 AEAD keyed by sessions established through a two-message **Noise IK** handshake (`Noise_IK_25519_ChaChaPoly_BLAKE2b`) performing an authenticated x25519 Diffie-Hellman exchange that yields directional transport keys with forward secrecy. Nodes carry long-lived ed25519 identities, authorize peers through a member table (`cask accept`/`cask invite`), wrap data in a `session_id || nonce || AEAD` envelope with monotonic-counter replay protection, and renew sessions on a TTL. This document explicitly supersedes the earlier PSK-based handshake (BLAKE2b-128 auth tags, `K = BLAKE2b-256(PSK || session_id || "cask0")`, no DH) documented in `doc/design/net-session-init-design.md` and the `architecture.md` overview, which it calls out by name as "the previous PSK-based design."

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [overview-and-identity](../sections/cask--net-crypto--overview-and-identity.md) | networking | current |
| [authorization-member-table](../sections/cask--net-crypto--authorization-member-table.md) | networking, capability-security | current |
| [noise-ik-handshake](../sections/cask--net-crypto--noise-ik-handshake.md) | networking | current |
| [transport-keys-and-forward-secrecy](../sections/cask--net-crypto--transport-keys-and-forward-secrecy.md) | networking | current |
| [encrypted-packet-and-replay](../sections/cask--net-crypto--encrypted-packet-and-replay.md) | networking | current |
| [primitives-threat-model-and-lifecycle](../sections/cask--net-crypto--primitives-threat-model-and-lifecycle.md) | networking | current |

## Provenance

- Repository default branch `main`; file last modified 2026-02-14 by Kris Kowal.
- **Supersession**: this document is the forward authority on casknet session cryptography. The PSK-handshake material in `cask--net-session-init-design--psk-handshake-packet-formats` is marked `superseded` and points here. The architecture overview's Layer 1 (`cask--architecture--layers-0-1-block-transfer-and-session`) describes the same PSK form and is soft-flagged with a `notes:` pointer to this reconciliation; it remains useful as a layered overview.
- The `cryptography.md` design doc (the "Option A (PSK) / Option B (DH)" minimal proposal referenced from net-session-init-design) was ingested cycle 4 (`scholar-ingest-cask-3`, 2026-06-24) — see `cask--cryptography.md`. net-crypto.md is the realization of its Option B (DH) direction as a full Noise IK handshake; `cask--cryptography--option-b-one-way-dh` and `cask--cryptography--option-a-pre-shared-secret` cross-link here.

Source: [doc/design/net-crypto.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/net-crypto.md) at commit `cdb975d8`.
