---
ts: 2026-05-21T06:06:49Z
kind: result
role: weaver
worktree: dispatches/weaver--f333d1/project
repo: endojs/endo-but-for-bots
project: endo
refs: []
---

# weaver f333d1 — sync master + rebase #244

Maintainer ask on #244 at 2026-05-21T06:01:01Z: "Please sync master with actual/master and rebase this on master. There are extra commits on the PR."

## Master sync

- Pre: `origin/master` = `9213d2c56`. `endo-upstream/master` = `bf951df34` (22 commits ahead, strict fast-forward; `git merge-base origin/master endo-upstream/master` returned origin/master itself).
- Push: `git push origin bf951df34:refs/heads/master --force-with-lease=master:9213d2c56` succeeded (`9213d2c56..bf951df34`).
- Post: `git ls-remote origin master` = `bf951df34`. Verified.

## PR #244 rebase

- Pre-rebase head: `292322fac` (parent `0ec70c6dd`, i.e. PR branch sitting on the older fork-master tip).
- Post-rebase head: `e1b1b2f65` (parent `bf951df34`, the freshly synced master).

The "extra commits" the maintainer flagged were the 28 master-side commits sitting between the PR's GitHub-stored base SHA (`c2fc02eb8`, captured at PR-open time and unchanged since) and the PR branch's parent `0ec70c6dd`. They were never "extra" in the sense of belonging to the branch's own history; they were ordinary master commits that GitHub displayed inside the PR because the PR's base was stale. Fast-forwarding `master` past them collapses the PR diff back to the 8 in-scope feature commits. No commits were dropped by the weaver; the master sync did the narrowing.

The 8 in-scope commits, all related to `unicorn/numeric-separators-style` enablement, replayed onto `bf951df34`:

| original   | rebased    | subject                                                                 |
| ---------- | ---------- | ----------------------------------------------------------------------- |
| 6f19761da  | f514ca463  | chore(eslint-plugin): require underscore-delimited groups in numeric literals |
| 180e184b2  | b1f02ea26  | chore: Update yarn.lock                                                 |
| 7faa80774  | 0adb63457  | chore: migrate numeric literals to underscore-delimited grouping        |
| b583f9259  | 753318b43  | chore: prettier --write on autofix-touched files                        |
| 0739b4f8c  | 27b462139  | test(eslint-plugin): pin internal preset's numeric-separators-style wiring |
| 4b23bb2b1  | f3e79caaf  | chore(eslint-plugin): group hex digits by two bytes                     |
| bd2b040b1  | 44b42f50f  | chore(hex): exempt mnemonic seed literals from numeric-separators rule  |
| 292322fac  | e1b1b2f65  | chore(marshal,cli): exempt comparison literals from numeric-separators rule |

## Conflict

One UU conflict during replay of the migration commit (`7faa80774` -> `0adb63457`):

- File: `packages/ocapn/test/python-test-suite/index.js`.
- HEAD side (new master, from `bdb9ddc50` "feat(ocapn): add opt-in syrup framing to TCP-testing netlayer"): added a `framing: 'none'` option plus a 4-line comment explaining why the Python test suite needs the unframed mode.
- Branch side (migration autofix): rewrote `specifiedPort: 22046` to `specifiedPort: 22_046`.
- Resolution: kept both. The final hunk is `specifiedPort: 22_046,` followed by the comment block and `framing: 'none',`. Both intentions preserved; no silent drop. (Consistent with `skills/conflict-resolution/SKILL.md`: the markers showed disagreement but the intents were orthogonal, so the resolution honors both.)

Remaining 5 commits replayed clean.

## Pushes

- `git push origin HEAD:chore/eslint-numeric-separators-style-master --force-with-lease=chore/eslint-numeric-separators-style-master:292322fac` succeeded (`292322fac...e1b1b2f65 (forced update)`).
- Post-push `gh pr view 244`: base `bf951df34`, head `e1b1b2f65`, 8 commits. PR diff now scoped to numeric-separators-style only.

## Notes

- Tests were not run inside the dispatch (CI on the pushed branch will exercise the affected packages; lint is the PR's own test surface per the description, and the rebase preserved file-for-file the migration commits' diffs except for the one resolved file).
- No `chore: Update yarn.lock` regeneration was needed: the existing yarn.lock commit replayed cleanly (190-line addition, identical shape pre/post).

Self-improvement: nothing this time.
