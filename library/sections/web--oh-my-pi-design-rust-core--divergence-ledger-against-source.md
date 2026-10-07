---
title: Divergence ledger against the oh-my-pi source
source_kind: web
source_url: https://yeluo45.github.io/oh-my-pi-design/en/docs/01-rust-core
source_content_sha256: ae1a74c3c049f0f27fbc465e74b65cd311e2fbc67c0b980321dcdca4e2649098
source_authors: [yeluo45]
source_date: 2026-10-07
ingested: 2026-10-07
ingested_by: scholar
topics: [llm-agent-frameworks, shell-runtimes, agent-workspaces, virtual-filesystems]
status: current
---

> Abstract: Checked against oh-my-pi `main` at `53f253fb`, the explainer omits `pi-vfs`, invents most of the APIs it quotes, turns the output minimizer into a permission gate, misstates the vendored-brush path and rationale, and misdescribes `pi-iso`'s backends and diff. Its broad shape (AST, shell, and workspace crates behind N-API, with copy-on-write backends and process-tree kills) is right. Prefer the repo-sourced sections for every contract.

## Ledger

Each row names the explainer's claim, what the source shows, and the repo-sourced section to trust instead.

| Explainer claim | Source at `53f253fb` | Trust instead |
|---|---|---|
| Three Rust crates make up the core. | The core also includes `pi-vfs` (an injectable async filesystem with URL-scheme providers, so shell files need not materialize on the host), `pi-builtins`, `pi-walker`, and others. The page never mentions `pi-vfs`, which is what makes the shell virtualizable. | [injectable virtual filesystem](oh-my-pi--crates-pi-vfs-src-lib--injectable-virtual-filesystem.md) |
| The minimizer is a safety layer: a `MinimizerWarning` enum flags `rm -rf /`, `curl \| sh`, `sudo`, `chmod 777`, unpinned `npm install`, and non-allowlisted network access, and the agent prompts the user. | The minimizer is an opt-in **output** reducer that rewrites captured stdout and stderr and preserves the original as an `artifact://` reference. No `MinimizerWarning` or `PrivilegeEscalation` symbol exists. Package-install handling compacts output and does not reject unpinned installs. The escalation check the page describes resembles the JavaScript example hook `packages/coding-agent/examples/hooks/permission-gate.ts` (recursive `rm`, `sudo`, `chmod`/`chown 777`). Its settings-file hash check is a trust gate on its own configuration, not on commands. | [opt-in command-output minimization](oh-my-pi--crates-pi-shell-src-minimizer--opt-in-command-output-minimization.md), [N-API shell sessions](oh-my-pi--crates-pi-natives-src-shell--napi-shell-sessions-and-filesystem-injection.md) |
| Brush is vendored at `crates/brush-core-vendored/` and `crates/brush-builtins-vendored/` via git subtree, because `cargo build` cannot reach the network. | The vendored crates are `crates/vendor/brush-core` and `crates/vendor/brush-parser`, routed by `[patch.crates-io]`. No brush-builtins directory is vendored. The stated reason for vendoring brush-parser is a bug fix: release 0.4.0 re-parses `$(...)` bodies without here-document awareness. | [vendored brush-parser and its here-document fix](oh-my-pi--crates-vendor-brush-parser-readme--vendored-parser-with-heredoc-fix.md) |
| `pi-ast` exposes `parseAst`/`findNode`/`replaceNode`/`serializeAst`, with per-language WASM grammars loaded via `loadLanguage`. | The native surface is ast-grep based: `astGrep` (files), `astMatch` (in-memory), and `astEdit` (pattern-to-template rewrites, dry run by default). No WASM loading appears in `pi-ast`'s language module. | [ast-grep search](oh-my-pi--crates-pi-natives-src-ast--ast-grep-search-over-injected-filesystems.md), [staged structural rewrite](oh-my-pi--crates-pi-natives-src-ast--staged-dry-run-structural-rewrite.md) |
| `pi-iso` exposes `FsPrimitive` with `snapshot`/`restore`/`discard`; the fallback is `cp -r`; the diff compares mtime, size, and content hash over two snapshots. | The API is lifecycle-shaped: `BackendKind` with probe, resolve, start, stop, and diff over a read-only `lower` and a writable `merged`. The eight backends include ZFS and Windows block cloning, which the page omits. `Rcopy` uses `git worktree` for a Git lower tree. The diff delegates to `git diff` when `merged/.git` exists. | [cross-platform copy-on-write workspaces](oh-my-pi--crates-pi-iso-src-lib--cross-platform-copy-on-write-workspaces.md), [N-API isolation lifecycle](oh-my-pi--crates-pi-natives-src-iso--napi-isolation-lifecycle.md) |
| `pi-shell` enforces `ResourceLimits` (CPU, memory, fds, pids) via `setrlimit`/JobObject. | `pi-shell`'s `process.rs`, `windows.rs`, and `cancel.rs` contain no `ResourceLimits` or `setrlimit`. `process.rs` does have `kill_tree` and a graceful terminate-then-kill tree shutdown, so that part of the account holds. The nearest real mechanism is vendored brush-core's `rlimits::ResourceLimits`, which holds the shell's own `ulimit` overrides as shell state and applies them to each external child between fork and exec, never calling `setrlimit` on the embedding host. That is a user-set `ulimit`, not the host-imposed CPU, memory, fd, and pid budget the page describes. | [embedded shell public surface](oh-my-pi--crates-pi-shell-src-lib--embedded-shell-public-surface.md) |
| The native loader falls back to JavaScript when the native module is missing; there are three crates times four platforms, so twelve binaries. | The JavaScript fallback was not verified this cycle. The binary arithmetic does not match: `pi-natives` is a single N-API crate spanning many modules (grep, glob, fd, shell, iso, ast, clipboard, html, and more), not one binary per Rust crate. | (deferred) |

## Reading the page safely

The page's code blocks are illustrative pseudocode presented as source. Treat any quoted symbol from it as unverified until it is found in the repo. Its performance table has no reproducible methodology and is not corroborated by any repo-sourced section.

Source: [01 · Rust Core — pi-ast, pi-shell, pi-iso](https://yeluo45.github.io/oh-my-pi-design/en/docs/01-rust-core), fetched 2026-10-07 (sha256 `ae1a74c3`), compared with [can1357/oh-my-pi](https://github.com/can1357/oh-my-pi/tree/53f253fb709fe890adf1fa37f0bc69cf02a5d86c) at `53f253fb`.
