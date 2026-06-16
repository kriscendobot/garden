---
title: §Host-compartment vs Guest-compartment split
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

**§Host compartment** — outer compartment created by Rust worker at startup. Receives host-provided endowments backed by cap-std:

```
Host compartment endowments:
  FilePowers     → cap-std::fs::Dir handles
  CryptoPowers   → sha2, ed25519-dalek, rand
  NetworkPowers  → cap-net-ext::Pool
  console        → stderr write
  TextEncoder, TextDecoder, URL
  E, Far, makeExo, M (from @endo/captp, @endo/exo, @endo/patterns)
```

**§Guest compartment** — created by host compartment's worker bootstrap per `evaluate`/`makeBundle`/`makeUnconfined`. Receives only endowments daemon explicitly provides:

```
Guest compartment endowments:
  E, Far, makeExo, M
  TextEncoder, TextDecoder, URL
  assert, console
  $id, $cancelled
  ...named values from daemon
```

§No-`FilePowers`,-no-`CryptoPowers`,-no-`NetworkPowers`. §The-guest-has-no-host-API-access. §It-can-only-reach-I/O-through-capabilities-passed-to-it-via-CapTP (the `powers` argument to `make(powers, context)`).

§Same-trust-architecture-as-today's-SES-based-workers, but §enforced-by-the-engine-rather-than-by-source-rewriting. §The-architectural-shift is at the §enforcement-mechanism-axis, not the §architecture-axis.

§Borrowable-pattern: §two-layer-compartment-with-host-API-only-on-outer-layer is §a-canonical-shape for any §guest-evaluation-in-a-confined-environment. §Sibling to cycle 161 daemon-capability-filesystem's §three-layer-architecture (Guest Dir/File / VFS Namespace / Backends) — both designs §layer-confinement.
