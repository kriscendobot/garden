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
title: §Tier-1 borrowing
parent: endo-but-for-bots--llm-designs-daemon-endo-rust-sqlite--re-prepare-instead-of-caching-Statement-and-FFI-tag-encoding-confined-to-internal-plumbing-and-passable-by-construction
---

- §passable-by-construction-discipline (host-function-API
  returns values that are passable across SES boundaries
  without further encoding)
- §strictest-default-removes-a-mode-flag (where the strict
  version is correct for all inputs, eliminate the mode-
  flag)
- §user-facing-clean-API-with-FFI-tags-confined-to-internal-
  plumbing
- §store-the-recipe-not-the-instance (workaround for self-
  referential borrow; defer instantiation when cheap)
- §explicit-lock-ordering-discipline (named in prose, not
  just in comment)
- §three-pragma-bundle for sqlite-open (WAL + foreign_keys=ON
  + busy_timeout)
- §two-step-cleanup-with-retain-cascade
- §sync-by-construction-when-the-substrate-is-sync
- §lean-API-don't-add-API-when-existing-API-suffices
- §bundled-Cargo-feature for self-contained-binary
- §Supersedes-field-in-metadata for §explicit-prior-
  relationship-tracking (the cycle-192 lesson-learned
  applied)
- §phase-1-scaffold + §phase-2-smoke-test + §phase-N-
  integration-test rhythm
