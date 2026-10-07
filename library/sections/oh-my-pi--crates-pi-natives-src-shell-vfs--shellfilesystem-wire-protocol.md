---
title: The ShellFilesystem wire protocol between JavaScript and pi-vfs
source: crates/pi-natives/src/shell/vfs.rs
source_repo: can1357/oh-my-pi
source_commit: 7dc2ef905e881af813fe18caad32fdc32770b153
source_date: 2026-09-25
source_authors: [can1357]
ingested: 2026-10-07
ingested_by: scholar
topics: [virtual-filesystems, file-systems]
status: current
---

> Abstract: `ShellFilesystem` lets a JavaScript host implement a whole filesystem as one promise-returning `handler(request)`. The Rust bridge turns it into a `pi_vfs::FileSystem` using a closed vocabulary of 34 operations. Paths stay verbatim, handles are positional, and errors cross as errno-named data. A provider can also redirect any operation to a host path, optionally read-only.

## What the bridge is

The module header states the purpose: a host passes a `ShellFilesystem` whose `handler` services filesystem operations through a promise-returning callback. The bridge implements `pi_vfs::FileSystem` over that callback, "so shell redirections, globs, `cd`, and every in-process utility see host-provided paths as a real filesystem — no argv rewriting and no temporary host copies."

So the injected filesystem is a real backend under the shell. It does not rewrite commands, and a virtual file never has to exist on the host. See [injectable virtual filesystem](oh-my-pi--crates-pi-vfs-src-lib--injectable-virtual-filesystem.md) for the `pi-vfs` side of the contract.

## Wire rules (from the header)

- **Paths travel verbatim.** URL spellings keep their authority (`scheme://host/...`).
- **Handles are positional.** The native side owns each handle's cursor and sends explicit `bigint` offsets, "so duplicated descriptors share one provider handle and one position." A per-handle lock is held across each round trip so concurrent clones never interleave a read-modify-advance of the shared position.
- **Binary payloads** are `Buffer`/`Uint8Array`. `u64` quantities are `bigint` on requests and `number | bigint` on responses. A `number` above `Number.MAX_SAFE_INTEGER` is rejected rather than silently rounded.
- **Failures are data.** An answer of `{ error: { code } }` carries an errno name such as `ENOENT`, `EACCES`, `EROFS`, or `ENOTSUP`. On Unix the bridge maps it to the real errno so `io::ErrorKind`, messages, and `raw_os_error` match native failures. A rejected promise or a malformed response is a *provider failure*, not a filesystem error.
- **Redirects.** A response may carry `local` (and `localTarget` for the second path of a rename or hard link), which re-runs the operation on the native backend at that host path. "Providers decide access policy before redirecting." If one side of a two-path operation is redirected and the other is still a routed path, the bridge reports a cross-device error rather than mixing backends.
- **Read-only redirect.** An `open` redirect may set `readonly`. The host file then "backs an immutable mount": reads, seeks, metadata, and lock queries reach the host descriptor, but every mutation fails `EROFS`, including `fchmod`/`futimens`, which an `O_RDONLY` descriptor would otherwise allow. The descriptor is never exposed, so callers cannot bypass the restriction, and duplicates share it.

## Operation vocabulary

`ShellFsOp` is a string enum. Each `ShellFsRequest` sets only the fields documented for its `op`.

- **Path metadata and naming:** `metadata` (follows symlinks), `symlinkMetadata`, `readDir`, `canonicalize` (with `missing` = `existing`/`normal`/`missing` and `resolve` = `physical`/`logical`/`none`), `readLink`, `access` (all-false flags test existence).
- **`backingPath`:** the host file or directory behind a path, for commands that print real locations (`realpath`, `readlink -f`). It may answer with no path when nothing on the host backs it, and it "grants no access."
- **Handle I/O:** `open`, `read` (empty data at end of file), `write` (no `offset` means an append, and the answer reports the new end offset), `flush`, `close` (sent exactly once per handle), `fileMetadata`, `isLocked` (advisory write-lock query), `setLen`, `fileSetTimes`, `fileSetPermissions`, `sync` (`dataOnly`).
- **Tree mutation:** `createDir` (`recursive`, `mode`), `removeFile`, `removeDir`, `removeDirAll`, `rename`, `hardLink`, `symlink` (target stored verbatim), `setPermissions`, `setTimes`, `chown`, `mknod` (with `fileType` and `device`).
- **Filesystem and xattrs:** `statFs`, `getXattr` (no data when absent), `setXattr`, `listXattr`, `removeXattr`.

File types on the wire are `file`, `dir`, `symlink`, `fifo`, `socket`, `char`, and `block`. In `ShellFsMetadata`, an absent optional field means the provider has no such value, and values "are never fabricated". Paired fields (`dev`/`ino`, `blocks`/`blksize`, `uid`/`gid`) are supplied together.

## Transfer bound

One `read` or `write` round trip moves at most 4 MiB. Larger requests are served short, "which every `Read`/`Write` caller already handles," so no single call stages an unbounded copy on either side.

Source: [crates/pi-natives/src/shell/vfs.rs](https://github.com/can1357/oh-my-pi/blob/7dc2ef905e881af813fe18caad32fdc32770b153/crates/pi-natives/src/shell/vfs.rs) at commit `7dc2ef90`.
