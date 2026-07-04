---
role: builder
model: opus
---

# Build: make `garden-issue-inbox` resilient to a severed journal linkage

**GARDEN self-development.** Per-job worktree off `origin/main2`; push **directly to `origin/main2`** (no PR). Companion to the just-landed `fix-journal-worktree-keeper-stale-registration`.

> **Worktree caution (host endolinbot2):** if your `gardener-wt-*` git admin entry is swept mid-job, commit/push from a standalone scratch clone.

## The problem (confirmed live 2026-07-04)

A fresh maintainer issue (kriskowal/garden#24) got **no reactji and no dispatched job** — the `garden-issue-inbox` watcher lapsed silently. The inbox was armed (`config/garden-repo`=`kriskowal/garden`, kriskowal on `maintainers/allowlist`), the leader was alive, cadence is 120s, and the code reacts on new issues — yet nothing happened. The board shows a **history of `self-heal-fix-garden-issue-inbox-…journal-worktree-dangling-gitdir` jobs**. Root cause family: git canonicalizes `/home/kris` to its bind-mount SOURCE `/home/kris/garden2` when writing worktree link files, so the watcher's journal clone/worktree self-breaks (`fatal: not a git repository: /home/kris/garden2/.git/worktrees/journal`). When the watcher's tick dies early on that, it **never reaches the reactji/dispatch step**, so a maintainer's issue is dropped — the exact failure this watcher exists to prevent.

## What to change

`scripts/jobs/issue-inbox-watcher.sh` must **self-heal its journal linkage at the START of every tick, before polling** — so a dangling/severed gitdir on its clone or on `$GARDEN_ROOT/journal` is repaired (or the tick re-derives a working journal remote) rather than aborting the whole tick and silently dropping the issue. Reuse the hardened repair the keeper already provides rather than duplicating logic:
- Factor the keeper's `jw_repair_gitdir` prune-first repair (from `journal-worktree-keeper.sh`, as hardened by `fix-journal-worktree-keeper-stale-registration`) into a shared helper in `common.sh` if it is not already shared, and call it from the issue-inbox watcher's preamble.
- If the watcher reads via a "verify clone" whose linkage can dangle independently, ensure that clone's linkage is likewise repaired/re-derived before the allowlist read and the poll.
- A repair failure must be **logged and surfaced** (self-heal job / maintainer signal), never a silent tick abort that drops an issue.

Investigate whether other leader-only watchers that read the journal via a clone (comment-watcher, mention-watcher) share the same early-abort exposure; if the fix is a shared `common.sh` helper, note which callers now use it. Do not change the reactji/dispatch semantics themselves.

## Regression test

Add a case (near `scripts/jobs/test/` alongside the keeper/issue-inbox tests): with the watcher's journal linkage severed to a nonexistent `garden2`-style path, assert one tick **self-heals and still reacts+dispatches** for a pending trusted issue (fails before the change: the tick aborts and no job is posted).

## Definition of done

`garden-issue-inbox` self-heals a severed journal linkage at tick start and still reactji+dispatches; a repair failure is surfaced, not swallowed; regression test reproduces the drop-then-recover and passes. Note in the commit that the durable root-cause fix is host-side (the `garden2` bind-mount), this only stops the silent drop. Push to main2; report the commit sha and test result.
