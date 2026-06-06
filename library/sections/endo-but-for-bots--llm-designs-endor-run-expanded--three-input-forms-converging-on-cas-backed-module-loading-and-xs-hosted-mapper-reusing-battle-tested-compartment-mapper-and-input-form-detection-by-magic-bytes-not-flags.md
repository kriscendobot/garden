---
title: §three-input-forms-converging-on-CAS-backed-module-loading (ZIP / directory / entry-point) + §XS-hosted-mapper-reusing-battle-tested-@endo/compartment-mapper + §input-form-detection-by-magic-bytes-not-flags + §three-option-mapper-implementation-with-rejected-shell-out-to-Node + §lazy-module-loading-from-CAS-by-hash-on-demand + §root-hash-printed-to-stderr-for-re-run + §--no-cas-fallback-for-read-only-filesystems + §standalone-CAS-when-no-daemon + §Phases-1-2-shipped-with-code-paths-named-and-Phases-3-5-remaining-with-named-test-cases — endo-but-for-bots designs/endor-run-expanded.md
source: endo-but-for-bots designs/endor-run-expanded.md
source-slug: endo-but-for-bots--llm-designs-endor-run-expanded
ingest-cycle: 202
ingest-date: 2026-06-06
lane: designs
status: In Progress (2026-04-17; Phases 1-2 shipped; Phases 3-5 remaining)
author: Kris Kowal (prompted)
related:
  - endo-but-for-bots--llm-designs-daemon-cas-management (Requires: ContentStore for blob/tree storage, retain/release)
  - endo-but-for-bots--llm-designs-endor-npm-registry-proxy (Enables: Form 3 package resolution without node_modules)
  - endo-but-for-bots--llm-designs-daemon-endor-architecture (cycle 176; Extends: `endor run` becomes CAS-aware)
  - endo-but-for-bots--llm-designs-worker-rust-xs (cycle 200; foundational predecessor design — `endor run` is a CLI surface on top of this worker)
  - endo-but-for-bots--llm-designs-daemon-xs-worker-snapshot (cycle 178; CAS-streaming snapshot is the §sibling-CAS-integration at a different layer)
  - endo--packages-compartment-mapper (the JS library that the XS-hosted mapper reuses)
  - endo--packages-immutable-arraybuffer (cycle 201; §by-copy-network-protocol kinship — CAS blobs are also bulk-data-by-hash-not-by-reference)
keywords:
  - three-input-forms-converging-on-one-runtime-path
  - input-form-detection-by-magic-bytes-not-flags (PK\x03\x04 ZIP magic)
  - three-option-mapper-implementation (Rust-native / XS-hosted / shell-out-to-Node)
  - shell-out-to-Node rejected ("defeats the purpose")
  - XS-hosted-mapper reuses battle-tested @endo/compartment-mapper
  - lazy-module-loading-from-CAS by hash on demand
  - five Design Decisions canonical format
  - five Implementation Phases with named test cases per phase
  - Phases-1-2-shipped-with-code-paths-named (cas_archive.rs / ingest_archive / load_archive_from_cas)
  - Phases-3-5-remaining
  - root-hash-printed-to-stderr-for-re-run
  - --no-cas-fallback-for-read-only-filesystems
  - standalone-CAS-when-no-daemon (temp directory)
  - --cas-dir flag for non-default CAS location
  - three-dependencies-with-named-relationship (Requires / Enables / Extends)
  - CAS-as-universal-backing-store
  - two-phase-flow (map-in-XS-then-execute-in-fresh-XS)
  - mapper-runs-in-XS-with-fs-powers
  - Status-section-with-completed-phases-and-remaining-phases
  - cycle 202 designs-lane
  - thirty-sixth consecutive designs/chat alternation cycle 166-202
---

# endor-run-expanded — §three-input-forms-converging-on-CAS-backed-module-loading + §XS-hosted-mapper-reusing-battle-tested-@endo/compartment-mapper + §input-form-detection-by-magic-bytes-not-flags + §three-option-mapper-implementation + §lazy-module-loading-from-CAS

## Source

