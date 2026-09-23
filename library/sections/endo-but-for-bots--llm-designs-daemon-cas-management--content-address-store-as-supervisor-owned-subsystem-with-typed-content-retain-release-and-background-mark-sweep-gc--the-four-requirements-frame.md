---
section: content-address-store-as-supervisor-owned-subsystem-with-typed-content-retain-release-and-background-mark-sweep-gc
source: endo-but-for-bots--llm-designs-daemon-cas-management
topics: [daemon]
status: current
title: The §four-requirements frame
parent: endo-but-for-bots--llm-designs-daemon-cas-management--content-address-store-as-supervisor-owned-subsystem-with-typed-content-retain-release-and-background-mark-sweep-gc
---

The §What is the Problem Being Solved section identifies four
gaps with the current flat-directory CAS:

1. **Typed content** — distinguish directory trees from blobs,
   compartment-map archives from snapshots, so higher-level
   operations can dispatch on type.
2. **Read/write verbs** — workers can store and retrieve content
   *through the envelope bus*, without direct filesystem access.
3. **Retain/release protocol** — reference-counted GC roots
   workers can hold to keep content alive.
4. **Off-thread garbage collection** — background sweep that
   removes unreferenced content *without blocking the main
   supervisor loop*.

The §current-state: *the daemon's content-addressable store
(CAS) at `{statePath}/store-sha256/` is currently a flat
directory of opaque blobs*. *Workers write snapshots to it and
read them back, but the supervisor has no structured API for CAS
operations and no awareness of what kind of content each hash
represents.* And *there is no garbage collection — blobs
accumulate forever*.
