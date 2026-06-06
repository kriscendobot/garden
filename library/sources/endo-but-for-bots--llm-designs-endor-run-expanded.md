---
title: "endor-run-expanded — CAS integration + three input forms for `endor run`"
source-slug: endo-but-for-bots--llm-designs-endor-run-expanded
url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/endor-run-expanded.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/endor-run-expanded.md
total-lines: 359
status: In Progress (2026-04-17; Phases 1-2 shipped; Phases 3-5 remaining)
ingest-cycle: 202
ingest-date: 2026-06-06
lane: designs
---

# endor-run-expanded.md

A 359-line **In Progress** design (2026-04-17) by Kris Kowal expanding `endor run` to accept three input forms (ZIP archive / unpacked directory / entry-point module) all converging on §CAS-backed-module-loading.

## Status

- **Phase 1 (shipped)**: `ContentStore` standalone via `endo::cas::ContentStore::open()`.
- **Phase 2 (shipped)**: `rust/endo/src/cas_archive.rs` — `ingest_archive` extracts ZIP to CAS; `load_archive_from_cas` reconstructs from root hash; `endor run --cas <hash>` re-runs from CAS; `--no-cas` preserves legacy; `run_xs_archive_loaded` in xsnap.
- **Phase 3 (remaining)**: directory input.
- **Phase 4 (remaining)**: entry-point with no dependencies.
- **Phase 5 (remaining)**: entry-point with dependencies via XS-hosted mapper.

## Key design moves

- **§Three input forms converging on one runtime path** — ZIP / directory / entry-point all flow into §CAS-backed-module-loading. §The-runtime-behavior-is-identical-regardless-of-input-form — only the ingestion differs.
- **§Input-form detection by magic bytes, not flags** — PK\x03\x04 ZIP magic for Form 1; `compartment-map.json` presence for Form 2; fallthrough to entry-point for Form 3. Explicit `--zip`/`--dir`/`--entry` flags available but rarely needed.
- **§Three-option mapper implementation with §shell-out-to-Node rejected**:
  - Option A: §Rust-native mapper (preferred long-term).
  - Option B: §XS-hosted mapper (CHOSEN near-term) — reuses battle-tested `@endo/compartment-mapper` JS code by running it inside an XS machine with fs powers.
  - Option C: §Shell-out-to-Node — REJECTED ("defeats the purpose of `endor run` being self-contained").
- **§Two-phase flow** — map-in-XS-with-fs-powers-and-ingest-to-CAS, then execute-in-fresh-XS-with-CAS-backed-loading-only. §Two-machines-of-the-same-engine for §two-different-capability-scopes.
- **§Lazy module loading from CAS by hash on demand** — large applications may have thousands of modules but only import a fraction at runtime; fetching bytes on demand avoids loading unused modules.
- **§Root hash printed to stderr for re-run** — `endor[run]: archive root sha256:abc123...`; subsequent runs via `endor run --cas sha256:abc123...` skip re-ingestion entirely.
- **§Standalone CAS when no daemon** — `endor run` creates local CAS in temp directory; doesn't couple to daemon lifecycle; benefits from daemon's CAS at `{statePath}/store-sha256` when present.
- **§Backward compatibility via `--no-cas` flag** — preserves legacy behavior for read-only filesystems.
- **§Status-section with completed phases and code-paths named** — `cas_archive.rs`, `ingest_archive`, `load_archive_from_cas`, `run_xs_archive_loaded` named explicitly.
- **§Five Design Decisions canonical format** — CAS-as-universal-backing-store / lazy-module-loading / XS-hosted-compartment-mapper / standalone-CAS / input-form-detection-by-file-type-not-flags.
- **§Five Implementation Phases each with named test cases** — store/fetch round-trip / verify-CAS-files-and-re-run-from-hash / directory-execution / simple-module-no-deps / package.json-resolution-and-node_modules-walk.
- **§Three-dependencies-with-named-relationship-types** (Requires / Enables / Extends) — daemon-cas-management (Requires); endor-npm-registry-proxy (Enables Form 3 package resolution); daemon-endor-architecture (Extends — `endor run` becomes CAS-aware).
- **§Four CLI options with named defaults** — `--engine`, `--cas <hash>`, `--cas-dir <path>`, `--no-cas` — symmetric across three input shapes.

## Self-contained binary as named design axiom

> Use `node -e "..."` to run the compartment mapper. This defeats the purpose of `endor run` being self-contained. Rejected.

§Self-contained-binary is §a-named-design-axiom — the entire `endor` binary should not depend on Node.js at runtime. §Sibling to cycle 200 worker-rust-xs's §XS-over-V8 for engine choice (both designs reject Node.js dependencies in deployment target).

## Two CLI invocations

```sh
$ endor run archive.zip
endor[run]: archive root sha256:abc123...
# ... program output ...

$ endor run --cas sha256:abc123...
# ... program output (re-uses CAS-ingested archive) ...
```

## Ingest scope

Cycle 202 (designs-lane): full ingest of the 359-line design as one section.

## Related material in the library

- **`daemon-cas-management.md`** (Requires; not yet ingested in this librarian session): provides ContentStore for blob/tree storage.
- **`endor-npm-registry-proxy.md`** (Enables; not yet ingested): unlocks Form 3 package resolution without local node_modules.
- **cycle 176 daemon-endor-architecture**: Extends — `endor run` becomes a CAS-aware CLI on this architecture.
- **cycle 200 worker-rust-xs**: foundational predecessor; this design's §XS-hosted-mapper reuses the same §host-compartment-with-fs-powers pattern as worker-rust-xs's §host-compartment-vs-guest-compartment-split.
- **cycle 178 daemon-xs-worker-snapshot**: sibling-CAS-integration at a different layer — cycle 178 uses §CAS-streaming-for-snapshot; this cycle uses §CAS-by-hash-module-loading. Same underlying mechanism (§daemon-cas-management) at different layers.
- **cycle 182 daemon-xs-worker-debugger**: sibling worker-layer feature; together with cycle 202, the worker has §snapshot + §debugger + §metering + §CAS-backed-archive at the runtime layer.
- **cycle 184 daemon-xs-worker-metering**: sibling worker-layer feature.
- **cycle 188 daemon-rust-xs-performance**: empirical follow-up at the worker layer.
- **cycle 201 endo--packages-immutable-arraybuffer**: §by-copy-network-protocol kinship — CAS blobs are also §bulk-data-by-hash-not-by-reference; same content-addressing philosophy.
- **cycle 195 endo--packages-cli-src-utility-cluster**: §pet-name.js parsePetNamePath sibling — both designs do §content-driven-parsing.
- **cycle 197 endo--packages-panic**: §three-layer-dispatch-chain sibling pattern (graceful tiers with named defaults).
- **`@endo/compartment-mapper`** (the JS library that the XS-hosted mapper reuses): the existing well-tested mapper code.