- `endo-but-for-bots designs/endor-run-expanded.md` — 359 lines
- Status: **In Progress** (created 2026-04-17; Phases 1-2 shipped; Phases 3-5 remaining)
- Author: Kris Kowal (prompted)
- Cycle 202 of `/loop resume the librarian work.` (designs-lane; alternates from cycle 201's chat-lane @endo/immutable-arraybuffer; §thirty-sixth consecutive designs/chat alternation cycle 166-202)

## Single most structurally interesting move

§three-input-forms-converging-on-one-runtime-path (ZIP archive / unpacked directory / entry-point module — all converge on §CAS-backed-module-loading) + §input-form-detection-by-magic-bytes-not-flags (PK\x03\x04 for ZIP; compartment-map.json presence for directory; fallthrough to entry-point) + §three-option-mapper-implementation with §shell-out-to-Node-rejected ("defeats the purpose of `endor run` being self-contained") + §XS-hosted-mapper-reusing-battle-tested-@endo/compartment-mapper + §lazy-module-loading-from-CAS-by-hash-on-demand + §Status-section-with-completed-phases-and-code-paths-named.

§The-design's-central-axis: §all-three-input-forms-converge-on-the-same-CAS-backed-module-loading-runtime-path. §The-only-difference-between-forms-is-the-ingestion-phase. §CAS-as-universal-backing-store (Design Decision 1).

## §Three input forms with §detection-by-content-not-flags

```
endor run <archive.zip>        # Form 1: ZIP archive
endor run <directory/>         # Form 2: unpacked archive
endor run <entry.js>           # Form 3: entry-point module
```

§The-CLI-detects-the-form-by-examining-the-path:

1. **§ZIP-magic-number-detection** — `.zip` extension OR first bytes are `PK\x03\x04`.
2. **§Compartment-map.json-presence** — directory containing `compartment-map.json`.
3. **§Fallthrough-to-entry-point** — otherwise treat as a single entry-point module.

§Explicit-flags-available-for-disambiguation-but-rarely-needed (`--zip`, `--dir`, `--entry`). §The-default-path is §content-driven-detection.

§Sibling-pattern to cycle 195 cli/src message-parse.js's §regex-pattern-matching-for-format-detection, but at the file-byte level. §ZIP-magic-bytes are §a-universal-format-marker that doesn't require extension consistency.

§Borrowable-pattern: §input-form-detection-by-magic-bytes-not-flags + §explicit-flags-available-but-rarely-needed for §power-user-disambiguation.

§Design Decision 5 names it explicitly: "Input form detection by file type, not flags. `endor run foo` examines `foo` to determine the form."

## §Three-option-mapper-implementation with §shell-out-to-Node-rejected

For Form 3 (entry-point module), the design needs to run §the-compartment-mapper to discover dependencies, resolve modules, and build the archive. §Three options enumerated:

### Option A: §Rust-native mapper (preferred for long term)

> Implement module resolution and dependency walking in Rust. This avoids depending on Node.js for the build step.

§Named-future-direction. The mapper needs: JavaScript parser for `import`/`require` extraction (or simpler regex-based heuristic for static imports), `package.json` reading and `exports`/`main` resolution, registry table for package resolution.

### Option B: §XS-hosted mapper (preferred for near term — CHOSEN)

> Run the compartment mapper itself inside an XS machine. The mapper is JavaScript — it can execute in XS with filesystem host functions.
>
> The flow: create an XS machine with fs powers, load the compartment mapper bundle, invoke `mapNodeModules()`, get back a `CompartmentMap`, then ingest sources into the CAS.
>
> This reuses the existing well-tested mapper code with minimal new Rust code. The cost is a startup latency for the mapper machine, but this is a one-time cost per `endor run` invocation.

§Reuse-battle-tested-@endo/compartment-mapper-via-running-it-inside-XS. §Sibling-pattern to cycle 200 worker-rust-xs's §host-compartment-vs-guest-compartment-split (in worker-rust-xs, the host compartment has cap-std powers for guest evaluation; here, the host XS machine has fs powers for mapper execution).

§Two-phase-flow named explicitly: §map-in-XS-then-execute-in-fresh-XS. §The-mapper-XS-machine ingests sources into the CAS during mapping; §the-execute-XS-machine then runs the program with CAS-backed module loading.

§Startup-latency-cost-acknowledged-but-amortized: §one-time-cost-per-endor-run-invocation. §Honest-cost-disclosure.

### Option C: §Shell-out-to-Node — REJECTED

> Use `node -e "..."` to run the compartment mapper. **This defeats the purpose of `endor run` being self-contained. Rejected.**

§Self-contained-as-a-design-axiom — the entire `endor` binary should not depend on Node.js at runtime. §Shell-out-to-Node would §defeat-the-purpose.

§Borrowable-pattern: §three-option-implementation-with-shell-out-rejected when §self-contained-binary is a §named-design-axiom.

§Sibling-pattern: cycle 200 worker-rust-xs's §XS-over-V8 for engine choice — both designs explicitly reject Node.js dependencies in the deployment target. §Cycle-200 names Compartment as the decisive factor; §cycle-202 names self-containedness as the decisive factor.

## §CAS-backed module loading — the load-bearing architectural change

```rust
pub fn load_archive_from_cas(
    cas: &ContentStore,
    root_hash: &str,
) -> Result<LoadedArchive, ArchiveError>
```

§The-runtime-behavior-is-identical-regardless-of-input-form — §only-the-ingestion-differs. §This-means: the import hook fetches module sources by hash from the CAS instead of from in-memory buffers or ZIP entries.

§Lazy-module-loading: §large-applications-may-have-thousands-of-modules-but-only-import-a-fraction-at-runtime. §Fetching-bytes-on-demand avoids §loading-unused-modules-into-memory.

§Design Decision 2 names it: "Lazy module loading from CAS. Large applications may have thousands of modules but only import a fraction at runtime."

§Sibling-pattern to cycle 178 daemon-xs-worker-snapshot's §big-data-through-filesystem-small-coordination-through-envelopes — §both-designs avoid §eager-loading-of-bulk-data. §Cycle-202-is-CAS-backed-by-hash; §cycle-178-is-streaming-snapshot-via-CAS — same underlying mechanism at different layers.

## §Root-hash-printed-to-stderr-for-re-run

```
endor[run]: archive root sha256:abc123...
```

§Two-step-workflow enabled:
1. `endor run archive.zip` ingests to CAS and prints root hash.
2. `endor run --cas sha256:abc123...` re-runs from CAS without re-ingestion.

§Hash-as-stable-identifier — once an archive is ingested, the root hash refers to the same content forever (CAS is content-addressed). §Subsequent-runs-skip-the-ingestion-phase entirely.

§Borrowable-pattern: §root-hash-printed-to-stderr-for-re-run is §the-canonical-shape for §expensive-ingestion-with-cheap-retrieval. §The-hash-becomes-the-handle.

§Sibling-pattern to cycle 175 harden-selector's §pin-on-first-install (pinned name as stable handle), cycle 199 trampoline's §classic-uncurry-this (early capture as stable handle). §Different-axes, same shape: §a-one-time-cost-amortized-via-a-stable-handle.

## §Standalone-CAS-when-no-daemon — Design Decision 4

> When no daemon is running, `endor run` creates a local CAS in a temp directory. This avoids coupling `endor run` to the daemon lifecycle while still enabling CAS deduplication and caching when the daemon is present.

§Two-modes:
- §Daemon-present: use daemon's CAS at `{statePath}/store-sha256` for cross-invocation deduplication.
- §Daemon-absent: temp-directory CAS for the single invocation; cleaned up after.

§The-design-doesn't-force-daemon-coupling. §`endor run` is §usable-standalone for §development-iteration and CI.

§Borrowable-pattern: §standalone-mode-when-no-daemon for §a-CLI-tool that can integrate with §an-optional-daemon. §The-CLI-doesn't-require-the-daemon but §benefits-from-it-when-present.

§Sibling-pattern to cycle 178 daemon-xs-worker-snapshot's §suspend-only-when-idle (graceful degradation when conditions aren't met), cycle 197 panic's §three-layer-dispatch-chain (graceful fallback through tiers).

