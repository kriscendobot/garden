---
title: CAS Couples Read and Write
source: doc/design/cell-capabilities.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-17
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [capability-security]
status: current
---

Abstract: Why "write implies read" for cells, and why the only honest attenuation direction is from read+write down to read-only. Cell mutation uses compare-and-swap `CompareAndSwap(old, new)`: the caller must supply `old`, the current value, and with 256-bit hashes guessing it is not feasible. Anyone who can CAS a cell must first read it, so a "write-only" cell type would be dishonest. Two alternatives that would make write-only meaningful were considered and rejected: a non-conditional blind write (breaks atomicity, concurrent writers silently overwrite each other) and server-mediated mutation (forces the server to understand content semantics, violating the dumb-block-store principle).

Cell mutation uses compare-and-swap: `CompareAndSwap(old, new)`. The caller must supply `old`, the current value. Without knowing the current value, the caller cannot construct a valid CAS. With 256-bit hashes, guessing is not feasible.

Consequence: **write access to a cell implies read access.** Anyone who can CAS a cell must first read it to learn the current value. A "write-only" cell type would be dishonest: the holder would need to read the cell to write it, making the read restriction unenforceable.

Alternatives were considered and rejected:

- **Blind write (SET)**: A non-conditional write that replaces the value regardless of the current state. This would make write-only meaningful, but it breaks atomicity: concurrent blind writers silently overwrite each other. The whole point of CAS is to prevent lost updates.
- **Server-mediated mutation**: The server applies a mutation function on the caller's behalf, handling the read-CAS loop internally. But this requires the server to understand content semantics (directory structure, etc.), violating the principle that the server is a dumb block store.

This invariant is what makes the attenuation lattice one-directional: a cell reference can be attenuated from read+write down to read-only, never the reverse, and never to write-only. See [information-hiding-and-honest-attenuations](cask--cell-capabilities--information-hiding-and-honest-attenuations.md) for the hash-field reasoning this builds on.

Source: [doc/design/cell-capabilities.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/cell-capabilities.md) at commit `cdb975d8`.
