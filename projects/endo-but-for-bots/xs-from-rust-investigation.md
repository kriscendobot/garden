---
created: 2026-05-19
updated: 2026-05-19
author: investigator
---

# XS from Rust: ModuleSource analysis and bytecode cache investigation

> Abstract: Investigation of two related questions kriskowal raised in
> [endojs/endo-but-for-bots#295](https://github.com/endojs/endo-but-for-bots/issues/295)
> (XS native ModuleSource analysis for endor's bundling speedup) and
> [#296](https://github.com/endojs/endo-but-for-bots/issues/296)
> (XS bytecode compilation and cache injection from a Rust binary
> linking libxs.a). Both decompose into the same question: what C API
> does XS expose, and which symbols survive into a libxs.a a Rust
> binary can call? Answer for #295: **yes, partial today and trivially
> extensible**. XS already exposes a native `ModuleSource` constructor
> whose `bindings` property is exactly what the compartment-mapper
> needs for static import analysis; `@endo/module-source/src-xs/`
> already adapts it for the existing JS-side API; the
> `rust/endo/xsnap/` crate on the `llm` branch already statically
> links libxs.a and can drive the JS-level constructor today. A
> Babel-free Rust path is feasible. Answer for #296: **partial today
> and structurally sound**. XS exposes parser and bytecode-generation
> internals (`fxParseScript` returns a `txScript*` containing the
> serialized bytecode buffer; the `Machine::write_snapshot` /
> `read_snapshot` pair already round-trips heap state including
> compiled modules via `fxWriteSnapshot` / `fxReadSnapshot`). The
> source-hash-keyed bytecode cache is constructable but needs a
> narrower per-module accessor than the snapshot-of-the-whole-heap
> shape the `endor` daemon uses today. This document is the audit
> trail; the per-issue executive summaries are the section above the
> XS API surface table. Not in this document: a working Rust
> experiment (the moddable submodule is uninitialized in the dispatch
> root and the libxs.a build chain is non-trivial to drive from a
> fresh dispatch; experiment is parked as a follow-up).

## Per-issue executive summaries

### #295: XS ModuleSource analysis for endor

**Yes, partial today, trivially extensible.** XS exposes a native
`ModuleSource` constructor on `globalThis` whose `.bindings` getter
returns the parsed import/export/reexport list. The existing
`packages/module-source/src-xs/index.js` already translates `.bindings`
to the legacy `.imports` / `.exports` / `.reexports` getters that
`@endo/compartment-mapper`'s `parseMjs` consumes. From a Rust
perspective: the `rust/endo/xsnap/` crate on the `llm` branch already
statically links libxs.a (`xsnap/build.rs` compiles `xs/sources/*.c`
into a static archive named `libxs.a` and links it into the `endor`
binary). The crate's `Machine::eval` API can drive
`new ModuleSource(source).bindings` directly in JS. A Babel-free
bindings-analysis path for the compartment-mapper is therefore
already feasible without further C-API work; the remaining design
question is whether to keep the Rust-side adapter at the JS level
(eval `new ModuleSource(source)` and read `.bindings` back as a
`JsValue`) or descend to the C entrypoint (`fxNewModuleSourceInstance`
in `xs/sources/xsModule.c`) for a thin Rust wrapper that bypasses the
eval round-trip. The first form is implementable in a day; the
second is a small, focused extension to `ffi.rs` and `lib.rs`.

### #296: XS bytecode compilation and source-hash-keyed cache

**Partial today, structurally sound.** Two pieces of XS API are
relevant. The first is `fxParseScript(txMachine*, void* stream,
txGetter, txUnsigned flags)` declared in `xs/sources/xsAll.h`, which
parses a JS source stream and returns a `txScript*` whose
`codeBuffer` field holds the compiled XS bytecode (`xs/sources/xsCode.c`
documents `fxParserCode` as the function that builds the buffer; the
higher-level `fxParserTree` then `fxParserCode` chain is what
`fxParseScript` orchestrates). The second is the
snapshot pair already wired through `ffi.rs`:
`fxWriteSnapshot(txMachine*, xsSnapshot*)` and
`fxReadSnapshot(xsSnapshot*, name, context)`, used by `endor`'s
`Machine::write_snapshot` / read pathway for whole-machine
checkpointing. A source-hash-keyed *per-module* bytecode cache is not
quite either of these today: the snapshot mechanism is per-machine
(the whole heap + the callback-table indirection that makes function
pointers portable across runs), while `fxParseScript` produces a
`txScript*` that is not currently exposed through the Rust FFI nor
written to disk by any current code path in the crate. The
implementation shape is: extend `ffi.rs` with `fxParseScript` (returns
a `*mut txScript`), add functions to read out `script->codeBuffer` and
`script->codeSize`, write that buffer to the CAS (the
`rust/endo/src/cas.rs` content-addressed store keyed by SHA-256
already exists and is used for archives), and at module-load time
either bypass `fxParseScript` and feed the cached bytecode directly to
the module instance (via `fxResolveModule(machine, module, moduleID,
script, data, destructor)` per `xs/sources/xsModule.c`), or wrap the
cached buffer in a synthetic `txScript` and let `fxRunModule` execute
it. The cache invalidation contract is implicit in the keying: the
SHA-256 of the source bytes is the cache key; XS bytecode format is
versioned via the snapshot signature mechanism (`SNAPSHOT_SIGNATURE`
in `xsnap/src/lib.rs` is `b"endo-xs 1"`), so a bytecode-cache
signature should follow the same versioning discipline. Open: cross-
machine portability of a `txScript`'s `codeBuffer` (the snapshot
machinery has explicit serialization of internal pointers; whether
`fxParseScript` output is similarly position-independent or needs
relocation is an open empirical question that the experiment in §
Experiment results would have measured).

## XS API surface table

The functions below are grouped by what they enable. "Public" = declared in
`xs/includes/xs.h` (the documented embedder API). "Internal" = declared in
`xs/sources/xsAll.h` but reachable from a Rust crate that statically links
`libxs.a` because the symbols are exported (not `static` in C). The existing
`rust/endo/xsnap/src/ffi.rs` declares 63 `fx*` functions today, mixing both.

### Already exposed in `rust/endo/xsnap/src/ffi.rs`

| Function | Purpose | Source |
| --- | --- | --- |
| `fxCreateMachine` / `fxDeleteMachine` | Machine lifecycle | public |
| `fxBeginHost` / `fxEndHost` | Host-side stack entry guard | public |
| `fxID` / `fxFindID` / `fxName` | Symbol interning and lookup | public |
| `fxGetID` / `fxSetID` / `fxDefineID` | Property access by symbol | public |
| `fxCall` / `fxCallID` / `fxNew` / `fxRunCount` | JS invocation | public |
| `fxNewObject` / `fxNewArray` / `fxNewHostFunction` / `fxNewHostObject` | Construction | public |
| `fxWriteSnapshot` / `fxReadSnapshot` | Heap serialize / deserialize | internal-but-stable |
| `fxBeginMetering` / `fxEndMetering` / `fxGetCurrentMeter` | Computron metering | internal |
| `fxRunPromiseJobs` / `fxRunLoop` | Microtask + event loop drain | internal |
| `fxCollectGarbage` / `fxEnableGarbageCollection` | GC control | internal |
| `fxInitializeSharedCluster` / `fxTerminateSharedCluster` | Atomics shared cluster | internal |

### Needed for #295 (bindings analysis), not yet in `ffi.rs`

| Function | Purpose | Source |
| --- | --- | --- |
| `fxNewModuleSourceInstance(txMachine*)` | C-level entry for `new ModuleSource(source)`; reachable today through `Machine::eval` round-trip | `xs/sources/xsModule.c` |
| `fxCheckModuleSourceInstance(txMachine*, txSlot*)` | Validates a slot is a `ModuleSource`; needed if the Rust wrapper takes a pre-constructed slot | `xs/sources/xsModule.c` |

For #295 the **minimum sufficient path is no new FFI**: invoke
`m.eval("(new ModuleSource(source)).bindings")` from Rust and parse the
result back. The deeper path (direct `fxNewModuleSourceInstance` call,
skipping the eval round-trip) is a follow-up for if profiling shows the
eval overhead is material at compartment-mapper scale.

### Needed for #296 (bytecode cache), not yet in `ffi.rs`

| Function | Purpose | Source |
| --- | --- | --- |
| `fxParseScript(txMachine*, void* stream, txGetter, txUnsigned flags)` | Parse a JS source stream; returns `txScript*` with `codeBuffer` | `xs/sources/xsAll.h`, declared `extern` |
| `fxParserTree(txParser*, ...)` | Lower-level parse-into-AST; called by `fxParseScript` | `xs/sources/xsTree.c` |
| `fxParserCode(txParser*)` | AST-to-bytecode pass; returns `txScript*` | `xs/sources/xsCode.c` |
| `fxResolveModule(txMachine*, txSlot* module, txID, txScript*, void* data, txDestructor)` | Install a pre-compiled `txScript` into a module slot | `xs/sources/xsAll.h`, declared `extern` |
| `fxRunModule(txMachine*, txSlot* realm, txID, txScript*)` | Execute a `txScript` as a module | `xs/sources/xsAll.h`, declared `extern` |
| `fxLoadModule` / `fxLinkModules` / `fxExecuteModules` | Module dependency machinery; relevant if the cache wants to drive the whole lifecycle | `xs/sources/xsModule.c` |

The `txScript` structure is internal but the relevant fields
(`codeBuffer`, `codeSize`, and a destructor) are stable. The
expectation from reading `xsCode.c` is that the buffer is
self-contained for execution within the same machine; cross-machine
portability needs the same callback-table indirection the snapshot
mechanism uses, which is where the bytecode-cache design has its main
open question (see § Open questions).

### Public archive accessors (already in xs.h)

These are tangentially relevant: XS already supports a precompiled
*archive* format (used by Moddable for embedded-device deploys) with a
public API for reading code and data from an archive blob.

| Function | Purpose |
| --- | --- |
| `fxGetArchiveCode(xsMachine*, void*, xsStringValue, size_t*)` | Look up compiled code by name in an archive |
| `fxGetArchiveCodeCount(xsMachine*, void*)` | Enumerate archive entries |
| `fxGetArchiveCodeName(xsMachine*, void*, xsIntegerValue)` | Name by index |
| `fxGetArchiveData(xsMachine*, void*, xsStringValue, size_t*)` | Data (non-code) blob lookup |

The archive format may be a closer match to "shared bytecode cache,
keyed on source hash" than the `txScript` approach, modulo whether
the archive's format admits a per-entry source-hash key or only
per-name lookup. Worth a closer look in the follow-up.

## endor integration sketch

### Current Babel-based path

In `packages/compartment-mapper/src/parse-mjs.js`, the `parseMjs`
function takes raw bytes for a `.mjs` source, constructs a
`ModuleSource` from `@endo/module-source` (which in the default build
delegates to `src/transform-analyze.js` and entrains Babel), and
returns a parser record containing `bytes`, `record`, and `parser:
'mjs'`. The compartment-mapper's `capture-lite.js` and `archive.js`
walk the dependency graph by inspecting `record.imports` for each
parsed module. Babel is the cost: `@babel/parser` and `@babel/core`
together are heavy at startup time and per-module parsing is the
dominant cost for any tool that does a full bundling pass (the
`endor` binary's eventual ambition).

### Proposed XS-backed path

With `rust/endo/xsnap/` already statically linking libxs.a, the
endor Rust binary could expose a parser entrypoint that:

1. Creates (or reuses) a parser-only `Machine` configured with native
   `ModuleSource` available on `globalThis`.
2. For each `.mjs` source bytes input, evals `(function(src){ var m =
   new ModuleSource(src); return JSON.stringify({imports: m.imports,
   exports: m.exports, reexports: m.reexports}); })(...)` and parses
   the JSON back into a Rust `ModuleAnalysis` struct.
3. Hands the analysis to the Rust port of the compartment-mapper's
   graph walk.

For #296 the cache layer slots in between steps 1 and 2: before
invoking the eval, compute SHA-256 of the source bytes, look up the
hash in the existing `rust/endo/src/cas.rs` content store; on miss,
proceed with the eval (or the direct `fxParseScript` call), store the
resulting bindings record (and/or bytecode buffer) in the CAS keyed
by the source hash; on hit, return the cached record directly without
invoking XS at all.

The CAS is already there: `cas.rs` is a SHA-256-keyed flat-directory
store with optional `.meta` sidecars carrying a `ContentType` tag.
Adding a `ContentType::ScriptBytecode` (or `ModuleAnalysis`) variant
is a one-line change. The reference counting and tree-manifest
machinery (`TreeManifest`, `TreeEntry`) already supports keying
caches at the directory granularity, which is the right shape for a
"bundle-level" cache.

### Two-engine flow

A practical design would have the Rust endor binary:

- Run `xsnap`'s libxs.a as the JS parser (no Node.js, no Babel) for
  the bindings-analysis pass.
- Reuse the same XS machine (or a fresh one per worker thread) to
  also execute the bundled program at runtime (which the `endor run
  <archive.zip>` codepath already does via
  `xsnap::archive::install_archive` and `Machine::import_archive`).

This means a Rust `endor bundle` command that does what
`@endo/compartment-mapper`'s `bundle` JS API does, but with no
Node.js dependency and no Babel cost, **and** a transparent
bytecode/analysis cache that survives across runs. The XS engine is
the same engine on both sides of the bundling boundary; the cache
keyed by source hash benefits both the bundling pass and the
per-process startup cost of any sub-archive that happened to be
parsed before.

## Experiment results

**Not attempted.** The moddable submodule is uninitialized in the
dispatch root's project worktree (`c/moddable` is a 160000-mode
gitlink at commit `5516726818906190d3a042d8be90219ce9d51b45` but no
files are checked out), and the per-issue project README at
`journal/projects/endo-but-for-bots/README.md` § Rust crate bring-up
documents that first-time bring-up needs both the submodule init
*and* stubs for the xsnap bundle inputs (`ses_boot.js`,
`worker_bootstrap.js`, `daemon_bootstrap.js`). Driving a full
`cargo build --release -p endo --bin endor` from a fresh dispatch
root would take 5 to 15 minutes including the moddable clone and the
libxs.a compile. The investigator's task brief is non-urgent and the
deliverable is structured analysis, so the experiment is parked as a
follow-up. The README's bring-up steps are the prerequisite for any
followup builder dispatch that wants to actually link a Rust file
that calls `fxParseScript` and read back a `txScript->codeBuffer`.

If the experiment were run, the minimum viable demo would be:

1. Add `fxParseScript` and a `txScript` accessor to `ffi.rs`.
2. Write a Rust binary that: reads a `.mjs` file; calls
   `Machine::eval("(new ModuleSource(source)).bindings")`; prints the
   resulting bindings as JSON.
3. Confirm Babel-free dependency analysis works end to end on a small
   ESM file with a couple of imports.
4. As a stretch goal, also call `fxParseScript` directly, dump
   `script->codeBuffer` to a file, and on a second run feed it via
   `fxResolveModule` + `fxRunModule` to confirm cached-bytecode
   execution works.

Both demos are scoped to a single afternoon once the bring-up is
done; the dispatch chain would be probe (gap-revealing build) →
build (full implementation) → ferry.

## Open questions and follow-ups

1. **Position independence of `txScript->codeBuffer`.** The snapshot
   mechanism has explicit serialization of internal pointers and a
   callback-table indirection; `fxParseScript`'s output is
   undocumented for cross-machine portability. If the buffer
   contains absolute pointers to interned symbols or callback
   table entries, the cache key must include those table identities
   too, which collapses cross-machine sharing. Empirical question
   for the follow-up builder.

2. **Archive format vs `txScript` format for the cache.** The XS
   archive format (per `fxGetArchiveCode` accessors in `xs.h`) is the
   *documented* serialized-bytecode form for embedded deploys. It may
   already solve the position-independence problem and have a
   designed-for-sharing format. The `txScript->codeBuffer` form may
   be a thinner / faster cache for the single-machine case but a
   worse fit for cross-process sharing. The trade is worth probing
   before committing to one.

3. **Reuse of the existing snapshot machinery as the cache.** A
   different design: instead of caching per-module bytecode, snapshot
   the entire post-bundling machine state once per bundle, and on
   the next run with the same source-hash bundle, deserialize the
   snapshot instead of re-evaluating. This is closer to what `endor`
   already does for the daemon's bootstrap (`Machine::write_snapshot`
   in `xsnap/src/lib.rs`). The bundle-level vs module-level
   granularity is a design choice; bundle-level is simpler to
   implement but loses cache hits when only one of N modules
   changes.

4. **Direct `fxNewModuleSourceInstance` vs eval round-trip for #295.**
   The eval-round-trip path is implementable today; the direct C-call
   path needs profiling evidence that the eval overhead is material
   at bundling-pass scale before it's worth the FFI complexity. The
   investigator's hypothesis: at compartment-mapper scale (thousands
   of `.mjs` files per bundle), the eval overhead is dominated by
   the actual parse cost and the direct C call buys little; profile
   first.

