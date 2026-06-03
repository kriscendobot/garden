---
ts: 2026-06-03T05:48:21Z
kind: dispatch
role: liaison
project: garden
refs:
  - entries/2026/06/03/053540Z-dispatch-liaison-04ea20.md
---

Dispatched gardener (dispatch-root `dispatches/gardener--f801a3`) to encode the dispatch-prepare / fetch-refspec reconciliation surfaced by the #411 fixer provisioning failure.

Problem: `skills/dispatch-worktree/dispatch-prepare.sh` runs `git --git-dir=<bare> worktree add --detach <path> <BRANCH>` with the bare branch name (e.g. `ci/cache-playwright-browsers`). But last turn's encode added `remote.origin.fetch = +refs/heads/*:refs/remotes/origin/*` to the bare clones, so `git fetch origin` now routes branches created AFTER the initial clone into `refs/remotes/origin/*`, NOT `refs/heads/*`. A bare branch name like `ci/cache-playwright-browsers` does not resolve against a remote-tracking ref, so `worktree add` fails for any post-clone branch (the boatman/weaver/fixer dispatch silently gets an empty DISPATCH_ROOT). Original-clone branches (master, and branches present at clone time) still live in refs/heads/ and work; the failure only hits branches born after the clone.

Fix (gardener's judgment on the cleanest form): make dispatch-prepare resolve the branch robustly — e.g. before `worktree add`, `git --git-dir=<bare> fetch origin "<BRANCH>:<BRANCH>"` to land it in refs/heads/, OR have it try `<BRANCH>` then fall back to `origin/<BRANCH>` (worktree add accepts a remote-tracking commit-ish in detached mode). Update WORKTREES.md and any doc that describes the bare-clone/refspec setup so the two stay consistent with last turn's refspec encode. Add a Notes-from-the-field line citing the 2026-06-03 #411 provisioning failure.

Commit on main, push HEAD:main; write a result entry. No inventory change expected.
