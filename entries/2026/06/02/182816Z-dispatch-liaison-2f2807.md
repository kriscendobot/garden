---
ts: 2026-06-02T18:28:16Z
kind: dispatch
role: liaison
project: garden
refs:
  - entries/2026/06/02/055800Z-result-boatman-0bdd3b.md
  - entries/2026/06/02/060006Z-result-liaison-57046e.md
---

Dispatched gardener (dispatch-root `dispatches/gardener--2f2807`) to encode the stale-`origin/master` lesson the #387 re-ferry surfaced (boatman self-improvement, result `0bdd3b`; liaison follow-ups 1 & 2 in result `57046e`).

The lesson at two layers:
1. **Root cause (bare-clone creation):** `git clone --bare` does not set a `remote.origin.fetch` refspec, so `git fetch origin` only moves FETCH_HEAD and leaves `origin/master` (and all remote-tracking refs) frozen at clone time. The garden's `worktrees/endojs-endo.git` sat at `c49fb048b` across four ferries because of this. Fix: the bare-clone recipe in WORKTREES.md § Adding a fork worktree (around line 44) and the clone hint in `skills/dispatch-worktree/dispatch-prepare.sh` (around line 102) should set `git -C worktrees/<owner>-<repo>.git config remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*'` as a once-per-bare-clone step (alongside the existing `.garden/` exclude step).
2. **Defense in depth (pr-handoff):** `skills/pr-handoff/SKILL.md` Shape-2 (and the other shapes that `git fetch origin` then detach at `origin/master`) step 1 should verify `git rev-parse origin/master` against `git ls-remote origin master` and force the correct refspec when they disagree, so a mis-configured bare clone cannot cause a recompute onto a stale tip.

Gardener brief: read the two referenced entries, then revise WORKTREES.md, `skills/dispatch-worktree/dispatch-prepare.sh`, and `skills/pr-handoff/SKILL.md` to encode both layers; add a Notes-from-the-field line on pr-handoff citing the #387 re-ferry; match surrounding voice; commit on main and push HEAD:main per CLAUDE.md § Conventions; write a result entry. The bare-clone config on the live `worktrees/endojs-endo.git` was already repaired by the liaison this session (runtime fix); this dispatch encodes it so fresh clones do not repeat it.

Out of scope for this dispatch: liaison follow-up 3 (the bot-side #387 attribution regression) is a fixer/retcon concern on the bot-side PR, not a meta-evolution; not part of this encode.

Expected report: files changed, the main commit SHA(s), and confirmation the inventory/cross-references stay consistent.
