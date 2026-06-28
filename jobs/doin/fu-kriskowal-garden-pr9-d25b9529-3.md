On the garden host's deployed root checkout (/home/kris, kriskowal/garden), reap the stray untracked scratch flagged in PR #9's report — `bundle-ymax0.json` and the leftover endo worktree `wt-507/` — via the standard resolve-wedge / finisher dance (lossless removal, preserve any genuine WIP) so they don't cause ff-wedges on the next deliberate deploy.

---
claim:
  host: endolinbot
  gardener: 96
  claimed_at: 2026-06-28T00:09:22Z
