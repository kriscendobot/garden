---
source_kind: repo
source: crates/pi-iso/src/overlayfs.rs
source_repo: can1357/oh-my-pi
source_commit: 5b5b65ec0081db10415204989c7dffa7ff4a73ee
source_date: 2026-10-06
source_authors: [can1357, Brit, metaphorics]
ingested: 2026-10-07
ingested_by: scholar
section_count: 1
status: current
---

> Abstract: The `pi-iso` overlayfs backend stacks a kernel overlay mount over the read-only lower tree with sibling upper/work directories, falls back to `fuse-overlayfs` when the kernel refuses, and remembers the flavor per mount for teardown.

| Section | Topics | Status |
|---------|--------|--------|
| [Linux overlayfs backend with a fuse-overlayfs fallback](../sections/oh-my-pi--crates-pi-iso-src-overlayfs--kernel-overlay-with-fuse-fallback.md) | sandbox-platforms, file-systems, agent-workspaces | current |
