---
title: Feature-gated shell builtins
source: crates/pi-builtins/src/lib.rs
source_repo: can1357/oh-my-pi
source_commit: 0f62f9abdde971ca27817cd0aeb4f9476f9f64e7
source_date: 2026-10-06
source_authors: [Brit, can1357, Mike Ruangutai]
ingested: 2026-10-07
ingested_by: scholar
topics: [tooling, virtual-filesystems]
status: current
---

# Feature-gated shell builtins

> Abstract: `pi-builtins` assembles oh-my-pi's Bash-compatible builtins and a broad suite of in-process command-line utilities behind Cargo features, exposing factories and embedding hooks while routing utility filesystem access through an explicit shell host.

The crate conditionally compiles the familiar shell builtins, including `alias`, `cd`, `declare`, `eval`, `jobs`, `read`, `set`, `trap`, and `wait`, with platform gates for operations such as `exec`, `kill`, `printf`, `suspend`, `ulimit`, and `umask`. It separately carries in-process utility implementations such as `cat`, `cp`, `diff`, `fd`, `find`, `grep`, `jq`, `ls`, `rg`, `rm`, `sed`, `sort`, `stat`, `tail`, `wc`, and `xargs`. Shared helper modules consolidate file metadata, backup/progress behavior, process snapshots, process selection, regular-expression translation, and checksums.

The utilities run against the explicit `host::Host` view supplied by the embedding shell. In combination with `pi-vfs`, this means core utilities can operate over an injected filesystem instead of assuming that every file exists on the operating system's filesystem.

The public crate surface is deliberately smaller than its module inventory. It exports `ShellBuilderExt`; `BuiltinSet` and the default/process/utility factory functions; the two-engine `CompiledMatcher` and PCRE2 JIT policy shared with the native grep binding when grep is enabled; host runtime-state hooks; `withheld_builtin`; optional process snapshot and operating-system process primitives; and a macro for plus-or-minus flag arguments. This is a Rust embedding surface, not an N-API boundary. JavaScript-facing native exports live in `pi-natives`.

Source: [crates/pi-builtins/src/lib.rs](https://github.com/can1357/oh-my-pi/blob/0f62f9abdde971ca27817cd0aeb4f9476f9f64e7/crates/pi-builtins/src/lib.rs) at commit `0f62f9ab`.
