---
title: §Eight Design Decisions canonical format
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

1. **§XS-over-V8 for the embedded engine** — XS provides native `Compartment` and `ModuleSource`. The confinement boundary enforced by the engine. V8 faster (JIT) and better debugging (DevTools) but requires SES shim and has larger footprint. §For-confined-workers-running-capability-mediated-code, §engine-speed-matters-less-than-confinement-correctness.
2. **§Worker-process-not-supervisor-process** — supervisor stays thin (routing only); eliminates IPC overhead for I/O.
3. **§In-process-host-functions-not-IPC** — direct C function calls from JS; orders-of-magnitude faster.
4. **§cap-std-for-capability-based-I/O** — Dir handles at startup; path traversal rejected at syscall level.
5. **§Host-compartment-/-guest-compartment-split** — engine-enforced; same architecture as SES workers but engine-level.
6. **§Pre-compiled-bytecode-for-Endo-modules** — eliminates parse overhead at worker startup.
7. **§Node.js-workers-remain-for-development** — Rust/XS is deployment target; supervisor supports heterogeneous workers.
8. **§SharedArrayBuffer-deferred** — could be used in host compartment for zero-copy coordination; forbidden in guest compartments (SES policy); §deferred-until-profiling-shows-copy-overhead-matters.

§Eight-Design-Decisions canonical format (sibling to cycles 184/188/192/194/196/198/200-hardened-url-shim). §Each-decision-names-the-alternative-rejected (V8 / supervisor-process / IPC / ad-hoc / mixed / runtime-parse / Rust/XS-only / now-shared-buffers) with §rationale.

§Decision-8-§SharedArrayBuffer-deferred is §a-§future-named-with-condition: §deferred-until-profiling-shows-copy-overhead-matters. §Named-future-work-with-named-trigger.
