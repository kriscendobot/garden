# Fix: gardeners working a project repo must get ISOLATED worktrees (concurrent edits bled across on #58)
Garden-infra reliability bug. On endo-but-for-bots PR #58, TWO gardeners implementing the same fix found
one's edits appearing in the OTHER's project checkout — they shared a single endo-but-for-bots worktree.
Concurrent same-repo/same-branch jobs are corrupting each other (rewriting error-trace.js +
chat-bar-component.js simultaneously in one working tree).
**Expected:** per the dispatch contract (WORKTREES.md § per-dispatch worktree triple), each dispatched
worker gets its OWN detached project worktree; concurrent work must not share a checkout.
**Observation:** some gardeners DO get a per-job worktree (`scratch/gardener-wt-<base>/`, e.g. the ymax0
chain-state repro), yet the two #58 gardeners shared one. Investigate WHY:
- Does `gardener.sh` (and the project-worktree setup it uses) always create a UNIQUE per-job project
  worktree, or can two jobs for the same repo/branch resolve to the SAME path (e.g. a worktree keyed by
  repo+branch rather than by job/gardener id, or a shared standing checkout for endo-but-for-bots)?
- Trace the project-checkout creation for a PR-work job end to end.
**Fix:** ensure every gardener job that mutates a project repo gets an **isolated, uniquely-named
worktree** (keyed by gardener/job id, not just repo+branch), so two concurrent jobs on the same repo can
never share a working tree. Concurrent same-branch pushes still race at the git-push CAS (that's fine);
the WORKING TREES must be isolated. Add a test proving two concurrent same-repo jobs get distinct
worktree paths. Land on `main2` via an isolated worktree off origin/main2.
Related: this pairs with the double-dispatch problem (my manual rsvp jobs + the comment-watcher's
auto-jobs both firing per comment). Note it, but the WORKTREE ISOLATION is the corruption fix here.
