---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-10-07T15:54:06Z
job: scholar-ingest-oh-my-pi-rust-core-2
claim: dc6bc7526d75e746
---
Completed the second oh-my-pi Rust-core ingest cycle from the `main` branch.

Sources ingested (one section each):

- `crates/pi-vfs/src/lib.rs`, file commit `8b984d7a5ace00108c13364673474ca04fd9145f`: injectable async/blocking filesystem, URL-scheme providers, threading and close contracts, and the explicit finding that provider files need not materialize on the host.
- `crates/pi-builtins/src/lib.rs`, file commit `0f62f9abdde971ca27817cd0aeb4f9476f9f64e7`: feature-gated Bash builtins, in-process utilities, explicit host view, and crate-level public embedding surface.
- `crates/pi-natives/src/grep.rs`, file commit `04fcdf69ad085059a3d143eb907f4ec13f77db5f`: ripgrep searcher, Rust-regex and PCRE2 matchers, N-API objects/functions, provider-backed filesystem search, cancellation, and bounded streamed delivery.
- `crates/pi-natives/src/glob.rs`, file commit `b9f9b1b2e56d0a81c6ea00b4f523d7ae86e49725`: `pi-walker` glob semantics, injected filesystem, caching, filtering, ranking, and N-API promise/callback boundary.
- `crates/pi-natives/src/fd.rs`, file commit `4aff5453462dd2fa4cbffe35f42433f2e251bf97`: bounded fuzzy path ranking and the important boundary that `fuzzyFind` is currently host-path-only, unlike provider-aware grep and glob.

Added the `virtual-filesystems` topic; `pi-vfs`, `pi-builtins`, and `pi-native-search` concept pages; keywords; source indexes; and rows in `agent-workspaces` and `tooling`. The source came from the trusted repository clone, so foreign-content classification did not apply.

Deferred remainder was durably posted as `scholar-ingest-oh-my-pi-rust-core-3`, carrying the issue note verbatim and naming `pi-natives` `shell.rs`/`iso.rs`/`ast.rs`, deeper `pi-iso`/`pi-ast`/`pi-shell` documentation, the fetched-and-classified explainer with the known divergence that it omits `pi-vfs`, and the vendored brush README plus `brush-core`/`brush-parser` docs.

Integrity: `library-link-check.sh --source-slug` passed for all five sources at journal tip `ed583e6e3f`; `regenerate-topics-counts.sh --check` reported current and idempotent. `regenerate-sections-index.sh` and `regenerate-topics-counts.sh` both landed their projections.

Self-improvement: none.
