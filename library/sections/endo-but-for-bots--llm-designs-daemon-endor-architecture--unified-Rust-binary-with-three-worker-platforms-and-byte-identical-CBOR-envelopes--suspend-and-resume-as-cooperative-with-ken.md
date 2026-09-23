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
title: §Suspend-and-resume-as-cooperative-with-Ken
parent: endo-but-for-bots--llm-designs-daemon-endor-architecture--unified-Rust-binary-with-three-worker-platforms-and-byte-identical-CBOR-envelopes
---

§Cycle-162's-Ken-protocol-assessment named §transactional-
turns as one of seven Ken properties. The §endor-suspend-
and-resume implements §worker-level-checkpoint-and-restore
that maps to Ken's §atomic-checkpoint-before-transmit:

| Ken property | endor implementation |
|--------------|---------------------|
| Transactional turns | Cycle 162 ocap-kernel; here implicit via envelope-at-a-time |
| Output validity | Cycle 162 ocap-kernel; here: snapshot-after-quiesce |
| Deferred transmission | Cycle 162 ocap-kernel; here: outbox queue |
| Atomic checkpoint | §This-design's-CAS-stream-then-rename |
| Local recovery | §This-design's-resume-from-CAS |

§Endor-implements-Ken-properties-implicitly via the
suspend/resume + envelope routing.

§Synthesis-target: future endor work could §adopt-Ken-
vocabulary explicitly (cycle 162's §adopt-vocabulary-not-
implementation guidance).
