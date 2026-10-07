---
title: N-API shell sessions and filesystem injection
source: crates/pi-natives/src/shell.rs
source_repo: can1357/oh-my-pi
source_commit: 04fcdf69ad085059a3d143eb907f4ec13f77db5f
source_date: 2026-10-06
source_authors: [can1357, roboomp, David]
ingested: 2026-10-07
ingested_by: scholar
topics: [shell-runtimes, virtual-filesystems, llm-agent-frameworks]
status: current
---

> Abstract: `pi-natives`' shell module exports oh-my-pi's brush-backed shell to JavaScript as both a persistent `Shell` session and a one-shot `executeShell`, each streaming output through a callback and resolving to an exit/cancel/timeout result with optional minimizer telemetry. A `ShellFilesystem` (from `pi-vfs`) can back a whole session or replace it for a single run, so shell file operations need not touch the host.

## Two entry points

The module header is one line: "Brush-based shell execution exported via N-API." It wraps `pi_shell`'s core types one-for-one.

- **`Shell`** (an N-API class) is a persistent brush-core session. Its constructor takes `ShellOptions`: `sessionEnv` (applied once per session), `snapshotPath` (a file sourced on session creation), `minimizer` options, and a `filesystem`. Methods: `run(options, onChunk)` returning a promise; `abort()` (succeeds even when nothing is running); `liveBackgroundJobCount()`, which reaps finished `&`/`nohup` children first so the host can keep a per-call shell alive instead of dropping it, since dropping kills its background processes; and `pids()`, which synchronously lists the still-alive processes spawned by the in-flight run (foreground commands, pipeline stages, `&` jobs) in spawn order. Builtins run in-process and never appear in `pids()`.
- **`executeShell(options, onChunk)`** creates a fresh session per call, combining session-scoped and per-command fields in one `ShellExecuteOptions`.

Per-run options are `command`, `cwd`, `env` (this command only), `timeoutMs`, and an abort `signal`; both feed a native cancel token.

## Result shape

`ShellRunResult` carries `exitCode` (when the command completed normally), `cancelled`, `timedOut`, `workingDir` after completion, and `minimized`. `minimized` is present only when the output minimizer actually rewrote the output. It then carries the dispatch label (`"git"`, `"pipeline:gradle"`, `"pipeline+builtin"`), the minimized `text`, the full `originalText`, and input and output byte counts. The session layer is expected to persist `originalText` as an artifact, splice an `artifact://<id>` reference into the text the agent sees, and replace any already-streamed raw chunks with the minimized text.

## Minimizer options across the boundary

`MinimizerOptions` is opt-in (`enabled` absent or false means disabled) and adds `only`/`except` program lists, a `maxCaptureBytes` ceiling (default 4 MiB, beyond which raw output is passed through), a `sourceOutlineLevel` for `cat <source-file>` (`default` or `aggressive`, which strips function bodies), and a `legacyFilters` kill-switch deferring to `OMP_MINIMIZER_LEGACY_FILTERS`. `settingsPath` names a TOML override file; `settingsHash`, an xxHash64 hex digest, makes the engine refuse a settings file whose contents do not match, which the source calls "a lightweight trust gate for agent-controllable paths". That gate protects the minimizer's own configuration; it does not screen commands, consistent with the parent cycle's correction that the minimizer is an output reducer and not a permission gate ([opt-in command-output minimization](oh-my-pi--crates-pi-shell-src-minimizer--opt-in-command-output-minimization.md)).

## Filesystem injection

`ShellOptions.filesystem` backs every run of a session, and native host access applies when it is absent. `ShellRunOptions.filesystem` replaces the session's filesystem for that run only; later runs revert to the session's. `ShellExecuteOptions.filesystem` backs the one-shot command. All three are `ShellFilesystem` values defined in the sibling `shell/vfs.rs` and converted to the `pi-vfs` filesystem the core shell consumes, the same injection that lets virtual files stay off the host ([injectable virtual filesystem](oh-my-pi--crates-pi-vfs-src-lib--injectable-virtual-filesystem.md)). The binding also exports two Windows path helpers, `expandWindowsLongPath` and `getWindowsShortPath`, which are identity functions on other platforms.

Source: [crates/pi-natives/src/shell.rs](https://github.com/can1357/oh-my-pi/blob/04fcdf69ad085059a3d143eb907f4ec13f77db5f/crates/pi-natives/src/shell.rs) at commit `04fcdf69`.
