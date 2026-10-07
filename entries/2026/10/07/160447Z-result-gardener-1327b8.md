---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-10-07T16:04:49Z
job: scholar-ingest-oh-my-pi-rust-core-3
claim: 6cd9ddbf00bfa21f
---
Ingested eight sources (11 sections) for garden issue #121 (jcorbin, "OMP's Been Cooking A Rusty Shell"), continuing `scholar-ingest-oh-my-pi-rust-core-2`:

- `can1357/oh-my-pi` `crates/pi-natives/src/shell.rs` at `04fcdf69` (2 sections): persistent and one-shot brush shells over N-API with session- or run-scoped `ShellFilesystem` (`pi-vfs`) injection and minimizer telemetry; a bounded, backpressured output bridge (64-slot queue, 64 KiB coalescing, 30 s stall timeout, 2 s interrupted-drain bound, lossless drain on success).
- `crates/pi-natives/src/iso.rs` at `a49c7bd5` (1): pi-iso probe/resolve/start/stop/diff over N-API; `ISO_UNAVAILABLE:` prefix distinguishes a missing backend from failure; diff is backend-independent.
- `crates/pi-natives/src/ast.rs` at `e4517e15` (2): ast-grep `astGrep` (files or `scheme://` URLs through the injected filesystem) / `astMatch` (in-memory); `astEdit` is dry-run by default, capped, staged in memory, flushed only after the pass computes (not a cross-file transaction).
- `crates/vendor/brush-parser/README.md` at `7755c6d0` (1), `crates/vendor/brush-parser/src/lib.rs` at `240a4c27` (1), `crates/vendor/brush-core/README.md` at `68d75932` (1), `crates/vendor/brush-core/src/lib.rs` at `ebf2a2aa` (1). brush-parser 0.4.0 is vendored for a here-document-aware `$(...)` fix (oh-my-pi#13307 / reubeno/brush#1066) with a stated removal condition; brush-core 0.5.0 is locally patched but its README is unchanged upstream text. brush-core's `rlimits::ResourceLimits` is embedded-safe `ulimit` state applied to children between fork and exec, never `setrlimit` on the host.
- Third-party explainer https://yeluo45.github.io/oh-my-pi-design/en/docs/01-rust-core as `web--oh-my-pi-design-rust-core` (2: account + divergence ledger), sha256 `ae1a74c3…` (matches the parent job's fetch). Recorded as a secondary description with `content_caveat`. Ledger preserves the parent's divergences (omits `pi-vfs`; minimizer-as-permission-gate; wrong vendored-brush path) and adds: wrong vendoring rationale; invented `parseAst`/`findNode`/`replaceNode`/`serializeAst` and per-language WASM; invented `FsPrimitive`/`snapshot`/`restore` API, missing ZFS and Windows block clone, wrong diff mechanism; no `ResourceLimits`/`setrlimit` in pi-shell (but `kill_tree` and graceful tree termination are real). The JS-fallback loader claim is left unverified.

Preserved distinction: `pi-vfs` virtual files need not materialize on the host; `grep`, `glob`, and now `ast` accept the injected filesystem; `fuzzyFind` remains host-path-only.

Topics touched: shell-runtimes, virtual-filesystems, llm-agent-frameworks, streams, agent-workspaces, file-systems, sandbox-platforms, programming-language-design, tooling. New concepts: `brush-shell`, `pi-ast-grep`, `oh-my-pi-design-explainer` (routes non-existent explainer symbols such as `MinimizerWarning`/`FsPrimitive` to the ledger). Rows added to concepts `pi-iso`, `pi-shell-output-minimizer`, `pi-vfs`, `pi-native-search`. Updated `keywords.md`, `concepts/README.md`, `sources/README.md`.

Foreign-content classification: `classify-foreign-content.sh` returned `proceed_unclassified` (TYPESAFE_API_KEY absent; no Jev usage); the explainer was read as data under the standing untrusted-data discipline and the gap is recorded in its source page. All repo sources came from a scratch clone and are exempt.

Deferred and posted as follow-on `scholar-ingest-oh-my-pi-rust-core-4` (issue note verbatim): `pi-natives/src/shell/vfs.rs`, deeper `pi-iso` (`rcopy.rs`, `overlayfs.rs`, resolve rules), `pi-ast` (`language/mod.rs`, `ops.rs`), and `pi-shell` (`process.rs`, `cancel.rs`, survey of `shell.rs`) module docs. The deeper module-doc pass was deferred because this cycle took the explainer and all four brush files.

Integrity gate: `library-link-check.sh` OK for all eight source clusters on the committed origin/journal2 tip; `regenerate-topics-counts.sh --check` current. Regenerated and landed `sections/README.md` and topic counts.

Self-improvement: vendored-crate READMEs vary in whether they document local patches (brush-parser does, brush-core does not); for vendored dependencies, record in the source page whether the README is upstream text or a local-delta inventory, so readers do not take upstream claims as describing the patched copy.
