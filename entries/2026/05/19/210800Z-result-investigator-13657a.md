---
ts: 2026-05-19T21:08:00Z
kind: result
role: investigator
project: endo-but-for-bots
worktree: dispatches/investigator--40040b/project
prs:
  - repo: endojs/endo-but-for-bots
    issue: 295
    role: source
  - repo: endojs/endo-but-for-bots
    issue: 296
    role: source
refs:
  - entries/2026/05/19/205238Z-message-steward-b8a92a.md
  - entries/2026/05/19/205326Z-message-steward-586616.md
---

# XS-from-Rust investigation: ModuleSource analysis (#295) + bytecode cache (#296)

Bundled investigation per kriskowal's two directives. Both questions
decompose to "what XS C API does a Rust binary statically linking
libxs.a have access to, and what does the existing
`rust/endo/xsnap/` crate already expose?"

## Per-issue verdicts

- **#295 (XS ModuleSource for endor bundling speedup): yes, partial
  today, trivially extensible.** XS exposes native `ModuleSource` on
  `globalThis` with a `.bindings` getter that is exactly what
  `@endo/compartment-mapper`'s `parseMjs` needs. The existing
  `packages/module-source/src-xs/index.js` already adapts it to the
  legacy `.imports` / `.exports` / `.reexports` getters. The
  `rust/endo/xsnap/` crate on the `llm` branch already statically
  links libxs.a (`xsnap/build.rs` compiles `xs/sources/*.c` and
  links it into endor). A Babel-free Rust bindings analyzer is
  implementable today via `Machine::eval("(new
  ModuleSource(source)).bindings")`; the deeper variant (a thin
  Rust FFI binding over `fxNewModuleSourceInstance`) is a follow-up
  for if profiling shows the eval round-trip cost is material.

- **#296 (XS bytecode compilation + cache injection): partial today,
  structurally sound.** `fxParseScript(txMachine*, void* stream,
  txGetter, txUnsigned flags)` (declared `extern` in
  `xs/sources/xsAll.h`) returns a `txScript*` whose `codeBuffer`
  field is the serialized XS bytecode (built by `fxParserCode` in
  `xs/sources/xsCode.c`). The snapshot pair (`fxWriteSnapshot` /
  `fxReadSnapshot`) is already wired through `xsnap/src/ffi.rs` but
  is whole-machine, not per-module. The source-hash-keyed
  per-module cache needs: a Rust FFI binding for `fxParseScript`
  and `txScript->codeBuffer`, writes to the existing
  `rust/endo/src/cas.rs` SHA-256-keyed CAS, and at load time
  `fxResolveModule` + `fxRunModule` to install the cached
  bytecode. Cache signature follows the same versioning discipline
  as `SNAPSHOT_SIGNATURE` in `xsnap/src/lib.rs`. Position
  independence of `txScript->codeBuffer` across machines is the
  open empirical question.

## Deliverables

- Topic file: [`journal/projects/endo-but-for-bots/xs-from-rust-investigation.md`](../../../projects/endo-but-for-bots/xs-from-rust-investigation.md).
  Sections: per-issue executive summaries, XS API surface table
  (already-exposed / needed-for-#295 / needed-for-#296 / public
  archive accessors), endor integration sketch (current
  Babel-based path; proposed XS-backed path; two-engine flow),
  experiment results (not attempted, with rationale), open
  questions and follow-ups, concrete fix candidates.
- Issue comment on #295: <https://github.com/endojs/endo-but-for-bots/issues/295#issuecomment-4492047894>.
- Issue comment on #296: <https://github.com/endojs/endo-but-for-bots/issues/296#issuecomment-4492049865>.

## Experiment status

**Not attempted.** The dispatch root's `c/moddable` submodule was
uninitialized and the libxs.a bring-up requires both the submodule
init and stubs for the xsnap JS bundle inputs
(`packages/daemon/scripts/bundle-bus-*-xs.mjs` outputs). Bring-up
cost is 5 to 15 minutes from a fresh dispatch root; the
investigator's task brief is non-urgent and the deliverable is
structured analysis, so the experiment is parked as a follow-up
builder dispatch.

## Concrete fix candidates surfaced for the orchestrator

- **Designer (#295)**: write a design under a `designs/` directory
  capturing the two-path choice (eval round-trip vs direct
  `fxNewModuleSourceInstance` FFI) with profile-the-bundling-pass
  as evaluation criterion.
- **Probe (#296)**: a `gap-revealing-build` dispatch that does the
  bring-up, adds `fxParseScript` to `ffi.rs`, reads back
  `txScript->codeBuffer`, and reports on position independence.
- **Builder (#295)**: implement the chosen variant of the
  XS-backed bindings analyzer after the design lands.
- **Scout**: benchmark the bundling pass with and without the
  XS-backed analyzer on a representative workload (the `endo`
  repo's own `packages/cli` is a reasonable target).

The #296 probe is independent of the #295 design and can fire in
parallel.

Self-improvement: When a fork's active development sits on a branch
(`llm`) other than the dispatch root's checked-out branch
(`master`), and the investigation's evidence base lives on the
other branch, the path of least friction is `git show
origin/<branch>:<path>` rather than reflexively switching the
worktree. Saved this investigator several minutes of false starts.
Worth a one-liner addition to either the investigator role file or
the journalism skill ("for fork repos with branch-divergent active
work, read evidence via `git show origin/<branch>:<path>` without
switching the worktree"). Routing to liaison as a candidate skill
nibble; threshold may be too low to land as a standalone change.
