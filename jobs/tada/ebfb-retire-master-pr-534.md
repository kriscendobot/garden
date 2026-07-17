Job complete. The master base for endojs/endo-but-for-bots#534 has been retired cleanly.

## Completion report: retire master base for endo-but-for-bots#534

**Confirmed preconditions:** PR #534 was OPEN, draft, and targeting the raw `master` base (head `fix/cm-bundle-deferred-error-non-fatal`, head-owned by endojs). It was last updated 2026-06-25 (~3 weeks idle) but is a genuine single-commit fix (`fix(compartment-mapper): tolerate unresolved internal modules when bundling`), not an empty mirror.

**Topology found:** The fork base branch `endojs/endo-but-for-bots@master` has **diverged** from true upstream `endojs/endo@master` — 70 fork-only commits vs 16 upstream-only, common ancestor `a7ff1913fe`. The PR head was rooted in the fork-master lineage (`7c259920e8`), so a naive `git rebase upstream/master` dragged in 30 fork commits and conflicted immediately. Per the directive to source the base SHA from upstream endo (never the fork master), I replayed **only the PR's own commit** with `git rebase --onto upstream/master 7c259920e8` — clean, 1/1, no conflict.

**Actions taken:**
- Base SHA obtained from upstream `endojs/endo` master tip: `46d4edf317`.
- Reflection branch **reused** (already existed): `origin/master-46d4edf` == `46d4edf317`, no new push needed.
- Rebased head onto `46d4edf317`; verified the resulting diff is **byte-identical** to the original PR (6 files, +129/-5).
- Force-pushed head with `--force-with-lease` (`02640ade04...1edaab24c9`).
- Set PR base to `master-46d4edf`.

**Final state:** PR #534 OPEN, draft, base `master-46d4edf`, `MERGEABLE`, 6 files (unchanged content). `mergeStateStatus=UNSTABLE` is just CI re-running after the force-push.

**Fork master untouched** — no changes to `endojs/endo-but-for-bots@master`. No garden-side (main2) changes; this was a pure project-repo operation.

**Follow-up for maintainer:** The PR was ~3 weeks idle at the time of this sweep; the retirement itself was a clean focused weave, so it was not wedged. Worth a glance to confirm the fix is still wanted before undraft/gauntlet.
