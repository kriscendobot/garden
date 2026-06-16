---
title: §Borrowable patterns (tier-1)
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

1. **§Engine-level-confinement-via-XS-native-Compartment-vs-SES-shim-source-rewriting** — when §the-shim-is-a-compatibility-layer-not-a-boundary, §pick-an-engine-with-native-support.
2. **§Host-compartment-vs-guest-compartment-split-with-cap-std-backed-powers** — §two-layer-compartment with §host-API-only-on-outer-layer; §guest-reaches-I/O-only-through-capabilities-passed-via-CapTP.
3. **§Three-numbered-problems-each-with-named-defense** — §Problem-section-shape with §symmetric-problem/defense-enumeration.
4. **§ASCII-architecture-diagram-with-three-process-boxes** — §nested-confinement (process / compartment / sub-compartment) visualized.
5. **§cap-std-as-the-capability-substrate** at the §syscall-level for §kernel-enforced-FS-confinement.
6. **§In-process-host-functions-not-IPC** — §direct-C-function-calls-from-JS when §trust-boundary-is-not-the-process-boundary.
7. **§Worker-process-not-supervisor-process** — §supervisor-stays-thin for §routing-only; §eliminates-IPC-bottleneck.
8. **§Heterogeneous-workers-via-byte-identical-envelope-layer** — §supervisor-already-supports-this discipline; §different-deployment-targets-can-pick-different-workers.
9. **§Pre-compiled-bytecode-for-Endo-modules** at build time — §eliminates-parse-overhead-at-runtime; §source-positions-preserved-in-debug-builds.
10. **§Eight-Design-Decisions canonical format** with §each-decision-names-the-alternative-rejected.
11. **§L/M/S-effort-sizing-per-phase** for §multi-phase-design.
12. **§Known-Gaps-as-checklist** when the design is §waiting-on-empirical-verification rather than §waiting-on-decision.
13. **§Prompt-section-preserves-discard-prior-design-narrative** — §explicit-naming-of-what-this-design-replaces in the §maintainer's-own-words.
14. **§SharedArrayBuffer-deferred-with-named-condition** ("until profiling shows copy overhead matters") for §future-work-with-named-trigger.
15. **§Foundational-design-with-named-Known-Gaps-that-spawn-sibling-designs** — §the-Known-Gaps-section-is-a-roadmap-for-future-designs.
16. **§Engine-speed-matters-less-than-confinement-correctness for confined workers** — §a-named-priority-axis for §JIT-vs-AOT-engine-choice.
