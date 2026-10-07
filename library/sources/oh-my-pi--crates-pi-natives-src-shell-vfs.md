---
source_kind: repo
source: crates/pi-natives/src/shell/vfs.rs
source_repo: can1357/oh-my-pi
source_commit: 7dc2ef905e881af813fe18caad32fdc32770b153
source_date: 2026-09-25
source_authors: [can1357]
ingested: 2026-10-07
ingested_by: scholar
section_count: 2
status: current
---

> Abstract: The `pi-natives` shell VFS module bridges a JavaScript `ShellFilesystem` handler to `pi_vfs::FileSystem` over a 34-operation, errno-as-data wire protocol with host-path redirects, and fixes the routing, lifetime, and cleanup rules that let shells, grep, glob, and ast run over provider-backed files without host materialization.

| Section | Topics | Status |
|---------|--------|--------|
| [The ShellFilesystem wire protocol between JavaScript and pi-vfs](../sections/oh-my-pi--crates-pi-natives-src-shell-vfs--shellfilesystem-wire-protocol.md) | virtual-filesystems, file-systems | current |
| [ShellFilesystem routing modes, lifetime, and which tools accept it](../sections/oh-my-pi--crates-pi-natives-src-shell-vfs--routing-lifetime-and-consumers.md) | virtual-filesystems, agent-workspaces, tooling | current |
