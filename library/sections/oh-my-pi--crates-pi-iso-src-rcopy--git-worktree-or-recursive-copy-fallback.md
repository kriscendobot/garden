---
title: Rcopy, the Git-worktree-or-recursive-copy fallback backend
source: crates/pi-iso/src/rcopy.rs
source_repo: can1357/oh-my-pi
source_commit: 7f6974c30a9b8a968ce4f54e9812e46bf2c53844
source_date: 2026-10-06
source_authors: [can1357, Brit, metaphorics, roboomp]
ingested: 2026-10-07
ingested_by: scholar
topics: [agent-workspaces, file-systems]
status: current
---

> Abstract: `Rcopy` is `pi-iso`'s always-available backend. For a Git lower tree it runs `git worktree add --detach <merged> HEAD` and then replays the lower tree's staged, unstaged, and untracked state, so `git status` in `merged` matches `lower`. Otherwise it copies the tree recursively, preserving modes and mtimes. Teardown is `git worktree remove --force` plus `rm -rf`. It uses no filesystem tricks, so the caller pays the full copy cost up front.

## Module contract

The header: "Cross-platform fallback isolation: git worktree, or plain recursive copy." When `lower` is a Git working tree, `start` materializes `merged` via `git worktree add --detach <merged> HEAD`, and `stop` tears it down with `git worktree remove --force`. "This lets git itself manage refs/index/HEAD inside `merged`, keeping `diff` on the `git diff` path." Otherwise the backend does "a vanilla recursive copy, preserving file modes and mtimes so the default mtime-skipping diff path stays fast. There is no file-system magic; the caller pays full filesystem-copy cost up front and an `rm -rf` on teardown."

## Probe and Git detection

`probe()` always reports available. It deliberately does not check for `git`, because the non-Git branch does not need it. If `lower` is a Git tree but `git` is missing from `PATH`, `start` returns an *unavailable* error, which callers treat as "try the next candidate", not as a hard failure. A path counts as a Git working tree when `.git` exists either as a directory (a regular checkout) or as a `gitdir:` text file (a linked worktree), which is "the signal git itself uses."

## Mirroring the live working tree

A detached `HEAD` checkout is clean, but callers expect `merged` to mirror `lower`'s *live* tree. `start` therefore seeds the dirty state in three passes, mirroring what `git status` would report at `lower`:

1. **Staged:** `git diff --binary --cached` from `lower`, applied to both the index and the working tree of `merged`.
2. **Unstaged:** `git diff --binary` from `lower`, applied to the working tree only.
3. **Untracked:** every path from `git ls-files --others --exclude-standard -z`, copied recursively into the same relative location.

The result is that "`git status` inside `merged` reports the same dirty set as `lower` at the moment `start()` was called." This upholds the PAL-wide invariant that merged mirrors lower's live working tree, so callers never need an `applyBaseline` step whichever backend was chosen. Ignored files are not copied, because the untracked pass uses `--exclude-standard`.

## Teardown and timestamps

`stop` is best-effort. If `merged` is a registered worktree it runs `git worktree remove --force` so the parent repository's worktree list stays consistent, then removes the directory, treating "not found" as success. The copy path mirrors source mtimes onto files and directories, including read-only files. Failures are silently ignored because the mtime hint "is an optimisation for diff, not a correctness requirement." On Unix the timestamp is set with one path-based `utimensat` using `AT_SYMLINK_NOFOLLOW`, so a swapped-in link cannot redirect the write. On Windows the file is opened with just enough access to set attributes, and a directory symlink is recreated as a directory link.

## Comparison

This is the same shape the garden uses for per-job project worktrees: a detached Git worktree per task. Rcopy adds a replay of the source's uncommitted state, which garden job worktrees do not need because they start from a pushed ref.

Source: [crates/pi-iso/src/rcopy.rs](https://github.com/can1357/oh-my-pi/blob/7f6974c30a9b8a968ce4f54e9812e46bf2c53844/crates/pi-iso/src/rcopy.rs) at commit `7f6974c3`.
