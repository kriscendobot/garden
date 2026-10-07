---
title: Cross-platform copy-on-write workspaces
source: crates/pi-iso/src/lib.rs
source_repo: can1357/oh-my-pi
source_commit: e58c443c556832a0c9db2aafd53beef54c75f004
source_date: 2026-10-05
source_authors: [Brit, can1357]
ingested: 2026-10-07
ingested_by: scholar
topics: [sandbox-platforms, file-systems, agent-workspaces]
status: current
---

> Abstract: `pi-iso` presents a writable merged workspace over a read-only source tree, selecting native copy-on-write or projection mechanisms by platform and falling back to a Git worktree or recursive copy. It reports changes through `git diff` for Git trees, making workspace lifecycle and patch production one abstraction, but it does not itself confine process authority.

## Backend model

The isolation PAL gives callers a writable `merged` view of a read-only `lower` tree without requiring a deep copy. Tree-cloning backends can omit selected top-level entries.

- macOS uses APFS `clonefile(2)`.
- Linux probes btrfs, ZFS, per-file `FICLONE` reflinks, and kernel overlay mounts, with `fuse-overlayfs` available when the overlay syscall is denied.
- Windows probes block cloning and ProjFS.
- `Rcopy` is always available. It uses `git worktree` for a Git lower tree and a recursive copy otherwise.

The automatic order prefers platform-native copy-on-write mechanisms and ends with `Rcopy`. An unavailable native prerequisite is a probe result that permits fallback, rather than a fatal workload error.

## Diff contract

Every backend can surface the workload's changes. For Git-backed tasks, `IsolationBackend::diff` delegates to `git diff`, producing bytes suitable for downstream `git apply`. The non-Git `Rcopy` path walks both trees and uses size and modification time as a cheap check before content comparison.

## Boundaries and comparisons

The name "isolation" refers to filesystem workspace construction and change capture. It is not a process sandbox or an authority boundary. Endo's `packages/sandbox` drivers (Podman and bubblewrap) constrain process execution, while `pi-iso` arranges the tree that execution sees. The mechanisms can therefore be complementary, but are not substitutes.

The garden's per-job Git worktrees share the `Rcopy` preference for cheap, independently writable Git checkouts. The analogy stops at lifecycle orchestration: garden worktrees do not select overlay, reflink, or ProjFS backends, and `GIT_CEILING_DIRECTORIES` plus the bot `gh` wrapper constrain Git discovery and credentials rather than virtualizing filesystem access.

Source: [crates/pi-iso/src/lib.rs](https://github.com/can1357/oh-my-pi/blob/e58c443c556832a0c9db2aafd53beef54c75f004/crates/pi-iso/src/lib.rs) at commit `e58c443c`.