## §--no-cas-fallback-for-read-only-filesystems

> When `--no-cas` is specified, the current behavior is preserved: ZIP contents are loaded into memory without CAS integration. This is a fallback for environments where CAS writes are undesirable (e.g., read-only filesystems).

§Backward-compatibility-via-flag with §named-use-case (read-only filesystems). §Legacy-behavior-preserved-on-opt-out.

§Sibling-pattern to cycle 197 panic's §default-erroneous-exit + no-ambient-normal-exit asymmetry — both designs preserve legacy behavior via an explicit opt-out flag. §The-default-is-the-new-CAS-backed-behavior; §opt-out-restores-legacy.

## §Status section with completed phases and code paths named

The design opens with §a-Status-section that names §Phases-1-2-shipped with §code-path-citations:

> Phases 1-2 implemented:
> - **Phase 1**: `ContentStore` is available standalone via `endo::cas::ContentStore::open()` (implemented in daemon-cas-management).
> - **Phase 2**: `rust/endo/src/cas_archive.rs` — `ingest_archive` extracts ZIP contents into CAS as blobs with tree manifests. `load_archive_from_cas` reconstructs `LoadedArchive` from a root hash. `endor run` now ingests to CAS and prints root hash. `endor run --cas <hash>` re-runs from CAS. `--no-cas` preserves legacy behavior. `run_xs_archive_loaded` added to xsnap for executing pre-loaded archives.
>
> Remaining: Phase 3 (directory input), Phase 4-5 (entry-point with compartment mapper).

