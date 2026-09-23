---
title: §The Prompt section — §discard-prior-design narrative preserved
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

> I would like to discard this design and try another approach. It occurs to me that keeping the supervisor as a thin backbone for inter-worker communication is probably correct and that making it responsible for all I/O would become a bottleneck. This is not the migration path away from Node.js we need.
>
> Instead, we need a worker process in rust, using the same libraries, to provide I/O to an alternative JavaScript engine or possibly bindings to multiple engines, including Wasm. This would allow us to minimize copies and piping information between processes, even possibly using shared array buffers and atomics to coordinate between the @endo/platform API and the rust runtime environment.
>
> Then, the question becomes a choice of JavaScript engine. XS has native compartments and no JIT, so is generally more trustworthy, but slow and would require an intervention to be debuggable. V8 is very well established.
>
> I think we have to try XS simply because of Compartment support, as we can use that to hide host APIs from the guest program.

§The-Prompt-section-preserves-the-discard-prior-design-narrative. §Three-arguments-named:
1. §Keeping-the-supervisor-as-a-thin-backbone-for-inter-worker-communication is the correct shape;
2. §Making-the-supervisor-responsible-for-all-I/O-would-become-a-bottleneck;
3. §Choose-XS-simply-because-of-Compartment-support — §to-hide-host-APIs-from-the-guest-program.

§The-design-is-explicit-about-its-own-displacement: §"discard-this-design-and-try-another-approach" — the maintainer is naming §what-this-design-replaces, not just §what-this-design-proposes. §Honest-design-evolution-in-the-Prompt-section.

§Sibling-pattern to cycles 178 (Revised-scope-2026-04-15), 198 (three-revision-pivots), 197 (honest-design-evolution-in-the-README), 196 (inline-co-author-quote-blocks), 192 (implicit-supersedes-lesson-learned), 200-retention-path (Reference-at-landing). §This-cycle's-shape is §discard-and-replace narrated in the Prompt — §at-prompting-time evolution.
