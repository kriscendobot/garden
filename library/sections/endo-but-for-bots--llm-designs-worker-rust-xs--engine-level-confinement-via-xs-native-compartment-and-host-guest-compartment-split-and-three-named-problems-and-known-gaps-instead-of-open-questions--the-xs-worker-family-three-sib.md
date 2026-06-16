---
title: §The XS-worker family — three sibling designs at different abstraction layers
source: endo-but-for-bots designs/worker-rust-xs.md
source-slug: endo-but-for-bots--llm-designs-worker-rust-xs
ingest-cycle: 200
ingest-date: 2026-06-06
lane: designs
status: Not Started (2026-03-23 created; predecessor to cycle 176 daemon-endor-architecture and cycle 178 daemon-xs-worker-snapshot)
author: Kris Kowal (prompted)
related:
  - endo-but-for-bots--llm-designs-daemon-endor-architecture (cycle 176; the Rust supervisor architecture that this design's worker-process slots into)
  - endo-but-for-bots--llm-designs-daemon-xs-worker-snapshot (cycle 178; the snapshot/resume design for these workers)
  - endo-but-for-bots--llm-designs-daemon-xs-worker-debugger (cycle 182; six-layer XML pass-through debugger for these workers)
  - endo-but-for-bots--llm-designs-daemon-xs-worker-metering (cycle 184; admission-control metering)
  - endo-but-for-bots--llm-designs-daemon-rust-xs-performance (cycle 188; three-variant benchmark of these workers)
  - endo-but-for-bots--llm-designs-daemon-engo-supervisor (cycle 192; the §unrealized-Go-predecessor that this design's Rust choice supplanted)
  - endo-but-for-bots--llm-designs-endo-posix-sandbox (cycle 190; the cap-std-equivalent in user-space sandboxing)
  - endo-but-for-bots--llm-designs-platform-fs (the §packages/platform substrate that gets the new fs-rust adapter)
keywords:
  - engine-level-confinement vs SES-shim-source-rewriting
  - host-compartment vs guest-compartment split
  - cap-std backed powers (capability-based I/O at syscall level)
  - three-numbered-problems each with named defense
  - in-process-host-functions-not-IPC
  - worker-process-not-supervisor-process (supervisor stays thin)
  - heterogeneous-workers (supervisor supports Node.js + Rust/XS)
  - pre-compiled-bytecode for Endo modules (eliminates parse overhead at startup)
  - eight Design Decisions canonical format
  - six Implementation Phases with L/M/S effort sizing
  - Known-Gaps (5 items) instead of Open-Questions
  - Prompt-section preserves discard-prior-design narrative
  - ASCII-architecture-diagram with three-process boxes
  - bindgen-generated Rust bindings to XS C API
  - xs-embed Rust crate wrapping XS Machine + Slot + host functions
  - SharedArrayBuffer-deferred with named-future-condition
  - Tokio ↔ XS promise bridge (named-future-work)
  - xsbug TCP adapter for remote debugging
  - cycle 200 milestone
  - thirty-fourth consecutive designs/chat alternation cycle 166-200
parent: endo-but-for-bots--llm-designs-worker-rust-xs--engine-level-confinement-via-xs-native-compartment-and-host-guest-compartment-split-and-three-named-problems-and-known-gaps-instead-of-open-questions
---

Cycle 200's worker-rust-xs.md is the §predecessor of three designs already in the library:

| Cycle | Design | Layer |
| --- | --- | --- |
| 176 | daemon-endor-architecture | Rust supervisor architecture; this design's supervisor-host slot |
| 178 | daemon-xs-worker-snapshot | suspend/resume via CAS streaming; depends on this design's worker shape |
| 182 | daemon-xs-worker-debugger | six-layer XML pass-through debugger; the `xsbug` integration this design names as a gap |
| 184 | daemon-xs-worker-metering | admission-control metering; integrates with this design's worker shape |
| 188 | daemon-rust-xs-performance | three-variant benchmark of these workers; the empirical follow-up |

§This-design-is-the-foundational-predecessor for the entire XS-worker family. §The-§Known-Gaps-section names the precursors of cycles 182 (xsbug), 184 (metering implicit in async I/O model), 188 (memory model + performance characterization).

§The-supplant-pattern: §worker-rust-xs (cycle 200, Not Started) → §daemon-endor-architecture (cycle 176, Active) carries this design's worker into the larger Rust supervisor architecture. §This-design's-supervisor-slot is §inter-worker-routing-only; §cycle-176's-supervisor adds the §three-worker-platforms-with-byte-identical-CBOR-envelopes generalization.

§Borrowable-pattern: §foundational-design-with-named-Known-Gaps-that-spawn-sibling-designs. §The-Known-Gaps-section is §a-roadmap-for-future-designs (this design's 5 gaps spawn 3 named sibling designs in cycles 182/184/188).
