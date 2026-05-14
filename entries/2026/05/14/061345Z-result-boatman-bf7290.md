---
ts: 2026-05-14T06:13:45Z
kind: result
role: boatman
project: endo
worktree: dispatches/boatman--re-ferry-chacha12-75--20260514-055521--5ed7e5/project
repo: endojs/endo
to: liaison
refs:
  - entries/2026/05/14/055605Z-dispatch-liaison-3a4b1c.md
  - entries/2026/05/14/021500Z-result-boatman-7c5e8a.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 75
    role: source
  - repo: endojs/endo
    pr: 3232
    role: target
---

(Reconstructed by the liaison from filesystem evidence after the boatman's Agent stream closed unexpectedly post-push but pre-journal. Second such recovery on the #75 ferry chain.)

Re-ferry of #75 complete. PR #3232 force-pushed to head `f87bf84257dc848203503dbc24014db95527eb80`. Prior tip `04664e52e` is preserved as an ancestor; the new tip is `04664e52e + 3 new commits`.

**Approach chosen** (different from the prior ferry; better in retrospect): cherry-picked the 3 new source-side commits directly onto the user's existing `04664e52e` tip rather than recomputing from upstream/master. This preserves the entire prior history including the b61c928e-anchored gibson042 review thread.

**The 3 new commits** (re-attributed to `Kris Kowal <kris@cixar.com>`):

1. `f4b5d2c24 refactor(ocapn): revert gratuitous randomNumber rename in fuzz tests` — addresses review comments 3239081576, 3239082370.
2. `1c2f94e3d chore(changeset): consolidate the two chacha12 changesets per review` — addresses review comments 3239072009, 3239062983, 3239068864, 3239067688, 3239064618.
3. `f87bf8425 test(random): pin random = randomUint53 * 2 ** -53 equivalence` — addresses review comment 3239085874. Adds a regression test pinning the float-extraction multiplier.

Each commit's body cites the upstream review comment IDs it addresses — useful provenance for reviewers reading the new commits.

**Attribution verified**: every commit in `04664e52e..HEAD` shows author `Kris Kowal <kris@cixar.com>` and committer `Kris Kowal <kris@cixar.com>`. `git interpret-trailers --parse` returns empty (no `Co-authored-by`, no bot trailers, no `Generated with [Claude Code]`).

**Cross-links**:
- Source-side cross-link comment on `endojs/endo-but-for-bots#75`: https://github.com/endojs/endo-but-for-bots/pull/75#issuecomment-4448135137 (posted by the liaison after the boatman's stream closed; content acknowledges the force-push and names the three new commits).
- Steward-bound message for the upstream explanatory comment on #3232: `entries/2026/05/14/061330Z-message-liaison-7e2b50.md` (reconstructed by the liaison; the boatman's identity-discipline routing instinct survives in the reconstruction).

**Open from the prior dispatch** (the `packages/random/test/random.test.js` 33-line drift): the boatman did not investigate the drift before this stream closed. The cherry-pick approach side-stepped the question — the upstream tip's state at `04664e52e` includes whatever drift was there, and the cherry-picks add only the 3 new commits' contents. If the drift represents a real lost-on-upstream test that source has, it would need a separate dispatch to investigate; flagging for liaison/user follow-up.

Self-improvement: nothing this time. The cherry-pick-on-prior-tip approach is the right shape for "fast-forward-ish source advance over a user-rebased upstream"; the prior dispatch's "compute merge-base from scratch" was correct but heavier-weight than this engagement needed. The procedure that's accreting is: **if the upstream branch is healthy and represents the work intended, cherry-pick new source commits on top with attribution rewrites; if the upstream branch has drifted from the work intended, recompute from upstream/master**. Worth landing in the eventual `skills/pr-handoff/SKILL.md`.
