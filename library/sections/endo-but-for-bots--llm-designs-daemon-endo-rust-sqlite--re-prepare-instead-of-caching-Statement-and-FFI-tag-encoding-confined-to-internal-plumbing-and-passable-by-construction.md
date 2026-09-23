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
kind: index
section_count: 19
---

Sections:

- [Re-prepare instead of caching Statement (avoid self-referential borrow), FFI tag encoding confined to internal plumbing, INTEGER-always-bigint, and passable-by-construction discipline](endo-but-for-bots--llm-designs-daemon-endo-rust-sqlite--re-prepare-instead-of-caching-Statement-and-FFI-tag-encoding-confined-to-internal-plumbing-and-passable-by-construction--re-prepare-instead-of-caching.md)
- [§The-§passable-by-construction-discipline (the design anchor)](endo-but-for-bots--llm-designs-daemon-endo-rust-sqlite--re-prepare-instead-of-caching-Statement-and-FFI-tag-encoding-confined-to-internal-plumbing-and-passable-by-construction--the-passable-by-construction-discipline-the-design-anchor.md)
- [§INTEGER-always-bigint (Decision 1)](endo-but-for-bots--llm-designs-daemon-endo-rust-sqlite--re-prepare-instead-of-caching-Statement-and-FFI-tag-encoding-confined-to-internal-plumbing-and-passable-by-construction--integer-always-bigint-decision-1.md)
- [§BLOB-as-Uint8Array-not-sentinel (Decision 2)](endo-but-for-bots--llm-designs-daemon-endo-rust-sqlite--re-prepare-instead-of-caching-Statement-and-FFI-tag-encoding-confined-to-internal-plumbing-and-passable-by-construction--blob-as-uint8array-not-sentinel-decision-2.md)
- [§Re-prepare-instead-of-caching-Statement (the §workaround-for-self-referential-borrow)](endo-but-for-bots--llm-designs-daemon-endo-rust-sqlite--re-prepare-instead-of-caching-Statement-and-FFI-tag-encoding-confined-to-internal-plumbing-and-passable-by-construction--re-prepare-instead-of-caching.md)
- [§FFI-tag-encoding-confined-to-internal-plumbing](endo-but-for-bots--llm-designs-daemon-endo-rust-sqlite--re-prepare-instead-of-caching-Statement-and-FFI-tag-encoding-confined-to-internal-plumbing-and-passable-by-construction--ffi-tag-encoding-confined-to-internal-plumbing.md)
- [§The-§nine-host-functions (the API surface)](endo-but-for-bots--llm-designs-daemon-endo-rust-sqlite--re-prepare-instead-of-caching-Statement-and-FFI-tag-encoding-confined-to-internal-plumbing-and-passable-by-construction--the-nine-host-functions-the-api-surface.md)
- [§Database-open-defaults (the §three-pragma-bundle)](endo-but-for-bots--llm-designs-daemon-endo-rust-sqlite--re-prepare-instead-of-caching-Statement-and-FFI-tag-encoding-confined-to-internal-plumbing-and-passable-by-construction--database-open-defaults-the-three-pragma-bundle.md)
- [§Cleanup-on-database-close (the §retain-cascade pattern)](endo-but-for-bots--llm-designs-daemon-endo-rust-sqlite--re-prepare-instead-of-caching-Statement-and-FFI-tag-encoding-confined-to-internal-plumbing-and-passable-by-construction--cleanup-on-database-close-the-retain-cascade-pattern.md)
- [§Synchronous-JS-API (Decision 6)](endo-but-for-bots--llm-designs-daemon-endo-rust-sqlite--re-prepare-instead-of-caching-Statement-and-FFI-tag-encoding-confined-to-internal-plumbing-and-passable-by-construction--synchronous-js-api-decision-6.md)
- [§Transactions-via-exec-no-special-API (the §lean-API discipline)](endo-but-for-bots--llm-designs-daemon-endo-rust-sqlite--re-prepare-instead-of-caching-Statement-and-FFI-tag-encoding-confined-to-internal-plumbing-and-passable-by-construction--transactions-via-exec-no-special-api-the-lean-api-discipline.md)
- [§Cargo-dependency-with-bundled-feature](endo-but-for-bots--llm-designs-daemon-endo-rust-sqlite--re-prepare-instead-of-caching-Statement-and-FFI-tag-encoding-confined-to-internal-plumbing-and-passable-by-construction--cargo-dependency-with-bundled-feature.md)
- [§Nine-Design-Decisions (the §canonical-format)](endo-but-for-bots--llm-designs-daemon-endo-rust-sqlite--re-prepare-instead-of-caching-Statement-and-FFI-tag-encoding-confined-to-internal-plumbing-and-passable-by-construction--nine-design-decisions-the-canonical-format.md)
- [§Files-to-create-or-modify (the §working-copy-map)](endo-but-for-bots--llm-designs-daemon-endo-rust-sqlite--re-prepare-instead-of-caching-Statement-and-FFI-tag-encoding-confined-to-internal-plumbing-and-passable-by-construction--files-to-create-or-modify-the-working-copy-map.md)
- [§Six-implementation-phases (all Complete)](endo-but-for-bots--llm-designs-daemon-endo-rust-sqlite--re-prepare-instead-of-caching-Statement-and-FFI-tag-encoding-confined-to-internal-plumbing-and-passable-by-construction--six-implementation-phases-all-complete.md)
- [§Supersedes-record-pattern (the §explicit-supersedes that cycle 192 lacked)](endo-but-for-bots--llm-designs-daemon-endo-rust-sqlite--re-prepare-instead-of-caching-Statement-and-FFI-tag-encoding-confined-to-internal-plumbing-and-passable-by-construction--supersedes-record-pattern-the.md)
- [§Cohesion notes](endo-but-for-bots--llm-designs-daemon-endo-rust-sqlite--re-prepare-instead-of-caching-Statement-and-FFI-tag-encoding-confined-to-internal-plumbing-and-passable-by-construction--cohesion-notes.md)
- [§Tier-1 borrowing](endo-but-for-bots--llm-designs-daemon-endo-rust-sqlite--re-prepare-instead-of-caching-Statement-and-FFI-tag-encoding-confined-to-internal-plumbing-and-passable-by-construction--tier-1-borrowing.md)
- [§Synthesis-target](endo-but-for-bots--llm-designs-daemon-endo-rust-sqlite--re-prepare-instead-of-caching-Statement-and-FFI-tag-encoding-confined-to-internal-plumbing-and-passable-by-construction--synthesis-target.md)
