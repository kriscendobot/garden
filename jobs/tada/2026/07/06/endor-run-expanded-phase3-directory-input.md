Work is complete. Here is my report.

---

**Job: Phase 3 (directory input) for `endor run` — `endojs/endo-but-for-bots`, `endor` branch**

**What I did**

Taught `endor run` to accept an unpacked archive **directory** (a directory containing `compartment-map.json` alongside its compartment sources), in addition to the existing ZIP form. Landed as one green commit `e0322c405` pushed directly to `origin/endor` (fast-forward from `b1add07d8`).

**Changes (4 files, +301/−50)**
- `rust/endo/src/cas_archive.rs` — added `ingest_directory(cas, dir)`: recursively walks the tree (deterministic sorted order), stores each file as a CAS blob, and builds the tree manifests. Factored the tree-building out of `ingest_archive` into a shared `ingest_files` helper that **both** paths now use, so a directory and its zipped equivalent produce byte-identical CAS trees / the same root hash and load through the same `load_archive_from_cas`.
- `rust/endo/src/cas.rs` — made tree-manifest serialization **canonical**: `TreeManifest.entries` is now a `BTreeMap` instead of `HashMap`. This was a genuine content-addressing defect I found while writing the equivalence test: a `HashMap` serializes in randomized order, so the root hash `endor run` prints was **not reproducible across processes**, breaking the design's `endor run … → endor run --cas <hash>` round-trip (affected Phase 2 too). Fix is API-compatible; all existing `cas` tests updated and pass.
- `rust/endo/src/bin/endor.rs` — the `run` arm detects a directory argument and dispatches to a new `cmd_run_dir_with_cas` (ingest → print root hash → execute via CAS-backed loading); refreshed the usage/help text.
- `designs/endor-run-expanded.md` — Status section records Phase 3 as implemented.

**Verification (real execution, not just inspection)**
- `cargo test --lib` → **73/73 pass**, including 4 new directory tests (ingest+load, directory/ZIP identical root hash for flat and nested layouts, cross-process determinism, non-directory rejection). Determinism test run 3× — stable.
- Built the `endor` binary and ran it end-to-end against a real directory fixture: `endor run /tmp/endor-dir-fixture` → detected directory → printed `archive root 9f7417…` → the entry module **executed and printed "hello from directory input"** → exit 0; CAS populated with blobs+trees.
- `endor run --cas 9f7417…` (separate process) re-executed the same program → exit 0.
- Two directory runs in separate processes produced the **identical** root hash (the BTreeMap fix, confirmed in the real binary, not just unit tests).
- `cargo clippy` — no warnings in any of my files; no errors.

**Caveats / notes**
- To build locally I initialized the pinned `c/moddable` submodule and created three **gitignored** placeholder xsnap JS bundles (`ses_boot.js`/`worker_bootstrap.js`/`daemon_bootstrap.js`, normally Node-generated via the daemon bundler). These are never committed and were not needed for the code path I changed — the standalone archive-run path uses the real checked-in `polyfills.js`, so the entry module genuinely executed. The directory-ingest logic itself is fully covered by the unit tests independent of XS.
- `cargo fmt --check` reports diffs across 16 files on the branch (the tree isn't rustfmt-clean and it isn't a CI gate); I matched surrounding hand-formatting rather than reformat adjacent code.

**Follow-ups (out of Phase 3 scope)**
1. **Latent nested-module-path gap (pre-existing, Phase 2):** `ingest_files` stores files nested more than one level inside a compartment (e.g. `app/lib/util.js`) under a single slash-joined key, so `fetch_from_tree` can't traverse into `lib`. Real archives whose module `location`s are nested would silently fail to load those sources (`load_archive_from_cas` swallows the fetch error). Affects both ZIP and directory forms since they share `ingest_files`; worth a dedicated fix that builds proper nested sub-trees.
2. Phases 4–5 (entry-point module input via the XS-hosted compartment mapper) remain — the next unblocked increments.
