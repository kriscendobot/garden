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
kind: index
section_count: 23
---

Sections:

- [Unified Rust binary with three worker platforms and byte-identical CBOR envelopes](endo-but-for-bots--llm-designs-daemon-endor-architecture--unified-Rust-binary-with-three-worker-platforms-and-byte-identical-CBOR-envelopes--unified-rust-binary-with-three-worker-platforms-and-byte-identical-cbor-envelope.md)
- [§Why-the-Rust-supervisor](endo-but-for-bots--llm-designs-daemon-endor-architecture--unified-Rust-binary-with-three-worker-platforms-and-byte-identical-CBOR-envelopes--why-the-rust-supervisor.md)
- [§Two-crate-decomposition](endo-but-for-bots--llm-designs-daemon-endor-architecture--unified-Rust-binary-with-three-worker-platforms-and-byte-identical-CBOR-envelopes--two-crate-decomposition.md)
- [§Binary-as-multi-tool with six subcommands](endo-but-for-bots--llm-designs-daemon-endor-architecture--unified-Rust-binary-with-three-worker-platforms-and-byte-identical-CBOR-envelopes--binary-as-multi-tool-with-six-subcommands.md)
- [§Three-worker-platforms (the centerpiece)](endo-but-for-bots--llm-designs-daemon-endor-architecture--unified-Rust-binary-with-three-worker-platforms-and-byte-identical-CBOR-envelopes--three-worker-platforms-the-centerpiece.md)
- [§Byte-identical-CBOR-envelopes across transports](endo-but-for-bots--llm-designs-daemon-endor-architecture--unified-Rust-binary-with-three-worker-platforms-and-byte-identical-CBOR-envelopes--byte-identical-cbor-envelopes-across-transports.md)
- [§Manager-must-be-co-resident (hard requirement)](endo-but-for-bots--llm-designs-daemon-endor-architecture--unified-Rust-binary-with-three-worker-platforms-and-byte-identical-CBOR-envelopes--manager-must-be-co-resident-hard-requirement.md)
- [§Pool-of-machine-runner-threads](endo-but-for-bots--llm-designs-daemon-endor-architecture--unified-Rust-binary-with-three-worker-platforms-and-byte-identical-CBOR-envelopes--pool-of-machine-runner-threads.md)
- [§Blocking-call-authorization](endo-but-for-bots--llm-designs-daemon-endor-architecture--unified-Rust-binary-with-three-worker-platforms-and-byte-identical-CBOR-envelopes--blocking-call-authorization.md)
- [§Suspend-resume via CAS streaming](endo-but-for-bots--llm-designs-daemon-endor-architecture--unified-Rust-binary-with-three-worker-platforms-and-byte-identical-CBOR-envelopes--suspend-resume-via-cas-streaming.md)
- [§Unified-runner-four-mode-table](endo-but-for-bots--llm-designs-daemon-endor-architecture--unified-Rust-binary-with-three-worker-platforms-and-byte-identical-CBOR-envelopes--unified-runner-four-mode-table.md)
- [§Suspend-and-resume-as-cooperative-with-Ken](endo-but-for-bots--llm-designs-daemon-endor-architecture--unified-Rust-binary-with-three-worker-platforms-and-byte-identical-CBOR-envelopes--suspend-and-resume-as-cooperative-with-ken.md)
- [§CESU-8-surrogate-pair-encoding](endo-but-for-bots--llm-designs-daemon-endor-architecture--unified-Rust-binary-with-three-worker-platforms-and-byte-identical-CBOR-envelopes--cesu-8-surrogate-pair-encoding.md)
- [§Six-host-power-modules](endo-but-for-bots--llm-designs-daemon-endor-architecture--unified-Rust-binary-with-three-worker-platforms-and-byte-identical-CBOR-envelopes--six-host-power-modules.md)
- [§Five-embedded-JS-bundles via include_str!](endo-but-for-bots--llm-designs-daemon-endor-architecture--unified-Rust-binary-with-three-worker-platforms-and-byte-identical-CBOR-envelopes--five-embedded-js-bundles-via-include-str.md)
- [§Renames-from-kind-to-platform (migration table)](endo-but-for-bots--llm-designs-daemon-endor-architecture--unified-Rust-binary-with-three-worker-platforms-and-byte-identical-CBOR-envelopes--renames-from-kind-to-platform-migration-table.md)
- [§Eleven-endo-crate-modules + §five-xsnap-crate-modules](endo-but-for-bots--llm-designs-daemon-endor-architecture--unified-Rust-binary-with-three-worker-platforms-and-byte-identical-CBOR-envelopes--eleven-endo-crate-modules-five-xsnap-crate-modules.md)
- [§Path-resolution-mirrors-@endo/where](endo-but-for-bots--llm-designs-daemon-endor-architecture--unified-Rust-binary-with-three-worker-platforms-and-byte-identical-CBOR-envelopes--path-resolution-mirrors-endo-where.md)
- [§Three-related-designs](endo-but-for-bots--llm-designs-daemon-endor-architecture--unified-Rust-binary-with-three-worker-platforms-and-byte-identical-CBOR-envelopes--three-related-designs.md)
- [§Gap-revealing-comparison with garden cycles](endo-but-for-bots--llm-designs-daemon-endor-architecture--unified-Rust-binary-with-three-worker-platforms-and-byte-identical-CBOR-envelopes--gap-revealing-comparison-with-garden-cycles.md)
- [§Tier-1 vocabulary borrowing candidates](endo-but-for-bots--llm-designs-daemon-endor-architecture--unified-Rust-binary-with-three-worker-platforms-and-byte-identical-CBOR-envelopes--tier-1-vocabulary-borrowing-candidates.md)
- [§Synthesis-target](endo-but-for-bots--llm-designs-daemon-endor-architecture--unified-Rust-binary-with-three-worker-platforms-and-byte-identical-CBOR-envelopes--synthesis-target.md)
- [§A-complete-implementation-design (Status: Active)](endo-but-for-bots--llm-designs-daemon-endor-architecture--unified-Rust-binary-with-three-worker-platforms-and-byte-identical-CBOR-envelopes--a-complete-implementation-design-status-active.md)
