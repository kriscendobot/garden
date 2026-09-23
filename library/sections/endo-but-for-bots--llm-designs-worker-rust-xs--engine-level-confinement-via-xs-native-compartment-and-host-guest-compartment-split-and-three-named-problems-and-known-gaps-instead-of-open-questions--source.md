---
title: Source
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

- `endo-but-for-bots designs/worker-rust-xs.md` — 540 lines
- Status: **Not Started** (created 2026-03-23)
- Author: Kris Kowal (prompted)
- Cycle 200 of `/loop resume the librarian work.` (designs-lane milestone; alternates from cycle 199's chat-lane @endo/{trampoline,memoize,nat} trio; §thirty-fourth consecutive designs/chat alternation cycle 166-200).

§Pivot-history this cycle: first attempted retention-path-notation (already ingested 6 sections in earlier cycle via `rpn--` short slug); then hardened-url-shim (already ingested 6 sections via `hurl--` short slug); §third-attempt worker-rust-xs.md confirmed genuinely uningested. §Library-protocol-update: §grep-by-source-page-existence-not-section-file-pattern is the safer check.
