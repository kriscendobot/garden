---
title: ast-grep search over injected filesystems
source: crates/pi-natives/src/ast.rs
source_repo: can1357/oh-my-pi
source_commit: e4517e1586ac56d2806a9a466e0f3f58aa4b587d
source_date: 2026-10-05
source_authors: [can1357, roboomp, HvC]
ingested: 2026-10-07
ingested_by: scholar
topics: [programming-language-design, tooling, virtual-filesystems]
status: current
---

> Abstract: `pi-natives`' `ast` module exposes structural code search to JavaScript through ast-grep over `pi-ast`'s language registry: `astGrep` walks files on a host path or `scheme://` URL through an injectable filesystem, and `astMatch` runs the same patterns against an in-memory string. Results are deterministically ordered, paged with offset and limit (default 50), and carry non-fatal parse diagnostics rather than failing the search.

## Two search entry points

The module header reads "AST-aware structural search and rewrite powered by ast-grep." Shared helpers come from `pi_ast::ops` (language resolution, pattern compilation, edit application), so the native binding is a thin layer over `pi-ast`.

- **`astGrep(options)`** takes one or more `patterns` (deduplicated, OR'ed together), an optional `lang` override, a `path` that may be a single file or a directory and may be "a host path or an absolute `scheme://` URL", an optional `glob` relative to the search root, a rule `selector`, a `strictness`, `limit`/`offset` paging, `includeMeta` for metavariable bindings, a cancel signal, `timeoutMs`, and a `filesystem`.
- **`astMatch(options)`** is "the file-free counterpart": callers that already hold source text (streaming buffers, generated code, editor contents) avoid a temporary-file round trip. `lang` is required because there is no path to infer it from.

Strictness is a string enum over ast-grep's levels: `cst`, `smart` (the default), `ast`, `relaxed`, `signature`, and `template`.

## Candidate discovery through the injected filesystem

Candidates are resolved, walked, and read through the supplied `ShellFilesystem` (native when absent). A file path yields one candidate. A directory is walked with `pi-walker` using that filesystem: hidden files included, `.gitignore` honored, `.git` skipped, symlinks never followed, `node_modules` excluded unless the glob mentions it. Without an explicit `lang`, only files whose extensions map to a supported language are candidates. With one, every file is treated as that language. This places structural search with `grep` and `glob` among the native tools that accept the injected filesystem, whereas the parent cycles recorded `fuzzyFind` as host-path-only ([N-API ripgrep search](oh-my-pi--crates-pi-natives-src-grep--napi-ripgrep-search.md), [N-API fuzzy path discovery](oh-my-pi--crates-pi-natives-src-fd--napi-fuzzy-path-discovery.md)).

## Results and diagnostics

Each `AstFindMatch` carries the display path, matched text, UTF-8 byte offsets, 1-based line and column ranges, and optional metavariable captures. Matches are ordered by path, then position, then discovery sequence. Paging keeps only a bounded heap of the best `offset + limit` matches rather than every hit. `AstFindResult` reports the page, `totalMatches` before paging, `filesWithMatches`, `filesSearched`, `limitReached`, and `parseErrors`. A file whose syntax tree contains error nodes is reported in `parseErrors` but still searched, and an unreadable file or a pattern that fails to compile for one language becomes a diagnostic rather than an aborted search.

Source: [crates/pi-natives/src/ast.rs](https://github.com/can1357/oh-my-pi/blob/e4517e1586ac56d2806a9a466e0f3f58aa4b587d/crates/pi-natives/src/ast.rs) at commit `e4517e15`.