§Code-paths-named-in-Status (`rust/endo/src/cas_archive.rs`, `ingest_archive`, `load_archive_from_cas`, `run_xs_archive_loaded`) — §greppable-references for §future-readers.

§Sibling-pattern to cycle 188 daemon-rust-xs-performance's §Working-copy-inventory section (eight uncommitted change clusters mapped to three design documents) — §both-designs name §in-flight-implementation-state. §Cycle-202-uses §"Phases-1-2-implemented" framing; §cycle-188-used §"Working-copy-inventory" framing.

§Borrowable-pattern: §Status-section-with-completed-phases-and-code-paths-named for §multi-phase-designs in §In-Progress-state.

## §Five Implementation Phases each with §named-test-cases

| Phase | Scope | Test |
| --- | --- | --- |
| 1 | ContentStore in standalone mode | store/fetch round-trip in temp directory |
| 2 | ZIP archive CAS ingestion | run ZIP, verify CAS files created, re-run from hash |
| 3 | Unpacked directory input | create dir with compartment-map.json + sources, `endor run dir/`, verify execution |
| 4 | Entry-point module input | bundle compartment mapper for XS; two-phase flow; simple module no deps |
| 5 | Entry-point with dependencies | package.json resolution in XS-hosted mapper; node_modules walk; registry lookup |

§Each-phase-names-its-test-case. §Sibling-pattern to cycle 200 worker-rust-xs's §six-Implementation-Phases (also with named tests) but at smaller scale. §Five-phases here vs §six-phases there; §both-use-named-test-cases-per-phase as §phase-completion-criterion.

§Test-case-per-phase as §a-design-discipline ensures §each-phase-is-independently-verifiable.

§Borrowable-pattern: §Implementation-Phases with §named-test-cases-per-phase for §multi-phase-design as §greppable-completion-criteria.

## §Five Design Decisions canonical format

1. **§CAS-as-the-universal-backing-store** — all three input forms converge on the same CAS-backed module loading path; the runtime behavior is identical regardless of input form; only the ingestion differs.
2. **§Lazy-module-loading-from-CAS** — large applications may have thousands of modules but only import a fraction at runtime; fetching bytes on demand avoids loading unused modules into memory.
3. **§XS-hosted-compartment-mapper (near term)** — reuses the battle-tested `@endo/compartment-mapper` JavaScript code; the alternative (Rust-native mapper) is a large undertaking that duplicates well-tested logic; the XS-hosted approach has ~100ms startup overhead for the mapper machine — acceptable for a CLI tool.
4. **§Standalone-CAS-for-`endor run`** — when no daemon is running, `endor run` creates a local CAS in a temp directory; this avoids coupling `endor run` to the daemon lifecycle while still enabling CAS deduplication and caching when the daemon is present.
5. **§Input-form-detection-by-file-type-not-flags** — `endor run foo` examines `foo` to determine the form; explicit `--zip`, `--dir`, `--entry` flags are available for disambiguation but rarely needed.

§Five-Design-Decisions canonical format (sibling to cycles 184/188/192/194/196/198/200-hardened-url-shim/200-worker-rust-xs). §Each-decision-names-the-rationale and §the-trade-off.

§Decision-3-§"acceptable-for-a-CLI-tool" is §a-named-acceptance-of-startup-latency for §the-CLI-form-factor. §The-form-factor-context shapes the acceptable trade-off.

