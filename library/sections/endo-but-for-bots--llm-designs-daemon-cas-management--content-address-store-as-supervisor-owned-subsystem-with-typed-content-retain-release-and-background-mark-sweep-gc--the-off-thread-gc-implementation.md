---
section: content-address-store-as-supervisor-owned-subsystem-with-typed-content-retain-release-and-background-mark-sweep-gc
source: endo-but-for-bots--llm-designs-daemon-cas-management
topics: [daemon]
status: current
title: The §off-thread GC implementation
parent: endo-but-for-bots--llm-designs-daemon-cas-management--content-address-store-as-supervisor-owned-subsystem-with-typed-content-retain-release-and-background-mark-sweep-gc
---

> *GC runs on a dedicated `std::thread` (or
> `tokio::spawn_blocking`) to avoid blocking the supervisor's
> routing loop.*

The §non-blocking-GC discipline: GC could take seconds for a
large store; doing it on the routing thread would freeze
all worker messages. Off-thread (or via `spawn_blocking`)
keeps the routing latency under GC load.
