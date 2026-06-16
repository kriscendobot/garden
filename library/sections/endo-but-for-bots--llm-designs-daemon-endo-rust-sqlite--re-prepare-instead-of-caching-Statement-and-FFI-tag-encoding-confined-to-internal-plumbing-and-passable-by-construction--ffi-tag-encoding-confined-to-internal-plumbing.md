---
source: designs/daemon-endo-rust-sqlite.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_url: https://github.com/endojs/endo-but-for-bots/blob/llm/designs/daemon-endo-rust-sqlite.md
section_kind: design
ingested: 2026-06-05
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - daemon
  - persistence
status_at_ingest: Complete
genre: §endo-but-for-bots-design §host-function-package-for-XS-rust
cycle: 194
lane: designs
status: current
title: §FFI-tag-encoding-confined-to-internal-plumbing
parent: endo-but-for-bots--llm-designs-daemon-endo-rust-sqlite--re-prepare-instead-of-caching-Statement-and-FFI-tag-encoding-confined-to-internal-plumbing-and-passable-by-construction
---

§Parameters-JS-to-Rust:

```
| JS type | FFI JSON encoding | Rust conversion |
|---------|-------------------|-----------------|
| `null` | `null` | NULL |
| `boolean` | `true` / `false` | INTEGER (1 / 0) |
| `number` | number | REAL |
| `string` | string | TEXT |
| `bigint` | `{"$bigint": "123"}` | INTEGER |
| `Uint8Array` | `{"$bytes": "<base64>"}` | BLOB |
```

§Six-encoding-rows: §four-pass-natively (null/boolean/number/
string) + §two-tagged ({"$bigint": ...} + {"$bytes": ...}).

§The-`$bigint` tag is needed because §JSON-cannot-represent-
bigint-natively. §The-`$bytes` tag is needed because §JSON-
cannot-represent-Uint8Array-natively.

§The-`encodeValue` / `decodeValue` / `decodeRow` JS helpers
handle the encoding at the §FFI-boundary; the rest of the JS
wrapper sees clean values.

§Compare-to-cycle-191-zip's §u-helper for §canonical-zip-
signatures. §Both-are-§internal-encoding-helpers that compress
boilerplate.

§Compare-to-cycle-189-marshal-justin's §eleven-qclass-cases
(undefined / NaN / Infinity / -Infinity / bigint / @@asyncIterator
/ symbol / tagged / slot / hilbert / error). §Cycle-194-sqlite-
needs-only-two-tags because the input domain is constrained
to SQLite's five-type-system.

§Design-Decision-3-named-explicitly: "Internal FFI uses
`$bigint` / `$bytes` tags in JSON. JSON cannot represent
bigint or binary natively. The tags are confined to the FFI
layer — the JS wrapper converts them to/from native types.
This is simpler than constructing XS typed arrays from Rust
via low-level slot manipulation."

§The-§simpler-than-low-level-slot-manipulation reason names
the alternative-that-was-rejected. §A-rust-side-could-have-
constructed-XS-Uint8Arrays-directly via FFI slot manipulation
(cycle 169 atomics.js has similar low-level work); §the-
design-chose-JSON-tags-as-the-simpler-tradeoff.
