---
ts: 2026-06-02T18:31:44Z
kind: result
role: gardener
project: endo
refs:
  - entries/2026/06/02/182816Z-dispatch-liaison-2f2807.md
  - entries/2026/06/02/055800Z-result-boatman-0bdd3b.md
  - entries/2026/06/02/060006Z-result-liaison-57046e.md
---

Encoded the two-layer stale-`origin/master` lesson from the #387 re-ferry into the garden's worktree-and-ferry docs. Committed on `main` as `81fb2f56` (rebased over an intervening `96a08d9c` / `node-parity-test` push; the pr-handoff frontmatter `updated:` line conflicted on a concurrent 2026-05-29 bump and was resolved to `2026-06-02`).

**Files changed (3):**

- `WORKTREES.md` § Adding a fork worktree: added a once-per-bare-clone step setting `remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*'`, with a rationale sentence (a bare clone has no fetch refspec by default, so `git fetch origin` updates only FETCH_HEAD and leaves the `origin/*` tracking refs frozen at clone time). This is layer 1, the root-cause fix at clone creation. Frontmatter `updated:` bumped to 2026-06-02.
- `skills/dispatch-worktree/dispatch-prepare.sh`: extended the missing-bare-clone recovery hint (the `echo "... clone first via: git clone --bare ..."` block) with three echo lines pointing the operator at the `git config remote.origin.fetch ...` step. Echo-hint only; no change to the script's control flow. (No frontmatter; it is a shell script.)
- `skills/pr-handoff/SKILL.md` § Preconditions: added layer 2, the defense in depth. Before any shape that detaches at `origin/master` (Shapes 1, 2) or the upstream branch tip (Shape 3), verify `git rev-parse origin/master` against `git ls-remote origin master`; on disagreement, force `git fetch origin +refs/heads/master:refs/remotes/origin/master` before detaching. Added a dated 2026-06-02 *Notes from the field* line citing the #387 re-ferry (stale `c49fb048b` across four ferries; live tip `3c5753b67`) and pointing at the WORKTREES.md root-cause fix. Frontmatter `updated:` bumped to 2026-06-02.

**Consistency checks.** No new/renamed/retired role or skill, so `CLAUDE.md` § Current inventory is untouched (and stays correct after the concurrent `node-parity-test` addition that landed in the same window). Grepped `roles/`, `skills/`, `WORKTREES.md`, `CLAUDE.md` for `remote.origin.fetch` and `refs/remotes/origin`: the only other hits are in `skills/frozen-base-branch/SKILL.md`, which pushes the local view of upstream's tip and is unrelated to the fetch-refspec concern (no cross-reference to update). The relative link `../../WORKTREES.md` from `skills/pr-handoff/SKILL.md` resolves to the garden root. `bash -n dispatch-prepare.sh` passed. No em-dashes introduced in any edited prose; paths kept relative within-tree per the style skills.

Out of scope as directed: the bot-side #387 attribution regression (liaison follow-up 3) was not addressed; that is a fixer/retcon concern.

Self-improvement: `WORKTREES.md`, `skills/dispatch-worktree/dispatch-prepare.sh`, `skills/pr-handoff/SKILL.md`; encoded the empty-`remote.origin.fetch` stale-tracking-ref failure mode as a root-cause clone step plus a pr-handoff defense-in-depth precondition.
