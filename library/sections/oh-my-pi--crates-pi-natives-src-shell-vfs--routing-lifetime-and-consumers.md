---
title: ShellFilesystem routing modes, lifetime, and which tools accept it
source: crates/pi-natives/src/shell/vfs.rs
source_repo: can1357/oh-my-pi
source_commit: 7dc2ef905e881af813fe18caad32fdc32770b153
source_date: 2026-09-25
source_authors: [can1357]
ingested: 2026-10-07
ingested_by: scholar
topics: [virtual-filesystems, agent-workspaces, tooling]
status: current
---

> Abstract: A `ShellFilesystem` either receives every path (a fully injected filesystem) or, with `nativeLocalPaths`, only `scheme://` URLs, so host paths run natively and the handler cannot intercept any host subtree. The handler is held weakly and never blocks the JavaScript thread. Cleanup requests survive an abort, and every opened handle is closed exactly once. The same object is accepted by the shell, `grep`, `glob`, and `ast` bindings, but not by `fuzzyFind`, which stays host-path-only.

## Two routing modes

`ShellFilesystem` has two fields: `handler` and `nativeLocalPaths`.

- **`nativeLocalPaths` false or absent:** the handler "is a fully injected filesystem and receives every path, host paths included." Nothing touches the host disk unless the provider redirects with `local`.
- **`nativeLocalPaths: true`:** "every path without a `scheme://` prefix — and everything beneath it — is the ordinary host filesystem: operations there run natively (including recursive traversal and removal) and `handler` is never consulted, so it cannot intercept any host subtree. Only URL paths reach `handler`."

The routing test is one line: a path goes to the callback when `!nativeLocalPaths || pi_vfs::is_virtual_path(path)`. In the second mode, a native directory listing reached through a redirect is rebased under the routed directory spelling, and each entry carries its local `lstat` so later lookups do not need a host round trip.

This is the precise form of the `pi-vfs` distinction already recorded: virtual (URL) files need no host materialization, and host paths are either fully virtualized or fully native, never partly intercepted.

## Lifetime and threading

- **Weak callback.** "The callback is held weakly, so an idle session never keeps the event loop alive." Every call happens while a shell run's pending promise already holds the loop open.
- **Never blocks the JavaScript thread.** Each round trip is awaited asynchronously.
- **Cancellation-safe `open`.** An `open` whose reply outlives a cancelled caller runs as a detached task. A handle that nobody received is closed, "so aborting a run never strands provider resources."
- **Exactly-once `close`.** If a handle is dropped without `close`, a `Drop` backstop queues the provider's single `close` without waiting and without needing a runtime. The returned promise is still consumed so a rejection is never left unhandled.
- **Cleanup flag.** Requests issued through `for_cleanup` carry `cleanup: true`. These remove temporary files the shell itself created, "issued even after the run was aborted." The provider should serve them "under the same policy, but without the run's abort signal". A cleanup request is "not a retry of a cancelled request."

## Synchronous consumers

`ShellFilesystem::blocking(filesystem)` returns a blocking facade for synchronous search workers: the provider's, or the native host filesystem when none is given. It is called on the JavaScript thread while options are unpacked, "as the shell does."

## Which N-API tools accept the injected filesystem

In `crates/pi-natives/src`, `ShellFilesystem` appears in `shell.rs`, `grep.rs`, `glob.rs`, and `ast.rs`, and nowhere else. `fd.rs` (the `fuzzyFind` binding) has no `filesystem` option. So:

- shell sessions and one-shot runs, `grep`, `glob`, and `astGrep`/`astEdit` can all operate on provider-backed URL trees;
- `fuzzyFind` remains host-path-only, as recorded in [N-API fuzzy path discovery](oh-my-pi--crates-pi-natives-src-fd--napi-fuzzy-path-discovery.md).

## Boundary note

Policy belongs to the provider: the bridge enforces only the wire contract, plus the read-only wrapper when a provider asks for it. A provider that redirects to a host path has made an access decision for that path. In capability terms, the JavaScript handler is the authority boundary, and `nativeLocalPaths: true` is an explicit grant of ambient host-filesystem access to everything outside URL space.

Source: [crates/pi-natives/src/shell/vfs.rs](https://github.com/can1357/oh-my-pi/blob/7dc2ef905e881af813fe18caad32fdc32770b153/crates/pi-natives/src/shell/vfs.rs) at commit `7dc2ef90`.
