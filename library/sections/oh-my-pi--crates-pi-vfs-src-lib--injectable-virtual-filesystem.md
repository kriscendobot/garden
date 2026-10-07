---
title: Injectable virtual filesystem
source: crates/pi-vfs/src/lib.rs
source_repo: can1357/oh-my-pi
source_commit: 8b984d7a5ace00108c13364673474ca04fd9145f
source_date: 2026-09-25
source_authors: [can1357]
ingested: 2026-10-07
ingested_by: scholar
topics: [virtual-filesystems, agent-workspaces]
status: current
---

# Injectable virtual filesystem

> Abstract: `pi-vfs` is the filesystem boundary shared by oh-my-pi's embedded shell and in-process utilities: cloneable asynchronous and blocking facades default to the host, but an injected provider can own URL-addressed files, metadata, directory entries, and handles without materializing them on the host filesystem.

`Fs` is the cloneable asynchronous facade and `BlockingFs` is its synchronous counterpart for utility bodies on blocking workers. Host paths take a fast path directly to `std` and libc. `Fs::new` instead installs a `FileSystem` provider which receives every path verbatim, including `scheme://authority/...` URLs, and owns the returned `File`, `Metadata`, and directory-entry objects.

This is the concrete distinction behind oh-my-pi's virtualized Bash surface: commands can stat, traverse, open, and search provider-backed files that have no host pathname or temporary host copy. The public path helpers preserve URL spelling, keep `://` intact, encode raw path segments when constructing paths, and decode a file-name segment once when reading it.

Provider operations are futures. The blocking facade and synchronous file methods bridge them with Tokio's blocking-worker support, which is valid from blocking-pool, foreign, and multi-thread-runtime worker threads but is a contract violation on a current-thread runtime's own thread. Provider close is also explicit: dropping the last file clone schedules a close without blocking, while callers that need ordering or errors use `File::close`, `File::close_async`, or `Fs::drain_closes`.

The crate's public surface re-exports the two facades, the `FileSystem` trait, file and directory handles, metadata, open/canonicalization/directory/temp options, lexical URL-aware path helpers, filesystem types, and normalized filesystem errors. It virtualizes file access, but does not itself sandbox process execution or confer object-capability confinement.

Source: [crates/pi-vfs/src/lib.rs](https://github.com/can1357/oh-my-pi/blob/8b984d7a5ace00108c13364673474ca04fd9145f/crates/pi-vfs/src/lib.rs) at commit `8b984d7a`.
