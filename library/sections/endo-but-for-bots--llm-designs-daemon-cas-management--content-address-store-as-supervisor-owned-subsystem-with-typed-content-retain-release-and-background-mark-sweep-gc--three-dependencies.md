---
section: content-address-store-as-supervisor-owned-subsystem-with-typed-content-retain-release-and-background-mark-sweep-gc
source: endo-but-for-bots--llm-designs-daemon-cas-management
topics: [daemon]
status: current
title: §Three dependencies
parent: endo-but-for-bots--llm-designs-daemon-cas-management--content-address-store-as-supervisor-owned-subsystem-with-typed-content-retain-release-and-background-mark-sweep-gc
---

The §Dependencies table:

| Design | Relationship |
|--------|-------------|
| `daemon-content-store-gc` | **Supersedes**: this design replaces the JS-side GC approach with a Rust-native implementation |
| `daemon-xs-worker-snapshot` | **Integrates**: snapshots become typed CAS entries with retain/release |
| `daemon-endor-architecture` | **Extends**: supervisor gains CAS management responsibility |

The §supersedes-replaces relationship: this design *replaces* an
earlier JS-side GC approach. Cycle 78's `daemon-content-store-gc`
(if I've already ingested it — checking) was the JS approach;
this design moves it to Rust.

The §integrates-with-snapshot: snapshots (cycle 113's
familiar-daemon-bundling notes XS snapshots) become first-class
CAS entries with retain/release.

The §extends-endor-architecture: the (still-unindexed)
`daemon-endor-architecture` design is the broader Rust
supervisor frame.
