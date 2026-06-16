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
title: §Synthesis-target
parent: endo-but-for-bots--llm-designs-daemon-endo-rust-sqlite--re-prepare-instead-of-caching-Statement-and-FFI-tag-encoding-confined-to-internal-plumbing-and-passable-by-construction
---

The §slot-machine-library's persistent-storage-layer (if any)
can §borrow-the-five-type-mapping directly for any §SQL-or-KV-
store-wrapper. §The-§passable-by-construction discipline is
the §canonical-design-constraint for any §host-function-API.

§The-§store-the-recipe-not-the-instance pattern is borrowable
for any §Rust-FFI-or-other-language-binding where §lifetime-
constraints-block-direct-caching. §Defer-instantiation; let
the underlying library cache the heavy work.

§The-§Supersedes-field-in-metadata pattern (cycle 192's §lesson-
learned) is borrowable for §explicit-prior-relationship-
tracking in any design that replaces a prior. §The-metadata-
field-alone-suffices; a §relationship-prose-section is
optional but valuable for §three-named-improvements detail.
