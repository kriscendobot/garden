---
source_kind: repo
source: crates/pi-natives/src/shell.rs
source_repo: can1357/oh-my-pi
source_commit: 04fcdf69ad085059a3d143eb907f4ec13f77db5f
source_date: 2026-10-06
source_authors: [can1357, roboomp, David]
ingested: 2026-10-07
ingested_by: scholar
section_count: 2
status: current
---

> Abstract: The `pi-natives` shell module exports oh-my-pi's brush-backed shell to JavaScript as a persistent `Shell` session and a one-shot `executeShell`, with per-session or per-run `pi-vfs` filesystem injection, minimizer telemetry, and a bounded, backpressured output bridge.

| Section | Topics | Status |
|---------|--------|--------|
| [N-API shell sessions and filesystem injection](../sections/oh-my-pi--crates-pi-natives-src-shell--napi-shell-sessions-and-filesystem-injection.md) | shell-runtimes, virtual-filesystems, llm-agent-frameworks | current |
| [bounded output bridge and drain semantics](../sections/oh-my-pi--crates-pi-natives-src-shell--bounded-output-bridge-and-drain.md) | shell-runtimes, streams | current |
