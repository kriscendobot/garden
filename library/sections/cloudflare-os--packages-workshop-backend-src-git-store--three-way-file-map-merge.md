---
title: Three-way file-map merge
source: packages/workshop-backend/src/git-store.ts
source_kind: comment-fragment
source_repo: cloudflare/cloudflare-os
source_path: packages/workshop-backend/src/git-store.ts
source_line_range: "442-572"
source_commit: 1ef6020a42fbabb6d27dd1063db3a075ba95c974
comment_subject: threeWayMerge over file maps — never throws, per-file semantics, and lossless line splitting that keeps bare CR / U+2028 / U+2029 inside their line
source_authors: [Kenton Varda]
ingested: 2026-08-24
ingested_by: scholar
topics: [content-addressed-storage, local-first-sync, change-propagation]
status: current
---

Abstract: `threeWayMerge` merges three flattened file maps — `base` the common ancestor, `ours` and `theirs` the two sides — and never throws on conflict: conflicted files get inline diff3-style 3-way markers (`<<<<<<<`/`|||||||`/`=======`/`>>>>>>>`) and are reported in `conflictPaths` for the user or their agent to clean up. It deliberately replaces both Yjs merging (CRDT merge across divergent bases produces nonsense) and isomorphic-git's `merge`/`mergeTree` (which throw on both-sides-added conflicts before any merge driver runs and require an index); the common ancestor is always explicitly known in the workflow — the chat's last merged commit — so no merge-base discovery is needed. Per-file semantics: a one-sided change (including deletion) wins; identical change on both sides is clean; delete-vs-modify keeps the modified content but reports a conflict; changed-on-both-sides is line-merged via diff3 with conflicting hunks marked. The line splitter is lossless above all — only `\n` ends a line, so bare `\r`, U+2028, and U+2029 stay inside their line rather than corrupting content that uses them.

## Why not Yjs or isomorphic-git merge

`threeWayMerge` deliberately replaces both Yjs merging (a CRDT merge across divergent bases produces nonsense) and isomorphic-git's `merge`/`mergeTree` (which throw on both-sides-added conflicts before any merge driver runs, and require an index). The common ancestor is always explicitly known in the workflow — the chat's last merged commit — so no merge-base discovery is needed.

## Per-file semantics

For each path over the union of the three maps:

- changed on one side only (including deletion): that side wins;
- identical change on both sides (including both deleted, or an identical add): clean;
- deleted on one side, changed on the other: the changed content survives, reported as a conflict (no markers);
- changed on both sides (including both-added, where `base === undefined` and diff3 marks the entirety of both sides): line-merged via diff3, conflicting hunks marked.

The result carries the merged file map (including any files containing conflict markers) and `conflictPaths` in sorted order.

## Lossless line splitting

`splitLines` splits `text` into lines each keeping its trailing `\n`, so `lines.join("") === text` always holds. The split must be lossless above all: only `\n` ends a line, and a bare `\r` (or U+2028/U+2029) stays *inside* its line rather than acting as a boundary. This merely makes diffs and merges of such exotic line endings coarser — whereas the obvious `/^.*$/m`-style split treats those characters as boundaries it cannot retain, silently corrupting any content that uses them. Because a boundary always follows `\n`, it can never split a UTF-16 surrogate pair.

`isomorphic-git`'s own `mergeFile` splits with a regex that treats bare `\r`/U+2028/U+2029 as boundaries it then drops; this implementation keeps such characters inside their line instead. A conflict hunk at end-of-file that lacks a trailing newline is given one (`withFinalNewline`) so the following marker starts its own line, where isomorphic-git would glue the marker onto the last line.

## Translation

| `git-store.ts` term | Meaning |
|---|---|
| ours / theirs / base | the three merge inputs: the local head, the remote head, and their common ancestor |
| diff3 | the `diff3` npm package providing the three-way line merge |
| flattened file map | a `path -> text` map with nested trees joined by `/` |

Source: [packages/workshop-backend/src/git-store.ts](https://github.com/cloudflare/cloudflare-os/blob/1ef6020a42fbabb6d27dd1063db3a075ba95c974/packages/workshop-backend/src/git-store.ts) at commit `1ef6020a`.
