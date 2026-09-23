The wedge is resolved. The tree is now clean of tracked changes — the only blocking path (`scripts/jobs/mentor.sh`) was a tracked edit byte-identical to `origin/main2`, so the script dropped it via `git checkout HEAD`. No genuine WIP was stashed or preserved, so there's no landing decision to make. The three untracked entries are non-colliding and were correctly left untouched. HEAD is still at the old SHA, but that's expected — the deploy-sync fast-forward proceeds on its next tick now that the tree is clean.

---

**Completion report**

Ran `/home/kris/scripts/jobs/resolve-wedge.sh main2` on the shared `/home/kris` checkout (host endolinbot).

- **Blocking path:** `scripts/jobs/mentor.sh` (one tracked edit).
- **Resolution:** The edit was byte-identical to `origin/main2` — a redundant copy of already-landed work — so the script dropped it via `git checkout HEAD --`. Lossless; no `reset --hard`/`clean`.
- **Script tally:** dropped=1, removed=0, stashed=0, preserved=0, untouched-untracked=3. Exit 0, "tree is clean."
- **WIP judgment call:** None needed — nothing was stashed or preserved.
- **Untracked entries left in place (non-blocking, non-colliding):** `agoric-sdk/`, `bundle-ymax0.json`, `wt-507/`. The script left these untouched (they don't collide with incoming `origin/main2` files); they do not block the fast-forward.
- **State:** Working tree clean of tracked changes. HEAD remains at `1165774cd` while `origin/main2` is at `00693cdbd5` — the watchman/deploy-sync reconciler will fast-forward on its next tick now that the tree is clean.

**Follow-ups:** None required. The three untracked items appear to be stray artifacts (a nested `agoric-sdk/` clone, a bundle JSON, and a `wt-507/` worktree dir); they're harmless to the fast-forward but could be cleaned up separately if they're not intentional — flagging only, not acting, since they're outside this job's blocking set and agoric-sdk is off-limits.
