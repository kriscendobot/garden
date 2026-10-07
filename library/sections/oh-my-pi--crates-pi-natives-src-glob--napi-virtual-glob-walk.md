---
title: N-API virtual glob walk
source: crates/pi-natives/src/glob.rs
source_repo: can1357/oh-my-pi
source_commit: b9f9b1b2e56d0a81c6ea00b4f523d7ae86e49725
source_date: 2026-10-04
source_authors: [can1357, roboomp]
ingested: 2026-10-07
ingested_by: scholar
topics: [tooling, virtual-filesystems]
status: current
---

# N-API virtual glob walk

> Abstract: The `glob` N-API function layers pattern matching, ignore rules, type filtering, caching, result limits, optional mtime ranking, and callback delivery over `pi-walker`, while accepting either a native filesystem or the shell's injected `pi-vfs` provider.

`GlobOptions` names the JavaScript boundary: pattern and root path, file/directory/symlink filtering, recursive promotion of simple patterns, hidden and gitignore policy, shared scan caching, mtime ordering, result limits, `node_modules` inclusion, cancellation and timeout, plus an optional shell filesystem. The returned promise resolves to matching entries and a total count; an optional N-API threadsafe callback receives each returned match.

The walker always skips `.git` and skips `node_modules` unless the pattern or option explicitly requests it. Non-recursive patterns produce a depth bound so `dir/*` does not traverse the entire subtree. The common path lets `pi-walker` perform glob filtering and path ordering. Native-only type filtering resolves symlink targets when the requested file type is file or directory. Mtime mode gathers sufficient metadata, ranks newest first with path as the tie-breaker, and applies the limit after ranking.

Unlike a wrapper around the host `glob` command, this implementation resolves and walks through `BlockingFs`. Absolute `scheme://` roots therefore stay provider URLs, and result paths remain relative to the virtual root with decoded segment spellings. The N-API boundary exposes structured objects and promise/callback delivery; traversal and filesystem implementation remain Rust-side.

Source: [crates/pi-natives/src/glob.rs](https://github.com/can1357/oh-my-pi/blob/b9f9b1b2e56d0a81c6ea00b4f523d7ae86e49725/crates/pi-natives/src/glob.rs) at commit `b9f9b1b2`.
