---
ts: 2026-06-09T14:01:00Z
kind: dispatch
role: steward
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: fixer
dispatch_root: /home/kris/dispatches/fixer--4d080c
prs:
  - repo: endojs/endo-but-for-bots
    pr: 75
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/75
  - https://github.com/endojs/endo-but-for-bots/commit/e627f7b13be2f048ecc35d1a8f7f0826ddf0c917#r188148024
---

# dispatch: fixer — revert package.json exports collapse on PR #75 per kriskowal commit-comment

Maintainer directive on the gibson042-feedback carry commit
(`e627f7b13` on PR #75's `kriskowal-random-chacha12` branch),
as a CommitCommentEvent at 2026-06-09T13:59:57Z:

> Please revert this. Some tools need to be able to import the
> `package.json`.

The line cited is
`packages/chacha12-fast-check-test/package.json:4`. The
fixer (`140d8f`) on 2026-06-09T03:55Z folded a mirror-sweep ask
into the carry: PR #75 thread `3223667088` had asked to collapse
the package's `exports` block to `{}`. kriskowal now says that
specific change was wrong because some tools need to be able to
import the `package.json`.

The 👀 reactji is already on the commit comment (`reactions/181279081`).

## State at dispatch time

- **PR** `endojs/endo-but-for-bots#75`
  ("feat(random,chacha12): factor @endo/random from @endo/chacha12
  [resync to actual/kriskowal-random-chacha20]"), OPEN (not
  DRAFT), base `master`, head `kriskowal-random-chacha12` at
  `e627f7b13` (the gibson042-feedback carry).
  `reviewDecision: CHANGES_REQUESTED` (carry-over from prior
  kriskowal review).

## Task

In your `project/` worktree on `kriskowal-random-chacha12` at
`e627f7b13`:

1. **Inspect the offending change**:
   `git show e627f7b13 -- packages/chacha12-fast-check-test/package.json`
   to see exactly what the carry commit changed. Confirm the
   `exports` block was collapsed to `{}` (or whatever the
   specific edit was).
2. **Determine the correct pre-change shape** by checking
   `git show e627f7b13~1:packages/chacha12-fast-check-test/package.json`
   (the parent commit's version) and reasoning about whether
   that's what kriskowal wants restored, or whether the right
   shape includes a `./package.json` exports entry to satisfy
   his "some tools need to be able to import the package.json"
   constraint.

   The likely correct shape is the pre-change one BUT with
   explicit `"./package.json": "./package.json"` entry to make
   the maintainer's concern unambiguous if it wasn't already
   present. Use your judgment based on what the parent commit
   has.
3. **Apply the revert** to
   `packages/chacha12-fast-check-test/package.json`. Don't
   `git revert` the whole commit (that would also revert the
   gibson042 substance changes the maintainer wants kept) —
   surgical edit to just the one file.
4. **Run pre-push-gates** locally to confirm clean.
5. **Commit** with a conventional commit message like
   `fix(chacha12-fast-check-test): restore package.json exports
   block per kriskowal commit-comment`. Single commit.
6. **Push** to `kriskowal-random-chacha12` (append push).
7. **Reply on the commit comment** via
   `gh api repos/endojs/endo-but-for-bots/comments/188148024/replies`
   citing the addressing commit SHA. If the replies endpoint
   doesn't exist for commit comments (it's an issue-style API),
   post a new commit comment on the addressing SHA OR a top-level
   PR comment on #75 naming the revert + the commit SHA + the
   maintainer's quoted ask.

## Authorizations (per-action, forwarded by steward)

- **Push commits** to `kriskowal-random-chacha12` (append push
  only). Implicit in the fixer dispatch.
- **Reply on the commit comment** or post a top-level PR comment
  on #75. Standing `endo-but-for-bots` broad-comment authorization.
- Do NOT amend `e627f7b13` — append a separate revert-the-one-file
  commit.

## Out of scope

- Do NOT revert anything else in `e627f7b13`. The 7 gibson042
  upstream suggestions stay applied. Only the
  `chacha12-fast-check-test/package.json` change is in scope.
- Do NOT re-request review (the maintainer just touched the PR;
  they'll re-review at their own pace).
- Do NOT touch any other file.
- Do NOT rebase or force-push.

## Deliverable

A `result` entry under `journal/entries/2026/06/09/` naming:

- Pre/post branch tip SHAs.
- The revert commit SHA + the exact restored exports-block shape.
- Pre-push-gates result.
- The reply URL (commit-comment reply or PR comment).
- A `Self-improvement: ...` line. The mirror-sweep that
  introduced this got the original ask from PR #75 thread
  `3223667088`; the lesson may be about verifying with
  maintainer before folding mirror-sweep asks that touch
  package-level shape, when the prior thread didn't itself have
  maintainer review.

End your turn with a concise summary back to the orchestrator. The
orchestrator tears down your dispatch root on return.
