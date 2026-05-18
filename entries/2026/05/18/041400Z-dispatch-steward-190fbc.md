---
ts: 2026-05-18T04:14:00Z
kind: dispatch
role: steward
project: endo-but-for-bots
to: "*"
prs:
  - repo: endojs/endo-but-for-bots
    pr: 280
    role: target
  - repo: endojs/endo
    pr: 3084
    role: source
---

# Dispatch: fixer drops Node 18 from PR #280 (cherry-pick endojs/endo#3084 + rebase + resolve)

Dispatch root: `dispatches/fixer--190fbc/`. Project worktree on `endojs/endo-but-for-bots@chore/drop-node-20-ci`.

## The directive

Maintainer kriskowal on PR #280 (verbatim):

> Drop 18 too. That's in flight upstream already. Consider cherry-picking that as a basline. Also, be sure to rebase and resolve conflicts.

The upstream-in-flight Node-18-drop is `endojs/endo#3084` (`ta/node-matrix`, OPEN, by tronical). Cherry-pick its CI-matrix changes as the baseline; #280's existing Node-20-drop changes layer on top.

## Per-action authorization

- Add or reuse remote `endo-upstream` pointing at `endojs/endo.git`.
- Fetch `endojs/endo#3084`'s commits.
- Cherry-pick relevant CI-matrix changes onto `chore/drop-node-20-ci`.
- Resolve conflicts.
- Rebase onto current `origin/master`.
- Force-push `chore/drop-node-20-ci` under kriscendobot.

## Task

### Step 1 — Fetch upstream + identify Node-18-drop diff

- `git remote add endo-upstream https://github.com/endojs/endo.git 2>/dev/null || true`
- `git fetch endo-upstream refs/pull/3084/head:upstream-pr-3084` (or just `git fetch endo-upstream ta/node-matrix`).
- `git log endo-upstream/master..upstream-pr-3084 --oneline` to see #3084's commit shape.
- The substantive change drops `18.x` from CI matrices in `.github/workflows/ci.yml` and related files.

### Step 2 — Cherry-pick the Node-18-drop onto #280

- `git checkout --detach origin/chore/drop-node-20-ci` (or local equivalent).
- Cherry-pick #3084's CI-matrix commits onto #280's branch. Some conflicts expected since both PRs touch the same matrix lines.
- Resolve: the union should drop BOTH 18.x AND 20.x; matrix becomes `[22.x, 24.x]`.
- Update `test-async-hooks` matrix similarly (drop 18 + 20 entries, keep 22 or 24).
- Update `cover` matrix.

### Step 3 — Rebase onto current master

- `git fetch origin master`
- `git rebase origin/master`. Resolve any further conflicts.

### Step 4 — Push

- `git push origin HEAD:chore/drop-node-20-ci --force-with-lease`.

### Step 5 — Optionally update title/body

- Title should reflect the broader scope: e.g., `chore(ci): drop Node.js 18 and 20 from the test matrix (per kriskowal feedback on #280; cherry-picks endojs/endo#3084 baseline)`.
- Body: add a section naming the cherry-pick source.

### Optional ack comment

Brief comment on #280 acknowledging the cherry-pick + drop-18 scope expansion, naming the upstream PR ref.

## Out of scope

- No changes to test fixtures themselves (only CI matrix).
- No comment on endojs/endo#3084 from the bot.
- No master-base mirror beyond #280 itself.

## Conflict handling

The matrix lines in `.github/workflows/ci.yml` are the obvious collision point. Resolve in favor of the union (drop 18 + 20). If `endojs/endo#3084` does other unrelated work (e.g., engines-field bumps, package-level changes), include those only if they're contiguous with the matrix drop; surface as impasse if non-trivial side-effects emerge.

## Report

≤ 500 words. Cherry-picked commit SHAs, conflict count, final commit list on `chore/drop-node-20-ci`, final head SHA, optional ack comment ID, one-line `Self-improvement: ...`.
