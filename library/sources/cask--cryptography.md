---
source: doc/design/cryptography.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
section_count: 4
status: current
notes: The original "minimal proposal" framing the two secure-transport options. Its Option A (PSK) became the PSK handshake later documented in net-session-init-design.md and now superseded; its Option B (one-way DH) is the conceptual ancestor of net-crypto.md's Noise IK. net-crypto.md is the current authoritative casknet crypto design.
---

> Abstract: CASK's secure-transport design proposal: add confidentiality and integrity to LOAD/STOR over UDP without TLS/DTLS, using Noise-style primitives (x25519, ed25519, ChaCha20-Poly1305, BLAKE2) while keeping messages unordered and storing session state in the CAS until a deadline. It presents two options — **Option A (PSK)**: no handshake, `K = BLAKE2b(PSK || session_id || "cask-v1")`, a `session_id || nonce || ciphertext || tag` envelope with monotonic-counter replay protection; and **Option B (one-way DH)**: a server x25519 keypair, client ephemeral, single-flight establishment, optional ed25519 server auth — plus a recommended rollout (A first, B if no PSK, a two-round mutual-auth/forward-secrecy handshake optional later) and a deadlines-local-vs-wire rule (store absolute Unix-ns locally, send durations on the wire). This doc is the **design predecessor** of `net-crypto.md`: Option A's PSK approach is superseded, and Option B's DH direction is realized as the current Noise IK handshake.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [goal-and-constraints](../sections/cask--cryptography--goal-and-constraints.md) | networking | current |
| [option-a-pre-shared-secret](../sections/cask--cryptography--option-a-pre-shared-secret.md) | networking | current |
| [option-b-one-way-dh](../sections/cask--cryptography--option-b-one-way-dh.md) | networking | current |
| [unordered-noise-and-smallest-path](../sections/cask--cryptography--unordered-noise-and-smallest-path.md) | networking | current |

## Provenance and cross-links

- Repository default branch `main`; file last modified 2026-02-14 by Kris Kowal.
- **Design lineage**: this is the proposal that `doc/design/net-crypto.md` (the authoritative current crypto) realizes. The net-crypto source index (`cask--net-crypto.md`) previously deferred this doc to a follow-on; it is now ingested. Option A (PSK) ↔ the superseded `cask--net-session-init-design--psk-handshake-packet-formats`; Option B (DH) ↔ the current `cask--net-crypto--noise-ik-handshake` and `cask--net-crypto--transport-keys-and-forward-secrecy`.

Source: [doc/design/cryptography.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/cryptography.md) at commit `cdb975d8`.
