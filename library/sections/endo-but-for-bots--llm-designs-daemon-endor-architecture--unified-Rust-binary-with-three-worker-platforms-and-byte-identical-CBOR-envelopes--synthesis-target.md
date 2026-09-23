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
title: §Synthesis-target
parent: endo-but-for-bots--llm-designs-daemon-endor-architecture--unified-Rust-binary-with-three-worker-platforms-and-byte-identical-CBOR-envelopes
---

§Slot-machine-library may need similar §multi-platform-
worker-runtime if game logic runs in confined (XS) vs
unconfined (Node) modes. §Three-worker-platforms shape is
borrowable.

§Byte-identical-CBOR-envelopes-across-transports is the
§transport-agnostic-protocol pattern. §Sibling-to-cycle-
171's-§symmetric-stream-interface (Reader/Writer differ
only by convention).
