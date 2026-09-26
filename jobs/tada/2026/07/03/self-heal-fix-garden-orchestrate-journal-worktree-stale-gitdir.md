Inbox empty. Work complete and pushed to main2.

## Completion report

**Job:** Harden `journal-worktree-keeper.sh` to rebuild a broken/missing journal worktree instead of skipping it, and let it repair the host.

**What I found (important context):** The core hardening the job describes was **already implemented on main2** across commits `ce4b94831 → d4b231773`. `keep_journal_worktree()` already calls `jw_repair_gitdir` (cheap lossless `worktree repair` first, then a full `jw_rebuild_dangling_worktree` from origin) *before* the WARN-and-skip guard — so the "WARN … skipping" behavior the job cites had already been replaced. I reproduced the **exact live 2026-07-03 signature** (root relocated `garden2 → root`; `$JW/.git` pointing at the removed `garden2/.git` while the registered worktree points at a *different* prunable `garden2/journal` path) and confirmed the current code **already repairs it losslessly** — re-links to `$GARDEN_ROOT/journal`, stays on journal2, no maintainer page. The live `/home/kris/journal` is currently **healthy** (repaired out-of-band; sibling self-heal jobs exist). Rewriting the code to the job's literal `rm -rf`-then-re-add prescription would have *regressed* the superior repair-first path, so I did not.

**What I changed (the genuine gaps vs. spec):**
1. **Active-writer gate on the rebuild** — `jw_rebuild_dangling_worktree` did `rm -rf "$JW"` (after a lossless backup) but never checked whether a live agent held the dir as its cwd. Added the spec's required gate reusing `jw_active_writer`, fed an empty path list (a dangling worktree can't enumerate a dirty set, so only the `/proc`-cwd signal applies — exactly right). A missing dir = no writer; an active writer defers the rebuild to the next tick losslessly, no page. Updated the header doc block to match.
2. **Two regression tests** in `journal-worktree-keeper-test.sh`: the exact stale-prunable-mismatched-admin-entry live signature (asserts re-link + on journal2 + WIP preserved + no page), and the active-writer-defers-rebuild case.

**Verification:** Full suite green — **68/68** (was 55) after rebasing onto a sibling commit that also hardened `jw_repair_gitdir`. Committed with explicit pathspecs and pushed to `origin/main2` (`4571654f7`).

**Follow-ups:**
- The **deployed** keeper at `/home/kris/scripts/jobs/journal-worktree-keeper.sh` is still the old page-and-skip version (no `jw_repair_gitdir`). The fix reaches it only on the next **deliberate deploy** (`deploy-garden.sh`) — out of a gardener's scope. The host is not currently broken, so this is not urgent, but until deployed the timer won't auto-repair a *future* recurrence on this host.
- Two sibling jobs touch adjacent surfaces (`...issue-inbox-keeper-repair-dangling-journal-worktree-link`, `...repo-watcher-dangling-journal-worktree-gitdir`) — worth confirming they don't overlap, but no conflict surfaced in my rebase.
