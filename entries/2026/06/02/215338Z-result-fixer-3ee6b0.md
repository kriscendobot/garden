---
ts: 2026-06-02T21:53:38Z
kind: result
role: fixer
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
prs:
  - repo: endojs/endo-but-for-bots
    pr: 387
    role: target
refs:
  - entries/2026/06/02/215115Z-dispatch-liaison-3ee6b0.md
  - https://github.com/endojs/endo-but-for-bots/pull/387
  - https://github.com/endojs/endo-but-for-bots/pull/387#discussion_r3344170182
---

# result: fixer — #387 reverted `.bench-engines` → `.engines`, re-retconned

Addressed kriskowal's discussion comment 3344170182 by reversing the
prior fixer's `.engines` → `.bench-engines` rename across the three
benchmark files and folding the reversal into the existing
implementation commit via retcon.

## New head SHA

`e22369065` (force-pushed over `a66f3c344`).

## Branch shape

Two commits atop `origin/master-814dfa1` (`814dfa1fd`):

```
e22369065 chore: Update yarn.lock
38fd6a87d fix(benchmark): install xs/v8 via direct download instead of esvu
```

## Procedure followed

1. Tagged `pre-retcon-3ee6b0` at `a66f3c344` for the net-diff sanity check.
2. `git reset --soft origin/master-814dfa1` (preserved the working tree, unstaged the two tip commits).
3. Replaced `.bench-engines` → `.engines` across the three benchmark files (23 occurrences total).
4. Staged implementation files (`packages/benchmark/` and `packages/hex/test/run-benches.sh`); left `yarn.lock` unstaged.
5. Committed implementation as `fix(benchmark): install xs/v8 via direct download instead of esvu`.
6. Staged `yarn.lock` and committed as `chore: Update yarn.lock`.
7. Force-with-lease push using `a66f3c344` as the lease anchor.
8. Deleted the local `pre-retcon-3ee6b0` tag.

## Pre-push verification outputs

`git log --oneline origin/master-814dfa1..HEAD`:

```
e22369065 (HEAD) chore: Update yarn.lock
38fd6a87d fix(benchmark): install xs/v8 via direct download instead of esvu
```

`git grep -c bench-engines`: zero matches in the working tree (no output).

`git diff origin/master-814dfa1..HEAD --stat`:

```
 packages/benchmark/README.md          |   2 +-
 packages/benchmark/install-engines.sh | 100 ++++++++++++++++++++++++++++------
 packages/benchmark/package.json       |   1 -
 packages/benchmark/run-tests.sh       |   4 +-
 packages/hex/test/run-benches.sh      |   6 +-
 yarn.lock                             | 462 +--------------------------------
 6 files changed, 99 insertions(+), 476 deletions(-)
```

`git diff pre-retcon-3ee6b0..HEAD --stat` (the retcon net-diff sanity check; should show only the reversal):

```
 packages/benchmark/README.md          |  2 +-
 packages/benchmark/install-engines.sh | 40 ++++++++++++++++------------------
 packages/benchmark/run-tests.sh       |  4 ++--
 3 files changed, 23 insertions(+), 23 deletions(-)
```

Every changed line is exactly `.bench-engines` → `.engines`; no other content changed. The reversal hits 1 line in README.md, 20 lines in install-engines.sh, 2 lines in run-tests.sh.

## Push

Command:

```
git push --force-with-lease=fix-benchmark-wget-engines-master:a66f3c344 \
  origin HEAD:fix-benchmark-wget-engines-master
```

Result: `+ a66f3c344...e22369065 HEAD -> fix-benchmark-wget-engines-master (forced update)`, exit status 0.

## Acknowledgment comment

None posted. The dispatch brief flagged it as optional ("the maintainer asked for the rebase, not a discussion"); the force-pushed SHA is the artifact. The push itself surfaces on the PR.

Self-improvement: nothing this time. The dispatch brief was complete and the procedure executed without ambiguity; the only minor friction (the base was named `origin/master-814dfa1` rather than the bare `master-814dfa1` the brief named) resolved on first inspection. If anything, the brief might prefer `origin/master-814dfa1` for the base reference since the unqualified form requires a local branch that did not exist in the dispatch worktree.
