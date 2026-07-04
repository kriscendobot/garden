---
role: builder
model: opus
---

# Build: harden journal-worktree-keeper against stale `garden2` worktree registrations

**GARDEN self-development, not fork work.** Your per-job worktree is off `origin/main2`; make the change there and push **directly to `origin/main2`** (garden convention: no PR against our own repo — CLAUDE.md § Conventions). File: `scripts/jobs/journal-worktree-keeper.sh`. Add/extend the regression test `scripts/jobs/test/journal-worktree-keeper-test.sh` and run it (plus any lint the repo uses) before pushing.

## The bug (confirmed live on this host 2026-07-04, twice in one day)

The garden root was relocated `/home/kris/garden2` → `/home/kris`. That leaves a **stale worktree registration**: `git -C /home/kris worktree list` shows `/home/kris/garden2/journal … prunable`, and the journal worktree's two cross-pointers can re-resolve to the vanished `garden2` path. When they do, every `git -C $GARDEN_ROOT/journal …` dies (`fatal: not a git repository: /home/kris/garden2/.git/worktrees/journal`) and the whole fleet FATAL-storms with `no JOURNAL_REMOTE set and no origin` — the gardener pool crash-loops, and `gardener-scaler`/`unblock`/`repo-watcher`/`library-link-scan` fail. The fleet's self-heal history shows this recurring across many services (`self-heal-fix-...journal-worktree-dangling-gitdir`).

## Root cause (grounded in the current code)

In `jw_repair_gitdir()` (currently ~lines 272–305):
- Lines 277–279 **early-return "already healthy"** the moment `git -C "$jw" rev-parse --git-dir` resolves.
- The `git -C "$GARDEN_ROOT" worktree prune` that clears stale `garden2/*` registrations is at **line ~290 — AFTER** the `worktree repair` at line ~285, and therefore **only runs when the gitdir was already broken.**

So a worktree with a **resolving gitdir but a lingering stale sibling registration** is declared healthy and never pruned. A repair-only fix (or a deploy/keeper tick that re-links the forward pointer) satisfies the early-return, the stale `garden2` registration persists, and a subsequent git op latches back onto it and re-breaks the linkage within the hour. Empirically, `prune` **before** `repair` (removing the stale registration first, then re-linking against the surviving admin entry) is what makes the fix stick — after which the keeper reports "already fresh" and holds.

## What to change

Make the keeper **defensively prune stale worktree registrations every tick, even on the healthy path**, so a stale `garden2/*` (or any absent-path) registration can never accumulate and be latched onto later. Decide the cleanest shape and justify it in the commit message; candidates:
- Run `git -C "$GARDEN_ROOT" worktree prune` **unconditionally** near the top of `jw_repair_gitdir()` (or in `keep_journal_worktree()`), *before* the early-return health check — it is safe (prune only removes entries whose working tree is absent, never a live worktree), idempotent, and cheap.
- And/or reorder the existing STEP 1 to prune **before** `worktree repair`, matching the fix that empirically sticks.

Keep the existing success-gate (both `rev-parse --git-dir` and `remote.origin.url` must resolve) and the STEP 2 rebuild path intact. Do not weaken the active-writer / backup guards on the rebuild path.

## Regression test

Extend `scripts/jobs/test/journal-worktree-keeper-test.sh` with a case that reproduces the real failure mode and would FAIL before your change:
- a journal worktree whose **gitdir currently resolves** (so the old early-return fires) **but** a stale sibling registration for an absent path (simulating `garden2/journal`) is still present in `git worktree list`;
- assert that after one keeper tick the stale registration is **gone** (`git worktree list` no longer shows the absent path / no `prunable` entry) and the live worktree is untouched and still healthy.

## Definition of done

- `scripts/jobs/journal-worktree-keeper.sh` prunes stale worktree registrations even when the gitdir already resolves; comments updated to explain why (the resolving-gitdir-with-stale-sibling-registration recurrence).
- New/extended test in `journal-worktree-keeper-test.sh` reproduces the recurrence and passes; the full keeper test suite passes.
- Pushed directly to `origin/main2` (no PR). Report names the commit sha and the test result.
