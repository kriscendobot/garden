---
role: builder
---

Build Phase 3 (directory input) of the `endor run` CAS-archive feature in `endojs/endo-but-for-bots` (M11 design `endor-run-expanded`, PR #600's sibling `endor` Rust daemon work): teach `endor run` to accept a directory path — ingest the directory tree into CAS as blobs + tree manifest (reusing `rust/endo/src/cas_archive.rs` `ingest_archive`), print the root hash, and execute via CAS-backed module loading — landing each increment as its own green commit on the design's `endor` branch. Phases 1–2 (standalone `ContentStore`, ZIP ingest/`--cas`) are done; this is the next unblocked increment and does not touch the XS→Rust VM port orchestration.

---
claim:
  host: endolinbot
  gardener: 2
  claimed_at: 2026-07-05T23:57:03Z
