---
source: designs/daemon-endor-architecture.md
source_repo: endojs/endo-but-for-bots
source_url: https://github.com/endojs/endo-but-for-bots/blob/llm/designs/daemon-endor-architecture.md
source_path: designs/daemon-endor-architecture.md
source_branch: llm
section_kind: design
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - daemon
  - tooling
  - hardened-javascript
genre: §endo-but-for-bots-design
cycle: 176
lane: designs
status: current
title: §CESU-8-surrogate-pair-encoding
parent: endo-but-for-bots--llm-designs-daemon-endor-architecture--unified-Rust-binary-with-three-worker-platforms-and-byte-identical-CBOR-envelopes
---

> *XS stores strings in CESU-8 (surrogate-pair encoding
> for supplementary characters). `cesu8.rs` provides
> encode/decode between UTF-8 and CESU-8. Fast path: if no
> 4-byte UTF-8 sequences, CESU-8 == UTF-8.*

§Engine-specific-string-encoding requires §boundary-
translation. §Most-strings-are-ASCII-or-BMP — §fast-path
when no 4-byte UTF-8 sequences.

§Honest-implementation-detail: §XS-isn't-UTF-8-native;
§the-Rust-bindings-handle-the-difference.
