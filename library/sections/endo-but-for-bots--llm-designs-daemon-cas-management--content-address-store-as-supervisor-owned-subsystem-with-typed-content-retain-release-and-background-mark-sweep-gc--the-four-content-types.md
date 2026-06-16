---
section: content-address-store-as-supervisor-owned-subsystem-with-typed-content-retain-release-and-background-mark-sweep-gc
source: endo-but-for-bots--llm-designs-daemon-cas-management
topics: [daemon]
status: current
title: The §four content-types
parent: endo-but-for-bots--llm-designs-daemon-cas-management--content-address-store-as-supervisor-owned-subsystem-with-typed-content-retain-release-and-background-mark-sweep-gc
---

The §Content types table:

| Type | Description |
|------|-------------|
| `blob` | Opaque byte sequence (default) |
| `snapshot` | XS machine snapshot (has signature header) |
| `tree` | Directory tree (JSON manifest + child hashes) |
| `archive` | Compartment-map archive (has `compartment-map.json`) |

The §`.meta` sidecar JSON: `{ "type": "blob", "refs": 0 }`. The
§sidecar-not-database discipline (Design Decision 2): *a SQLite
metadata table would be faster for large stores but adds a
dependency and crash-recovery complexity. Sidecar files are
atomic (write-rename), human-readable, and sufficient for the
expected store size (thousands of entries, not millions)*.

The §type-field-is-advisory discipline (Design Decision 4):

> *Content is self-describing (snapshots have signatures,
> archives have manifests). The type field avoids re-parsing but
> is not authoritative — a consumer should validate the content
> regardless.*

The §self-describing-content-as-source-of-truth invariant: the
`.meta` `type` is an *optimization*, not a *security claim*.
