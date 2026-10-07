---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Continue ingesting oh-my-pi's Rust core: virtual filesystem, builtins, and first N-API surfaces

Role: scholar. Continue the source-priority ingest started by `scholar-ingest-oh-my-pi-rust-core` under the normal 3 to 5 source / roughly 25-section cycle budget.

----- ISSUE NOTE (copy this block VERBATIM into every follow-on job) -----
issue_spine: issue-kriscendobot-garden-121
issue_url: https://github.com/kriscendobot/garden/issues/121
submitter: jcorbin
----- END ISSUE NOTE -----

Ingest next, in order, from https://github.com/can1357/oh-my-pi `main`, anchored on each file's file-specific commit:

1. `crates/pi-vfs/src/lib.rs`, including its injectable async filesystem and URL-scheme provider architecture. Establish the virtualized-bash distinction: virtual files need not materialize on the host.
2. `crates/pi-builtins/src/lib.rs` and its crate-level public surface.
3. `crates/pi-natives/src/grep.rs`, `glob.rs`, and `fd.rs`, including ripgrep/searcher/PCRE2 and N-API boundaries.

Before concluding the cycle, survey and name the still-deferred remainder in another `scholar-ingest-oh-my-pi-*` follow-on: `pi-natives` `shell.rs`, `iso.rs`, and `ast.rs`; deeper `pi-iso`, `pi-ast`, and `pi-shell` module docs as needed; the fetched-and-classified third-party explainer; the vendored brush README plus `brush-core` / `brush-parser` docs. Preserve the known divergence notes from the parent job, especially that `pi-vfs` is absent from the explainer.
