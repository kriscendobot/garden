---
title: brush-core interpreter and embedding surface
source: crates/vendor/brush-core/src/lib.rs
source_repo: can1357/oh-my-pi
source_commit: ebf2a2aa966cbd899ef4bdabbaf8540ffd00f9b5
source_date: 2026-09-28
source_authors: [can1357]
ingested: 2026-10-07
ingested_by: scholar
topics: [shell-runtimes, programming-language-design]
status: current
---

> Abstract: The vendored brush-core crate root ("Core implementation of the brush shell. Implements the shell's abstraction, its interpreter, and various facilities used internally by the shell") is the embedding surface oh-my-pi's `pi-shell` builds on: `Shell` with `ShellBuilder` and `CreateOptions`, execution contexts and results, extension hooks, and process-spawn observation types, alongside public modules for builtins, expansion, jobs, traps, variables, and a re-exported parser AST.

## Embedding surface

The crate re-exports the types an embedder needs at its root:

- **Shell construction and state.** `Shell`, `ShellBuilder`, `ShellBuilderState`, `CreateOptions`, `ProfileLoadBehavior`, `RcLoadBehavior`, `ShellFd`, and `ShellState`.
- **Execution.** `ExecutionContext`, `CommandArg`, `ExecutionParameters`, `ExecutionResult`, `ExecutionExitCode`, `ExecutionControlFlow`, and `ExecutionSpawnResult`.
- **Process observation and policy.** `ExternalCommandInfo`, `ExternalCommandOutputMarker` and `ExternalCommandOutputMarkers`, `ProcessGroupPolicy`, and `SpawnObserver`, all re-exported from the private interpreter module. These are the hooks an embedder like oh-my-pi uses to track spawned processes (compare `Shell.pids()` in [N-API shell sessions](oh-my-pi--crates-pi-natives-src-shell--napi-shell-sessions-and-filesystem-injection.md)) and to decide process-group placement.
- **Extension.** `ShellExtensions`.
- **Errors and values.** `Error`, `ErrorKind`, `BuiltinError`, `ShellValue`, `ShellVariable`, and `SourceInfo`.
- **Parser types.** A `parser` module re-exports brush-parser's `ast`, parse errors, `ParserImpl`, and source positions and spans, so embedders can use the AST without depending on brush-parser directly.

## Public modules

`arithmetic`, `builtins`, `callstack`, `commands`, `completion`, `env`, `error`, `escape`, `expansion`, `extensions`, `functions`, `history`, `int_utils`, `interfaces`, `jobs`, `namedoptions`, `openfiles`, `options`, `pathcache`, `pathsearch`, `patterns`, `processes`, `results`, `rlimits`, `sourceinfo`, `sys`, `terminal`, `tests`, `timing`, `trace_categories`, `traps`, and `variables`. The interpreter, prompt, regex, brace expansion, keywords, and well-known variables are private.

The `rlimits` module's header (`src/rlimits.rs` at the same tree) explains an embedding constraint: the shell runs inside its host process and subshells are clones rather than forks, so `ulimit` must never call `setrlimit` on the host, where the change would outlive the subshell and cap the host itself. Limits are kept as per-shell `ResourceLimits` state, cloned into subshells, and applied in each external child between fork and exec. This is the shell's `ulimit` semantics made safe for in-process embedding, not a resource budget the host imposes on agent commands.

## Notes

The crate root has only the two-sentence header; this section is a surface inventory. The observation and process-group types are oh-my-pi's vendored API at this commit and may differ from upstream brush releases, since the vendored copy is locally modified ([brush, a bash-compatible shell in Rust](oh-my-pi--crates-vendor-brush-core-readme--brush-bash-compatible-rust-shell.md)).

Source: [crates/vendor/brush-core/src/lib.rs](https://github.com/can1357/oh-my-pi/blob/ebf2a2aa966cbd899ef4bdabbaf8540ffd00f9b5/crates/vendor/brush-core/src/lib.rs) at commit `ebf2a2aa`.