5. **Compartment-mapper's Rust port surface.** The full
   compartment-mapper has many parser variants (`parse-mjs`,
   `parse-cjs`, `parse-json`, `parse-pre-mjs`, `parse-pre-cjs`,
   `parse-archive-mjs`, `parse-archive-cjs`, `parse-bytes`,
   `parse-text`). #295 covers MJS only. The CJS path needs a
   different analyzer (the current Babel-based `@endo/cjs-module-
   analyzer` package) and is out of scope here.

6. **Threading.** `Machine` is `!Send` and `!Sync` by design (each
   XS machine is single-threaded). A parallel bundling pass needs
   one machine per worker thread; the snapshot mechanism could
   amortize the per-thread machine-creation cost by snapshotting a
   primed parser machine once and restoring it per worker. This is a
   builder-level optimization, not an API-surface question.

## Concrete fix candidates for the orchestrator

Surfaced for the orchestrator's next dispatch decisions:

- **Designer (#295 path)**: write a design under
  `packages/module-source/designs/xs-backed-bindings-analysis.md` (or
  the equivalent location for endor designs) that captures the
  two-path choice (eval round-trip vs direct
  `fxNewModuleSourceInstance` FFI) with an evaluation criterion
  (profile the bundling pass on a real repo).
- **Probe (#296 path)**: a `gap-revealing-build` dispatch that
  actually does the bring-up, adds `fxParseScript` to `ffi.rs`,
  reads back `txScript->codeBuffer`, and reports on position
  independence. Termination is the structured gap report; the PR
  stays draft.
- **Builder (#295 path, after design lands)**: implement the chosen
  variant of the XS-backed bindings analyzer, plumb it through a
  Rust-side `parse_mjs` analog, and gate it behind a Cargo feature
  so the existing Node.js path remains the default until the new
  path is benchmarked.
- **Scout (after either path lands)**: benchmark the bundling pass
  with and without the XS-backed analyzer on a representative
  workload (the `endo` repo's own `packages/cli` is a reasonable
  target).

None of these are blocking on each other except the #295 design ->
#295 implementation ordering. The #296 probe is independent of the
#295 design and can fire in parallel.

## Sources consulted

- `rust/endo/README.md` on `origin/llm` (bring-up, subcommand table,
  Cargo build).
- `rust/endo/xsnap/Cargo.toml`, `xsnap/build.rs`,
  `xsnap/src/ffi.rs`, `xsnap/src/lib.rs`, `xsnap/src/archive.rs`,
  `xsnap/src/powers/modules.rs` on `origin/llm` (the existing FFI
  bindings, the libxs.a build chain, the archive runner).
- `packages/module-source/{index.js,src-xs/index.js,DESIGN.md,REWRITE.md,README.md}`
  on `origin/master` (the existing JS-side dual-implementation).
- `packages/module-source/src/{module-source.js,transform-analyze.js,parse-babel.js}`
  on `origin/master` (the Babel-based path the XS-backed path would
  replace for the `xs` condition).
- `packages/compartment-mapper/src/parse-mjs.js` on `origin/master`
  (the per-module entry into ModuleSource that endor's port would
  reimplement in Rust).
- Moddable upstream sources via WebFetch: `xs/includes/xs.h` (public
  API), `xs/sources/xsAll.h` (internal API),
  `xs/sources/xsModule.c` (`fxNewModuleSourceInstance`, `fxRunModule`,
  `fxResolveModule`), `xs/sources/xsCode.c` (`fxParserCode` returning
  `txScript*`), `xs/sources/xsTree.c` (`fxParserTree`),
  `xs/sources/xsSnapshot.c` (snapshot format).
- Project README `journal/projects/endo-but-for-bots/README.md`
  § Rust crate bring-up (the moddable submodule init + bundle stubs
  prerequisite that gated the experiment).
