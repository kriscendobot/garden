---
section: content-address-store-as-supervisor-owned-subsystem-with-typed-content-retain-release-and-background-mark-sweep-gc
source: endo-but-for-bots--llm-designs-daemon-cas-management
topics: [daemon]
status: current
title: The §five implementation phases
parent: endo-but-for-bots--llm-designs-daemon-cas-management--content-address-store-as-supervisor-owned-subsystem-with-typed-content-retain-release-and-background-mark-sweep-gc
---

The §Implementation phases section breaks the work into five
phases:

1. **ContentStore struct + basic verbs** (cas-store / cas-fetch
   / cas-has).
2. **Retain/release + metadata** (.meta sidecar + ref counts).
3. **Tree type** (tree JSON + store_tree + list_tree +
   fetch_from_tree).
4. **Garbage collection** (mark/sweep + cas-gc verb + endor gc
   CLI).
5. **JS manager integration** (replacing `makeContentStore()`
   in `daemon_bootstrap.js` with Rust CAS verbs).

The §Status block confirms phases 1-4 are *Implemented*;
phase 5 is *Remaining*.
