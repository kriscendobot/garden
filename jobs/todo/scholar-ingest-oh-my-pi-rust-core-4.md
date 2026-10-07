---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Continue ingesting oh-my-pi's Rust core: shell VFS bridge and deeper pi-iso / pi-ast / pi-shell module docs

Role: scholar. Continue the source-priority ingest from `scholar-ingest-oh-my-pi-rust-core-3` under the normal 3 to 5 source / roughly 25-section cycle budget.

----- ISSUE NOTE (copy this block VERBATIM into every follow-on job) -----
issue_spine: issue-kriscendobot-garden-121
issue_url: https://github.com/kriscendobot/garden/issues/121
submitter: jcorbin
----- END ISSUE NOTE -----

Already in the library (do not redo; idempotency-check against `source_commit`): crate roots of `pi-iso`, `pi-shell` (+ `minimizer.rs`, `minimizer/plan.rs`), `pi-ast`, `pi-vfs`, `pi-builtins`; `pi-natives` `grep.rs`, `glob.rs`, `fd.rs`, `shell.rs`, `iso.rs`, `ast.rs`; vendored `crates/vendor/brush-parser/{README.md,src/lib.rs}` and `crates/vendor/brush-core/{README.md,src/lib.rs}`; the third-party explainer as `web--oh-my-pi-design-rust-core` (secondary description + divergence ledger).

Ingest next, in order, from https://github.com/can1357/oh-my-pi `main`, anchored on each file's file-specific commit:

1. `crates/pi-natives/src/shell/vfs.rs` (the `ShellFilesystem` JS-to-`pi-vfs` bridge; 23-line module header). Preserve the distinction: `pi-vfs` virtual files need not materialize on the host; `grep`, `glob`, and `ast` accept the injected filesystem; `fuzzyFind` remains host-path-only.
2. Deeper `pi-iso` module docs: `src/rcopy.rs` (Git-worktree fallback) and `src/overlayfs.rs` (kernel overlay + `fuse-overlayfs`), plus the `resolve` priority rules referenced from `pi-natives` `iso.rs`.
3. Deeper `pi-ast` docs: `src/language/mod.rs` (language registry; check the explainer's 50+ languages / per-language WASM claims, which found no WASM in the registry) and `src/ops.rs` if it adds contract beyond the `pi-natives` `ast` sections.
4. Deeper `pi-shell` docs where useful: `src/process.rs` (`kill_tree`, graceful terminate-then-kill tree shutdown) and `src/cancel.rs`. `src/shell.rs` is ~7.4k lines with a one-line header; survey it and ingest only documented contracts, deferring the rest.

Optional if budget remains: verify the explainer's unverified "native loader falls back to JS" claim against `packages/natives` and record it in a new section (do not edit the existing ledger in place; append-only).

Known divergences to preserve (already recorded in the ledger): the explainer omits `pi-vfs`; it mischaracterizes the output minimizer as a permission gate (the escalation check lives in `packages/coding-agent/examples/hooks/permission-gate.ts`); its vendored-brush path (`crates/brush-core-vendored/`) and rationale are wrong (actual: `crates/vendor/`, vendored for a here-document fix); `pi-shell` has no `ResourceLimits`/`setrlimit` (brush-core's `rlimits` is embedded-safe `ulimit` state).

If budget is reached, post another follow-on preserving the issue note verbatim. Otherwise this should close the issue-121 Rust-core ingest; say so in the result and the maintainer digest.
