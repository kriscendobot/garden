---
title: N-API ripgrep search
source: crates/pi-natives/src/grep.rs
source_repo: can1357/oh-my-pi
source_commit: 04fcdf69ad085059a3d143eb907f4ec13f77db5f
source_date: 2026-10-06
source_authors: [can1357, roboomp, Brit, zamo, radkawar]
ingested: 2026-10-07
ingested_by: scholar
topics: [tooling, virtual-filesystems]
status: current
---

# N-API ripgrep search

> Abstract: `pi-natives` exposes ripgrep's matcher and searcher machinery to JavaScript as in-memory `search` and filesystem `grep` N-API functions, with Rust-regex and PCRE2 matching, injected virtual filesystems, cancellation, limits, context, count modes, and bounded streamed delivery.

The binding uses the ripgrep ecosystem's `grep-searcher`, `grep-regex`, `grep-pcre2`, and matcher traits. It shares `pi-builtins::CompiledMatcher` and the process-wide `OMP_PCRE2_JIT` policy with the in-process `grep` and `rg` builtins, so the shell and JavaScript binding do not grow independent regular-expression policies.

The synchronous `search` entry point searches a JavaScript string, Buffer, or `Uint8Array`; `has_match` is its boolean fast path. The asynchronous `grep` entry point walks a file or directory, accepts glob and known/custom type filters, controls hidden and gitignore behavior, and returns content rows, per-file counts, or files-with-matches. It supports global offset and limit, per-file limits, before/after context, multiline matching, line truncation, cancellation, and timeout.

Filesystem search accepts either a host path or an absolute provider URL and obtains all metadata, traversal, and file bytes through an optional `ShellFilesystem`. This keeps grep on the same `pi-vfs` boundary as the embedded shell: provider-backed content can be searched without first becoming a host file. Oversized files are deferred behind normal files and searched through a bounded leading window, allowing the ordinary match budget to avoid unnecessary large-file work.

`onMatches` streams batches through an N-API threadsafe callback. The native side reserves a bounded eight-batch window before nonblocking JavaScript delivery, pauses producers behind slow consumers, polls cancellation while waiting, and drains acknowledgements on successful completion. A separate legacy callback receives returned matches only after the search and is incompatible with streaming delivery. The N-API structs and string enum are the wire contract; the ripgrep types remain internal Rust implementation details.

Source: [crates/pi-natives/src/grep.rs](https://github.com/can1357/oh-my-pi/blob/04fcdf69ad085059a3d143eb907f4ec13f77db5f/crates/pi-natives/src/grep.rs) at commit `04fcdf69`.
