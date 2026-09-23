---
title: §Three-numbered-problems each with named defense
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

The §Problem-section enumerates three problems, each with §a-named-architectural-axis:

1. **§The-SES-shim-is-a-compatibility-layer-not-a-boundary** — V8 has no native Compartment; the shim emulates confinement by rewriting source text and controlling the global scope, but cannot enforce module-level isolation at the engine level. §XS-implements-Compartment-and-ModuleSource-natively.
2. **§Every-I/O-operation-crosses-a-process-boundary** — Workers communicate via CapTP over pipes; daemon calls into Node.js built-ins for all I/O. Under Go and Rust supervisors, workers still run Node.js — the supervisor only mediates spawning and message routing.
3. **(third problem, named but not extracted; about deployment footprint or similar)** — see source for full text.

§Each-problem-is-addressed-by-a-specific-architectural-move:
- Problem 1 → §XS-native-Compartment (engine-level enforcement vs source-rewriting).
- Problem 2 → §in-process-host-functions-not-IPC (cap-std backed powers inside worker).
- Problem 3 → §worker-process-not-supervisor-process.

§Three-numbered-problems-with-three-named-defenses sibling to cycle 196 endoclaw's §three-named-attacks-with-three-structural-defenses, cycle 200 hardened-url-shim's §two-specific-hazards-with-named-defense. §Symmetric-problem/defense-enumeration-as-Problem-section-shape.
