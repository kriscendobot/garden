---
title: N-API isolation lifecycle and the unavailable-error protocol
source: crates/pi-natives/src/iso.rs
source_repo: can1357/oh-my-pi
source_commit: a49c7bd5214a7d92a7f64542b91fa475bdb2eb47
source_date: 2026-10-06
source_authors: [can1357, Brit]
ingested: 2026-10-07
ingested_by: scholar
topics: [agent-workspaces, file-systems, sandbox-platforms]
status: current
---

> Abstract: `pi-natives`' `iso` module is a thin N-API shim over the `pi-iso` platform abstraction: it exposes backend kind, probe, resolve, start, stop, and diff as JavaScript functions, moves blocking syscalls and probing CLIs off the JavaScript thread, and prefixes "backend not installed" errors with `ISO_UNAVAILABLE:` so callers can fall back instead of failing. Its diff is backend-independent: `git diff` for a Git merged tree, otherwise a tree walk.

## Exported surface

The module header lists the mirror of `pi_iso::IsolationBackend` across the FFI boundary:

- `isoBackend()` returns the platform-native backend kind for this build target.
- `isoProbe(kind?)` reports `{ available, reason, kind }` for a requested backend, or for the native one when `kind` is omitted.
- `isoResolve(preferred?)` lets the platform abstraction pick the best available backend, treating `preferred` as a hint, and returns `{ kind, candidates, fellBack, reason }`. `candidates` lists host-available backends in retry order starting with `kind`. Probes may spawn CLIs, so resolution runs on the native blocking pool.
- `isoStart(kind?, lower, merged)` materializes `merged` as a writable view of `lower`; `isoStop(kind?, merged)` tears it down. Both are synchronous syscalls wrapped in `spawn_blocking`, so JavaScript sees an ordinary promise.
- `isoDiff(lower, merged)` returns one `IsoFileChange` per file: a path relative to `merged`, an `op` (`Added`, `Modified`, or `Removed`), and `diff`, which is unified-diff text for text files and `null` for binary files, whose bytes callers read from `merged` themselves.

`IsoBackendKind` is a numeric enum so JavaScript can `switch` without string comparisons: `Apfs`, `Btrfs`, `Zfs`, `LinuxReflink`, `Overlayfs`, `WindowsBlockClone`, `Projfs`, `Rcopy`. These are the same eight backends the crate root names ([cross-platform copy-on-write workspaces](oh-my-pi--crates-pi-iso-src-lib--cross-platform-copy-on-write-workspaces.md)).

## Diff is uniform across backends

Every backend inherits the same default `diff()` body, so `isoDiff` always calls it through the always-available `Rcopy` backend. Backend choice affects only the start and stop lifecycle. The default diff uses `git diff` when `merged/.git` exists, and otherwise walks the trees, skipping files whose modification times show no change.

## Distinguishing "unavailable" from failure

`IsoError::Unavailable` is serialized as `ISO_UNAVAILABLE: <message>`, and `IsoError::Other` passes its message through unchanged. `isoIsUnavailableError(message)` returns true when a caught error message starts with the prefix or contains it after a space. This lets TypeScript treat "this backend isn't installed" as a reason to try the next candidate rather than a hard error, which is how the crate's probe-then-fall-back design reaches the JavaScript caller.

## Boundary

Nothing in the shim adds confinement: it starts, stops, and diffs filesystem views. The process-authority boundary recorded for `pi-iso` itself applies unchanged.

Source: [crates/pi-natives/src/iso.rs](https://github.com/can1357/oh-my-pi/blob/a49c7bd5214a7d92a7f64542b91fa475bdb2eb47/crates/pi-natives/src/iso.rs) at commit `a49c7bd5`.
