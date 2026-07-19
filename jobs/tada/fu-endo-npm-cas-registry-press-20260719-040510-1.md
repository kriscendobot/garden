Both relands are complete, tested against real XS execution, pushed, and opened as a stacked pair. Here is my completion report.

---

## Completion report

**Job:** Reland PR #791 (error-surface hardening) and PR #795 (Node `exports`-map resolution) on top of PR #800 (the new CAS-registry stack base), porting substance rather than blind-rebasing.

**Why this was a substance-port, not a rebase:** #800 restructured entry resolution. It resolves package entries **Rust-side** in the new `src/execute.rs` and dropped the old `run_map.rs` that #791/#795 were written against; its `xsnap::archive` install path also stores the source registry as plain strings (no `__lookupSource`, no `{src}` objects) the old diffs assumed. So both PRs were re-expressed against #800's actual code.

### PR #801 — reland of #791 (base: `feat/endor-npm-run`)
Branch `reland/endor-run-exec-hardening`. Files: `xsnap/src/{archive,lib,worker_io}.rs`, `src/execute.rs`.
- Wrapped the two archive evals that run user code (entry-compartment creation, entry import) in the inline `eval_wrapped` try/catch, so a throw that would SIGSEGV XS surfaces as a clean `false`/`Err`. The three generated-declaration evals stay unwrapped (function-hoisting).
- Endowed `console` in archive Compartments (both the standalone runner and the supervised archive-bootstrap path): `log/info/debug/trace` → stdout via a new `stdoutLine` host function; `warn/error` → the trace/stderr channel.
- Added `host_stdout_line` to the worker-io callback table.

### PR #802 — reland of #795 (base: #801, stacked)
Branch `reland/endor-npm-exports-resolution`. Files: `src/execute.rs`, `xsnap/src/archive.rs`.
- `execute.rs` now leaves `"."` edges unresolved (`Link` module `"."`) and keeps each `package.json` as **raw JSON** in the registry so the runtime resolver can read it. Removed `resolve_main`, the `mains` pre-pass, and the `NoMain` error.
- `xsnap::archive` gained `EXPORTS_RESOLVER_JS`: Node `"exports"` with subpath keys, single-`*` wildcards (prefix/suffix specificity), nested conditions, array fallbacks, `null` blocks; encapsulation of unlisted subpaths; `main`/`index.js` fallback. Import-conditions pass first, retry with `require` (because every load bottoms out in `importNow`).
- `loadNowHook` resolves `"."` links (preserving the zip-archive literal-`.` convention) and bare subpath specifiers (`pkg/sub`, `@scope/pkg/sub`).

### Real-execution evidence (`cargo test`, XS actually runs)
- `endo` lib: **128 passed, 0 failed** — includes all 14 `execute::` tests: console-endowed run, throw→`Err`, exports-over-main, conditional import-first, require-only second pass, wildcard, scoped subpath, extension-less file fallback, and clean encapsulation (`Err`).
- `xsnap` archive/import: **8 passed, 0 failed** — includes new `import_archive_entry_throw_fails_cleanly`; existing zip-archive and CAS-graph execution tests unchanged.
- (Build note: the worktree lacked the `c/moddable` submodule and the gitignored SES bootstrap bundles; I populated the submodule from a sibling checkout at the exact pinned commit and used the standard verification stubs for the bundles — neither is touched by these changes, and `Compartment`/`ModuleSource` are native XS globals so the archive tests exercise the real path.)

### PR file lists (verified clean — no stubs/submodule leakage)
- #801: `execute.rs`, `archive.rs`, `lib.rs`, `worker_io.rs`
- #802: `execute.rs`, `archive.rs`

**Follow-ups:** The originals #791/#795 (on the 208-file-stale base) each got a comment pointing at their reland; the maintainer can close them once the relands are reviewed. Design-doc gaps unchanged: full CommonJS `require` linkage, directory-relative nested resolution, and self-referential (`imports`/own-name) resolution remain deferred.
