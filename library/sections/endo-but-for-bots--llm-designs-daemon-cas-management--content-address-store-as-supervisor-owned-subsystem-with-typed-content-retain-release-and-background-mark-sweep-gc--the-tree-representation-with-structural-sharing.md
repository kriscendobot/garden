---
section: content-address-store-as-supervisor-owned-subsystem-with-typed-content-retain-release-and-background-mark-sweep-gc
source: endo-but-for-bots--llm-designs-daemon-cas-management
topics: [daemon]
status: current
title: The §tree-representation with structural sharing
parent: endo-but-for-bots--llm-designs-daemon-cas-management--content-address-store-as-supervisor-owned-subsystem-with-typed-content-retain-release-and-background-mark-sweep-gc
---

The §Tree representation section shows the JSON shape:

```json
{
  "entries": {
    "compartment-map.json": { "type": "blob", "hash": "sha256:abc123...", "size": 4096 },
    "app-v1.0.0":           { "type": "tree", "hash": "sha256:def456..." },
    "app-v1.0.0/index.js":  { "type": "blob", "hash": "sha256:789abc...", "size": 1234 }
  }
}
```

The §flat-entries-map (Design Decision 5):

> *Tree entries use flat paths with hash references. This
> enables structural sharing between archives that share
> dependencies. The flat `entries` map (not nested objects)
> keeps the JSON simple and the hash stable.*

Two §benefits of flat-paths-with-hash-references:

1. **§Structural sharing** — two archives that share a
   dependency *share the dependency's tree and blob hashes*.
   Content-addressing makes this automatic.

2. **§Stable hash** — *nested objects would change hashes
   based on internal structure*. Flat paths are
   serialization-stable.

Trees are themselves content-addressed (the tree's hash is the
SHA-256 of its JSON serialization), so a tree is a *root for
walking* the content graph.
