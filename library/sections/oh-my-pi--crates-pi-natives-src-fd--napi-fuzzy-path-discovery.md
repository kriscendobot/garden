---
title: N-API fuzzy path discovery
source: crates/pi-natives/src/fd.rs
source_repo: can1357/oh-my-pi
source_commit: 4aff5453462dd2fa4cbffe35f42433f2e251bf97
source_date: 2026-10-05
source_authors: [can1357, Muhammad Mustaqeem, HvC, Brit]
ingested: 2026-10-07
ingested_by: scholar
topics: [tooling]
status: current
---

# N-API fuzzy path discovery

> Abstract: The `fuzzyFind` N-API promise searches a host directory with `pi-walker`, scores file and directory paths for autocomplete and `@`-mention resolution, and retains only the best bounded result set while still reporting the exact total match count.

The wire surface accepts a query, path, hidden and gitignore controls, cache toggle, maximum results, cancellation signal, and timeout. Results contain a relative path, directory marker, and score. Files and directories are ranked by exact basename, basename prefix, basename substring, or punctuation-insensitive subsequence quality; path-style queries containing `/` may score the full relative path. Directories receive a small preference. Ties favor shallower paths and then lexical order.

The implementation uses a bounded heap, so memory grows with `maxResults` rather than with the number of matching entries. It separately counts every hit, preserving an exact `totalMatches` even when the returned list is truncated. `pi-walker` handles traversal, gitignore rules, hidden entries, cache reuse, cancellation heartbeats, and symlink-directory following while skipping `.git` and `node_modules`.

This file exposes only the host-path form of discovery: unlike the neighboring `grep` and `glob` bindings, `FuzzyFindOptions` has no injectable `ShellFilesystem` and resolves its root through `pi_walker::resolve_search_path`. The current `fuzzyFind` N-API surface therefore does not search `pi-vfs` URL-provider trees. That boundary is important when describing oh-my-pi as a virtualized shell: virtualization reaches the native grep and glob tools here, but not every path-discovery helper.

Source: [crates/pi-natives/src/fd.rs](https://github.com/can1357/oh-my-pi/blob/4aff5453462dd2fa4cbffe35f42433f2e251bf97/crates/pi-natives/src/fd.rs) at commit `4aff5453`.
