---
title: Graceful process-tree termination and harness protection
source: crates/pi-shell/src/process.rs
source_repo: can1357/oh-my-pi
source_commit: d93fb847f661359936ade2d0b5d27fb941158545
source_date: 2026-10-06
source_authors: [can1357, roboomp, Brit, Ilia Alshanetsky, oldschoola]
ingested: 2026-10-07
ingested_by: scholar
topics: [shell-runtimes, agent-fleet-durability]
status: current
---

> Abstract: `terminate_tree` sends a polite wave (the process group, every live descendant, then the root), optionally waits up to `graceful_ms`, then re-walks the tree and sends a hard wave so that grandchildren spawned during the grace period are caught. Every wave prunes the harness's own PID and its subtree. This guards a Windows PID-reuse false-descendant case in which cancelling a timed-out command could otherwise `TerminateProcess` the host itself.

## The two-wave contract (doc comment)

"Gracefully terminate this process and its descendants. Sends `TERM_SIGNAL` to the optional process group, every live descendant, and the root, then optionally waits up to `graceful_ms` for the tree to exit before escalating to `KILL_SIGNAL`. Pass `graceful_ms < 0` to skip the wait entirely (the polite signal is still emitted). Returns `true` when the tree has exited by the end of the hard wave's wait window."

Implementation details that carry contract:

- A root that is no longer running returns `true` immediately.
- With `group` set, the process group is signaled first in each wave, if the platform has groups.
- The tree is walked fresh before *each* wave ("call it again before each signal wave so grandchildren spawned during a grace period are not missed"), including processes reparented to the root.
- If the root leads its own process group, a plain tree signal (`kill_tree`) also signals the group. This "catches grandchildren reparented to init when their immediate parent died inside the descendant walk."
- The negative-`graceful_ms` path still sends the polite signal, "so cleanup handlers can run before KILL."

## Harness protection

The process running `pi-shell` (the harness) is the one process a cancellation sweep must never signal. On Unix the descendant walk is identity-pinned, so the protected set "is a harmless no-op safety net." On Windows the tree comes from raw `th32ParentProcessID` values that survive their parent's death. "A freshly spawned child whose recycled pid matches the harness's stale parent pid makes the harness enumerate as a false descendant, so cancelling a timed-out bash run would `TerminateProcess` the host with no cleanup and no `session_exit` record" (upstream #7452, related #4605).

Two rules close it:

1. **Prune whole subtrees, not just the PID.** The flattened descendant list can contain the protected node *and* its real children, collected by recursing through it. Every node whose recorded parent chain, within the enumerated set, passes through a protected PID is dropped. The walk is bounded against a corrupted or cyclic chain.
2. **Do not protect the host's numeric parent chain.** "On Windows the host's recorded parent pid can itself have been recycled onto the cancellation target; treating that raw pid as protected would spare the hung command and prune all of its descendants from cleanup."

## Waiting for exit

A lone process is awaited through the OS exit notification (pidfd, kqueue, or Windows wait). Earlier polling "woke every waiter 20 times a second, and IPC workers wait on their parent for their whole life." Trees still poll every 50 ms, because their membership changes. Waits honor the caller's `CancelToken` (see [the cancel token](oh-my-pi--crates-pi-shell-src-cancel--deadline-and-abort-reason-token.md)).

## Relevance

This is the shutdown discipline an agent harness needs when a tool command hangs: a polite signal, a bounded grace period, a re-walk, a hard kill, and never the harness itself. It parallels the garden's own reaping concerns: per-job worktrees must survive a requeue, and a reaper must never kill its own supervisor.

Source: [crates/pi-shell/src/process.rs](https://github.com/can1357/oh-my-pi/blob/d93fb847f661359936ade2d0b5d27fb941158545/crates/pi-shell/src/process.rs) at commit `d93fb847`.
