---
section: content-address-store-as-supervisor-owned-subsystem-with-typed-content-retain-release-and-background-mark-sweep-gc
source: endo-but-for-bots--llm-designs-daemon-cas-management
topics: [daemon]
status: current
title: The §mark/sweep GC algorithm
parent: endo-but-for-bots--llm-designs-daemon-cas-management--content-address-store-as-supervisor-owned-subsystem-with-typed-content-retain-release-and-background-mark-sweep-gc
---

The §Garbage collection section names a three-step algorithm:

1. **Mark**: scan all live references:
   - Suspended workers: their snapshot hashes
   - Explicit retain counts in `.meta` files
   - Any hash referenced by the JS manager's formula store
     (communicated via a `cas-gc-roots` verb at GC start)

2. **Sweep**: iterate `store-sha256/`, delete entries with zero
   retain count that are not in the live set. *For tree entries,
   recursively check children before deleting the tree*.

3. **Report**: log freed space and entry count.

The §reference-counting-not-tracing discipline (Design Decision
3):

> *Reference counting is simple and deterministic. The retain/
> release protocol maps naturally to worker lifecycles. A
> tracing GC would require enumerating all live references from
> the JS formula store, which is possible but more complex.*

But the §Mark step does also collect roots from the JS manager
(*Any hash referenced by the JS manager's formula store*) — a
*hybrid* shape. The base mechanism is reference-counting; the JS
side contributes roots that count as references for the GC's
purposes.

The §GC concurrency:

> *GC is concurrent — it holds a read lock on the CAS index
> during mark and takes brief write locks during sweep. New
> stores during GC are safe because newly stored content starts
> with refs=0 and will be collected in the next cycle if
> unreferenced.*

The §new-stores-are-safe-during-GC discipline: there's no need
to block stores during GC because *newly stored content starts
with refs=0* — if no one retains it, the next GC cycle will
clean it up. The §eventual-consistency-of-GC pattern: a single
sweep doesn't need to be globally synchronized; missed content
gets caught next time.

The §three-trigger mechanism:
- `cas-gc` control verb from the JS manager
- Configurable timer (e.g., every 10 minutes)
- Explicit `endor gc` CLI subcommand
