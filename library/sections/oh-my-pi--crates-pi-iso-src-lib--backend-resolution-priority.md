---
title: pi-iso backend resolution priority and clone candidates
source: crates/pi-iso/src/lib.rs
source_repo: can1357/oh-my-pi
source_commit: e58c443c556832a0c9db2aafd53beef54c75f004
source_date: 2026-10-06
source_authors: [can1357, Brit]
ingested: 2026-10-07
ingested_by: scholar
topics: [agent-workspaces, sandbox-platforms]
status: current
---

> Abstract: `pi_iso::resolve(preferred)` probes the preferred backend first. It then walks a fixed per-OS automatic order (Linux: btrfs, ZFS, reflink, overlayfs, Rcopy; macOS: APFS, ZFS, Rcopy; Windows: block clone, ProjFS, Rcopy) and returns every host-available backend in retry order. `Rcopy` is the guaranteed last resort. Resolution is only a host-level probe, so callers must still be ready to retry when `start` rejects a specific path pair.

This section adds to [cross-platform copy-on-write workspaces](oh-my-pi--crates-pi-iso-src-lib--cross-platform-copy-on-write-workspaces.md), which was ingested from the same commit but did not record the resolution rules that the [N-API `isoResolve` binding](oh-my-pi--crates-pi-natives-src-iso--napi-isolation-lifecycle.md) forwards.

## Automatic order per platform

| Platform | Order |
|----------|-------|
| Linux | `Btrfs`, `Zfs`, `LinuxReflink`, `Overlayfs`, `Rcopy` |
| macOS | `Apfs`, `Zfs`, `Rcopy` |
| Windows | `WindowsBlockClone`, `Projfs`, `Rcopy` |
| other | `Rcopy` |

## Caller priority (doc comment on `resolve`)

1. If `preferred` is given and its probe reports available, use it as-is.
2. Otherwise walk the automatic order, skipping `preferred` if present.
3. `Rcopy` is the final automatic candidate "and is expected to be available on every platform". If every probe fails, the candidate list is forced to `[Rcopy]`.

"This is only a host-level probe. Some backends still reject a specific `lower`/`merged` pair at `start` time (cross-device reflinks, non-subvolume btrfs paths, non-ZFS mountpoints)."

## The `Resolution` record

- `kind` is the first host-available backend to try.
- `candidates` lists every host-available backend in fallback order, starting with `kind`, "so callers can retry when a backend is unavailable for a specific filesystem path."
- `fell_back` is true when `kind` is not the preferred backend, or, with no preference, not the platform's first automatic choice.
- `reason` carries the first unavailable probe's explanation: the preferred backend's if it failed, otherwise the first failing automatic candidate's.

## Tree-cloning candidates

`clone_candidates(preferred)` is a narrower list for callers that need an in-place directory-tree clone. It includes only backends whose `clones_tree()` is true (`Apfs`, `LinuxReflink`, `WindowsBlockClone`) and that probe available, with an available preferred cloner first. Non-cloning backends, including `Rcopy`, are excluded, so this list can be empty.

Source: [crates/pi-iso/src/lib.rs](https://github.com/can1357/oh-my-pi/blob/e58c443c556832a0c9db2aafd53beef54c75f004/crates/pi-iso/src/lib.rs) at commit `e58c443c`.