## §Three-dependencies-with-named-relationship (Requires / Enables / Extends)

| Design | Relationship |
| --- | --- |
| [daemon-cas-management] | **Requires**: ContentStore for blob/tree storage, retain/release |
| [endor-npm-registry-proxy] | **Enables**: Form 3 package resolution without node_modules |
| [daemon-endor-architecture] | **Extends**: `endor run` becomes CAS-aware |

§Three-relationship-types: §Requires (this depends on it; can't ship without), §Enables (this design unlocks future work in that direction), §Extends (this design adds to an existing surface).

§Sibling-pattern: cycle 196 endoclaw's §seven-Related-Designs hub-and-spoke, cycle 198 patterns-diagnostic-feedback's §explicit-no-predecessors row, cycle 200 hardened-url-shim's §Related-work-table ("similar in spirit, not blocking dependencies"). §Each-design-has-a-different-relationship-shape — cycle 202 uses §three-named-relationship-types with §verb-prefix-headers (Requires / Enables / Extends).

§Borrowable-pattern: §Dependencies-table-with-three-relationship-types (Requires / Enables / Extends) for §multi-design-context with §named-coupling-strengths.

## §Two-phase-flow named explicitly

> The flow: create an XS machine with fs powers, load the compartment mapper bundle, invoke `mapNodeModules()`, get back a `CompartmentMap`, then ingest sources into the CAS.

§Phase-A: §map-in-XS — create mapper machine with fs powers; invoke `mapNodeModules()`; get `CompartmentMap` + ingest sources into CAS.
§Phase-B: §execute-in-fresh-XS — separate XS machine for actual execution; reads from CAS by hash.

§Two-machines-not-one: §the-mapper-and-the-executor-are-distinct-XS-instances. §Mapping-runs-with-fs-powers; §execution-runs-with-CAS-backed-loading-only.

§Capability-discipline-applied-to-the-build-pipeline. §Sibling-pattern to cycle 200 worker-rust-xs's §host-compartment-vs-guest-compartment-split — same architectural discipline at different layers (build vs runtime).

§Borrowable-pattern: §two-machines-not-one for §build-and-run-as-distinct-capability-scopes.

## §--cas-dir flag for non-default CAS location

```
endor run [options] <path-or-hash>

Options:
  -e, --engine <engine>   Engine to use (default: xs)
  --cas <hash>            Run from CAS root hash directly
  --cas-dir <path>        CAS directory (default: state/store-sha256)
  --no-cas                Don't use CAS (current behavior, for compat)
```

§Four-options with §named-defaults. §`--cas-dir` for §non-default-CAS-location — useful for §standalone-runs-without-a-running-daemon, isolated testing, or scratch caches.

§Hash-as-input + §directory-as-input + §file-as-input — §three-input-shapes for §three-input-forms. §Symmetric-CLI-design.

## §Borrowable patterns (tier-1)

1. **§Three-input-forms-converging-on-one-runtime-path** — multiple input shapes share an ingestion-then-runtime split; only ingestion differs.
2. **§Input-form-detection-by-magic-bytes-not-flags** (PK\x03\x04 ZIP magic, compartment-map.json presence) + §explicit-flags-available-but-rarely-needed for §power-user-disambiguation.
3. **§Three-option-implementation-with-rejected-option-named** ("shell-out-to-Node defeats the purpose"); §each-option-has-named-rationale + §the-rejected-option-names-its-failure-mode.
4. **§Reuse-battle-tested-code-via-running-it-inside-the-target-engine** (XS-hosted @endo/compartment-mapper) instead of porting it (Rust-native).
5. **§Two-phase-flow** (map-in-XS-then-execute-in-fresh-XS) as §two-machines-not-one for §build-and-run-as-distinct-capability-scopes.
6. **§Lazy-module-loading-from-CAS-by-hash-on-demand** — fetch bytes on demand for large applications where only a fraction of modules are imported at runtime.
7. **§Root-hash-printed-to-stderr-for-re-run** — `endor[run]: archive root sha256:abc123...` enables `endor run --cas sha256:abc123...`; §expensive-ingestion-with-cheap-retrieval; §the-hash-becomes-the-handle.
8. **§Standalone-mode-when-no-daemon** — CLI tool creates local CAS in temp dir; doesn't couple to daemon lifecycle; benefits from daemon when present.
9. **§Backward-compatibility-via-flag** (`--no-cas`) with §named-use-case (read-only filesystems); §the-default-is-the-new-behavior; §opt-out-restores-legacy.
10. **§Status-section-with-completed-phases-and-code-paths-named** — `Phase 2: rust/endo/src/cas_archive.rs — ingest_archive extracts ZIP contents into CAS...` for §multi-phase-designs in §In-Progress-state.
11. **§Five-Design-Decisions canonical format** with §each-decision-names-the-rationale-and-trade-off.
12. **§Five-Implementation-Phases each with named-test-cases-per-phase** as §greppable-completion-criteria.
13. **§Three-dependencies-with-named-relationship-types** (Requires / Enables / Extends) for §multi-design-context with §named-coupling-strengths.
14. **§Four-CLI-options with named-defaults** symmetric across §three-input-shapes (hash / directory / file).
15. **§Self-contained-binary as a named-design-axiom** — rejected shell-out-to-Node "defeats the purpose of being self-contained".
16. **§Honest-cost-disclosure** ("~100ms startup overhead for the mapper machine — acceptable for a CLI tool") with §form-factor-context for the acceptable trade-off.

## §Synthesis-target

Slot machine library §multi-input-game-loader:

- §Three-input-forms-converging-on-one-runtime-path borrowable directly — slot machine library could accept §pre-bundled-game-archive, §unpacked-game-directory, §entry-point-JS-file for the game logic, all converging on a §sandboxed-evaluation runtime path.
- §Input-form-detection-by-magic-bytes-not-flags + §explicit-flags-available borrowable for §power-user-disambiguation.
- §Lazy-module-loading-from-CAS borrowable for §large-game-asset-libraries where §the-game-may-load-thousands-of-assets-but-use-a-fraction-per-session.
- §Root-hash-printed-to-stderr-for-re-run borrowable for §reproducible-game-replay (same hash = same game logic; same RNG seed = same outcome).
- §Standalone-mode-when-no-daemon borrowable for §desktop-game-installations that don't need a §game-server-daemon.
- §Backward-compatibility-via-flag with §named-use-case borrowable for §read-only-mode (e.g., demo mode where state mustn't be persisted).
- §Reuse-battle-tested-code-via-running-it-inside-the-target-engine borrowable for §game-asset-bundler that can run inside §the-game-engine's-own-JS-runtime rather than requiring a separate Node.js toolchain.

## §Cycle 202 meta-observations

§The-thirty-sixth-consecutive-designs/chat-alternation-cycle 166-202.

§Papers-lane-blocked 96+ consecutive cycles (since cycle ~106). §The-papers-lane-block is now §nearly-half-of-the-total-cycle-count.

§Library-reaches-707-sections at cycle 202.

§Library-protocol-from-cycle-200 applied: §grep-by-source-page-existence with the `endo-but-for-bots--llm-designs-endor-run-expanded`-full-slug-prefix — §no-prior-ingest-found.

§The-endor-CLI-family now has §its-first-CLI-surface-design in the library. §The-worker-architecture-cluster (cycles 176/178/182/184/188/200) is at the §runtime-layer; §endor-run-expanded is at the §CLI-layer. §Different-layers-of-the-same-system.

§Sibling-cluster check: cycle 178 daemon-xs-worker-snapshot uses §CAS-streaming-snapshot; cycle 202 endor-run-expanded uses §CAS-by-hash-module-loading; cycle 141 daemon-cas-management is the §CAS-foundation-design. §Three-CAS-integration-points in the endor family across §three-layers (worker-state / archive-loading / blob-and-tree-store).

§Self-contained-binary-as-design-axiom (cycle 202) joins §engine-speed-matters-less-than-confinement-correctness (cycle 200) and §minimal-dependency-discipline (cycle 199) as §three-named-design-axioms for the endor family.

§The-XS-hosted-mapper pattern (run battle-tested JS inside the target engine) is §a-novel-borrowable-pattern not previously named in the library at this fidelity. §Sibling-to cycle 200's §heterogeneous-workers (Node.js for dev, XS for deployment) but the §two-phase-flow-with-distinct-XS-machines-for-mapping-and-execution is §a-different-shape — §two-machines-of-the-same-engine for §two-different-capability-scopes.
