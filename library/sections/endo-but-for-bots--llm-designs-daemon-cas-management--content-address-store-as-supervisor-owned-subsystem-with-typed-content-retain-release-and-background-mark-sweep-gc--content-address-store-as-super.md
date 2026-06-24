---
section: content-address-store-as-supervisor-owned-subsystem-with-typed-content-retain-release-and-background-mark-sweep-gc
source: endo-but-for-bots--llm-designs-daemon-cas-management
topics: [daemon]
status: current
title: Content-address store as supervisor-owned subsystem with typed content, retain/release, and background mark/sweep GC
parent: endo-but-for-bots--llm-designs-daemon-cas-management--content-address-store-as-supervisor-owned-subsystem-with-typed-content-retain-release-and-background-mark-sweep-gc
---

> *The CAS is a shared resource accessed by all workers. A
> dedicated worker would require every CAS operation to cross
> the envelope bus twice (request + response), adding latency to
> module loading and snapshot operations.*
>
> — `designs/daemon-cas-management.md` §Supervisor-owned vs. worker-owned

`daemon-cas-management.md` (398 lines, *In Progress* status,
created 2026-04-17) makes the daemon's content-addressable store
(CAS) a *first-class subsystem of endor* (cycle 119's Rust
supervisor). Phases 1-4 are implemented in `rust/endo/src/cas.rs`;
Phase 5 (JS manager integration replacing `makeContentStore()`)
remains.
