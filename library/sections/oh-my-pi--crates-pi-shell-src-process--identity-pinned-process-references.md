---
title: Identity-pinned process references across Linux, macOS, and Windows
source: crates/pi-shell/src/process.rs
source_repo: can1357/oh-my-pi
source_commit: d93fb847f661359936ade2d0b5d27fb941158545
source_date: 2026-10-06
source_authors: [can1357, roboomp, Brit, Ilia Alshanetsky, oldschoola]
ingested: 2026-10-07
ingested_by: scholar
topics: [shell-runtimes, sandbox-platforms]
status: current
---

> Abstract: `pi_shell::process::Process` is a "stable process reference" whose identity survives PID reuse. Linux holds a pidfd, macOS pins the kernel-reported start time, and Windows holds an owned process handle plus the creation time. Signals, child enumeration, and exit waits go through that pinned identity, so they never reach an unrelated process that later received the same PID.

## Module and public surface

The module header is one line, "Cross-platform process tree management." The public `Process` type wraps a per-platform implementation and exposes `from_pid`, `from_path` (exact executable-path match), `pid`, `ppid`, `args`, `signal`, `kill_tree`, `group_id`, `children`, `status`, `terminate_tree`, and `wait_for_exit`. `ProcessStatus` is defined in `pi-builtins` next to the process-table snapshots its process builtins read, and re-exported here, "so this module — and `pi-natives` through it — keeps one status type for both concerns."

## How identity is pinned

- **Linux:** "Stable Linux process reference backed by a pidfd." Children come from `/proc/<pid>/task/<tid>/children`, with a `/proc` scan as fallback on kernels without `CONFIG_PROC_CHILDREN`. Each candidate is checked for duplicates, for still running, and for being currently parented to `self`. `exited()` resolves when the pidfd becomes readable.
- **macOS:** "macOS does not expose pidfds; identity is pinned via the kernel-reported process start time so a recycled PID does not silently impersonate the original target." Each query re-reads `proc_bsdinfo` and accepts it only if the start time is unchanged. Children come from a one-shot `proc_listallpids` scan into a `ppid -> [pids]` map, because `proc_listchildpids` returns nothing for self-queries. `exited()` uses a kqueue `NOTE_EXIT` filter.
- **Windows:** an owned process handle plus the creation time, "which pins identity even if the PID is recycled while we hold the handle." `args` reads the command line through the pinned handle. `descendants` takes a single Toolhelp snapshot per walk, because recursing per node would cost `O(N · D)` snapshots. A child PID is accepted only if that process was created after `self`. Windows never rewrites a recorded parent ID, so an orphan older than `self` can masquerade as its child. `exited()` uses a thread-pool wait on the handle, so no thread is parked per waiter.

## Signals through the pinned identity

- `signal(sig)` sends to "this process only, through its pinned identity, so it never reaches a process that reused the pid after this one was reaped. On Windows the process is terminated whatever `signal` is."
- `kill_tree(signal)` sends to the process and its descendants, children first. It defaults to the POSIX hard-kill signal and returns the number of processes signaled. On Windows "the `signal` argument is ignored and the entire tree is hard-killed via `TerminateProcess`."
- Descendant walks are post-order (leaves first) and deduplicated by PID, "so concurrent reparenting cannot trap us in a cycle."

Graceful shutdown, which escalates from a polite signal to a hard kill and spares the host process, is covered in [graceful tree termination and harness protection](oh-my-pi--crates-pi-shell-src-process--graceful-tree-termination-and-harness-protection.md).

Source: [crates/pi-shell/src/process.rs](https://github.com/can1357/oh-my-pi/blob/d93fb847f661359936ade2d0b5d27fb941158545/crates/pi-shell/src/process.rs) at commit `d93fb847`.
