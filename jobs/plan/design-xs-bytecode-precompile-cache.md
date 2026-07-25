---
gate: blocked
blocked_on: endojs/endo-but-for-bots#600
priority: normal
role: designer
posted_by: producer
posted_at: 2026-07-25T06:12:13Z
---

Design: bytecode precompile & content-addressed cache for XS — C and Rust engines.

GATE: blocked on endojs/endo-but-for-bots#600 (xs2rust-endor-engine — port XS to
Rust for endor). Auto-promoted when #600 merges.

Maintainer's premise (2026-07-25): both the C XS engine and the Rust XS engine
(#600) contain the machinery necessary to PRECOMPILE and/or CACHE byte code
compiled from a JavaScript source, KEYED ON A HASH of the source. Produce a design
covering BOTH implementations:
  - Where each engine exposes bytecode compile + load (C XS: its byte-code
    archive/mod machinery; Rust XS: the #600 port's equivalent surface).
  - A content-addressed cache keyed on a hash of the JS source: define the key
    precisely (raw source bytes vs normalized; must it fold in engine build /
    bytecode-format version so a stale entry can't be mis-loaded?).
  - Precompile-ahead vs lazy compile-then-cache; cache location, population,
    invalidation, and eviction.
  - Cross-engine key compatibility: can a C-XS cache entry be reused by Rust XS,
    or are keys engine/format-namespaced? State the invariant.
  - Integration points in endo-but-for-bots / endor.
Deliverable: a design doc (designer role) proposing the precompile+cache design
across both engines, with open questions surfaced. No implementation.
