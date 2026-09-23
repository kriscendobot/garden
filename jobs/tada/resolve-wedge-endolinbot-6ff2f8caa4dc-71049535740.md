The wedge is resolved. The tree is now free of tracked changes — the only remaining entries are three pre-existing untracked items the resolver correctly left untouched (they don't block a fast-forward).

---

## Completion report

**Job:** resolve-wedge-endolinbot-6ff2f8caa4dc-71049535740 — clean the wedged shared `main2` tree on host `endolinbot`.

**What I did:**
- Ran `/home/kris/scripts/jobs/resolve-wedge.sh main2`. It re-surveyed the tree and resolved the single blocking path losslessly.

**What changed:**
- `scripts/jobs/handlers/proxy-claude.sh` — the tracked edit was **byte-identical to `origin/main2`** (a redundant copy of already-landed work), so the resolver dropped it via `git checkout HEAD --`. Nothing of value was discarded.
- Resolver tally: `dropped=1 removed=0 stashed=0 preserved=0 untouched-untracked=3`, exit 0.
- Tree is now clean of tracked changes; `git status --short` shows only the three pre-existing untracked items (`agoric-sdk/`, `bundle-ymax0.json`, `wt-507/`) — present at session start, unrelated to the wedge, and not blocking the fast-forward.

**Judgment call:** None required — no WIP was stashed or preserved, so there was nothing to evaluate for landing.

**State:** HEAD remains at `93f2a623` and origin is at `6ff2f8caa4dc`; the watchman / deploy-sync will now fast-forward on its next tick since the tree is clean.

**Follow-ups:** None. The three untracked files are leftover scratch (a stray `agoric-sdk/` clone, a `bundle-ymax0.json`, and a `wt-507/` worktree dir); they're harmless to the ff but could be tidied separately if undesired — I left them in place as out of scope for this lossless wedge resolution.
