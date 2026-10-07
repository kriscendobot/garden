---
source_kind: repo
source: crates/pi-shell/src/process.rs
source_repo: can1357/oh-my-pi
source_commit: d93fb847f661359936ade2d0b5d27fb941158545
source_date: 2026-10-06
source_authors: [can1357, roboomp, Brit, Ilia Alshanetsky, oldschoola]
ingested: 2026-10-07
ingested_by: scholar
section_count: 2
status: current
---

> Abstract: The `pi-shell` process module provides PID-reuse-safe process references (pidfd, start time, or handle plus creation time) and a two-wave terminate-then-kill tree shutdown that never signals the harness or its subtree.

| Section | Topics | Status |
|---------|--------|--------|
| [Identity-pinned process references across Linux, macOS, and Windows](../sections/oh-my-pi--crates-pi-shell-src-process--identity-pinned-process-references.md) | shell-runtimes, sandbox-platforms | current |
| [Graceful process-tree termination and harness protection](../sections/oh-my-pi--crates-pi-shell-src-process--graceful-tree-termination-and-harness-protection.md) | shell-runtimes, agent-fleet-durability | current |
