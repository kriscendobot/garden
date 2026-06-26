---
source_kind: comment-fragment
source_repo: kriskowal/cask
source_path: net/noise.go
source_line_range: "1-395"
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
comment_subject: The Noise_IK_25519_ChaChaPoly_BLAKE2b handshake implementation for casknet session establishment — the symmetric-state machine and token ladder, the HKDF/HMAC-BLAKE2b/ChaCha20-Poly1305 primitives, and the ed25519↔x25519 key conversion
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-26
ingested_by: scholar
section_count: 3
status: current
notes: |
  Fourth comment-fragment source of the cask corpus (cycle 18), third of the
  net/ package, following net/crypto.go (cycle 16) and net/peer.go (cycles
  17-18). The implementation of the Noise IK handshake the design docs
  (cask--net-crypto, cask--net-session-init-design) and the concept noise-ik-
  session-establishment describe; ingested only the implementation-specific
  clusters (state machine, primitives, key conversion) that add over the design
  coverage, cross-referencing rather than restating.
---

> Abstract: `net/noise.go` (~395 lines) is the from-scratch implementation of `Noise_IK_25519_ChaChaPoly_BLAKE2b`, the two-message handshake that establishes a casknet session. It is the implementation source-of-truth behind the design-doc and concept-level descriptions of casknet session establishment. Three cohesive clusters were ingested: (1) the **handshake state machine** — the IK token ladder (`<- s` pre-message, `-> e, es, s, ss` message 1, `<- e, ee, se` message 2), the `noiseState` chaining-key / handshake-hash / cipher-key triple driven by `mixHash`/`mixKey`, the `encryptAndHash`/`decryptAndHash` transcript discipline, and the `split` that derives two directional transport keys (reversed on the responder); (2) the **cryptographic primitives** — the Noise two-output HKDF built from three HMAC-BLAKE2b invocations, the hand-rolled HMAC-BLAKE2b with its 128-byte block, and the ChaCha20-Poly1305 AEAD whose 12-byte nonce carries the handshake counter little-endian; and (3) the **ed25519↔x25519 key conversion** — the private key via SHA-512-of-seed-plus-clamp and the public key via the birational Montgomery-u map. The file's design rationale (forward secrecy, threat model, packet sizes) lives in the design-doc sources and concept page; this source carries the mechanism.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [noise-ik-handshake-state-machine](../sections/cask--net-noise-go--noise-ik-handshake-state-machine.md) | networking | current |
| [noise-hkdf-and-aead](../sections/cask--net-noise-go--noise-hkdf-and-aead.md) | networking | current |
| [ed25519-x25519-key-conversion](../sections/cask--net-noise-go--ed25519-x25519-key-conversion.md) | networking, capability-security | current |

## Provenance

- Fetched 2026-06-26 from `kriskowal/cask@main` (file-specific commit `cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4`, 2026-02-14, Kris Kowal) via a sparse scratch clone under the bot home.
- Fourth comment-fragment ingest of the cask corpus and third of the `net/` package; follows the root `cask.go` (cycle 15), `net/crypto.go` (cycle 16), and `net/peer.go` (cycles 17-18).
- The `noise.go` comments are the implementation of the Noise IK handshake the design docs (`cask--net-crypto`, `cask--net-session-init-design`) and the concept `noise-ik-session-establishment` describe in prose. The sections cross-reference those rather than restating the design; they capture only the implementation-specific mechanism (state machine, primitives, key conversion).
- The handshake nonce in this file (little-endian, per-stage) is distinct from the big-endian transport replay counter in `cask--net-crypto-go--counter-nonce-and-replay-protection`; the primitives section flags the distinction.
