---
ts: 2026-06-06T04:50:00Z
kind: dispatch
role: steward
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: weaver
dispatch_root: /home/kris/dispatches/weaver--baa56b
prs:
  - repo: endojs/endo-but-for-bots
    pr: 75
    role: target
  - repo: endojs/endo
    pr: 3232
    role: source
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/75
  - https://github.com/endojs/endo/pull/3232
---

# dispatch: weaver — re-sync bot mirror endo-but-for-bots#75 with upstream endo#3232 and rebase on current master

User directive (2026-06-06, this terminal session): *"Please take the
changes at https://github.com/endojs/endo/pull/3232 and rebase them on
actual master and push to our mirror of that PR."* The bot-side mirror
is `endojs/endo-but-for-bots#75`, branch
`kriskowal-random-chacha12`. The user named no retcon; this is a
content-refresh + rebase only, not a history rewrite.

## State at dispatch time

- **Upstream PR** `endojs/endo#3232` ("feat(chacha12): Consolidate
  PRNG for fuzzing"), branch `kriskowal-random-chacha20`, head
  `71055ef`, base `master` at `5865ff1`. 11 commits.
  reviewDecision REVIEW_REQUIRED, mergeable CONFLICTING,
  mergeStateStatus DIRTY. Updated 2026-05-21T06:38:16Z.
- **Bot mirror PR** `endojs/endo-but-for-bots#75`, branch
  `kriskowal-random-chacha12`, head `77f4e05`, base `master` at
  `6804b7d` (note: behind current bot master). 11 commits with
  the same headlines as upstream in the same order.
  reviewDecision CHANGES_REQUESTED, mergeable UNKNOWN. Updated
  2026-05-22T02:25:52Z.
- **Bot master** `endojs/endo-but-for-bots/master` at `5865ff10`
  (already in sync with `endojs/endo/master` after the earlier
  same-cycle fixer dispatch for PR #351; no master sync needed
  this dispatch).

## Task

In your `project/` worktree on detached HEAD of
`kriskowal-random-chacha12`:

1. **Add the upstream remote** (idempotent):
   `git remote add upstream https://github.com/endojs/endo.git`
   (skip on `already exists`).
2. **Fetch upstream's PR branch**:
   `git fetch upstream kriskowal-random-chacha20`.
3. **Reset local HEAD to upstream's PR head**:
   `git reset --hard upstream/kriskowal-random-chacha20`. After this,
   you have upstream's 11 commits on a detached HEAD.
4. **Fetch origin** (cheap) and **rebase onto bot master**:
   `git rebase origin/master`. Upstream is CONFLICTING against its
   own base, so conflicts are likely; resolve them. Per the
   maintainer's standing pattern (see `skills/conflict-resolution/
   SKILL.md` and the `endo-but-for-bots` project README), prefer the
   incoming change semantically for `yarn.lock`; for code conflicts,
   carry the upstream PR's intent (the changes you're rebasing) over
   the master-side intervening commits.
5. **Force-with-lease push** the rebased history:
   `git push --force-with-lease=kriskowal-random-chacha12:77f4e052ed1f6ad8d09f50ab90ca27f0d716fbf2 origin HEAD:kriskowal-random-chacha12`.
   The lease anchor is the current mirror head `77f4e05`. Refuse and
   surface to liaison via a `message: weaver → liaison` if the lease
   fails (means a sister session pushed since).

## Authorizations (per-action, forwarded by steward)

- **Force-with-lease push** to bot
  `kriskowal-random-chacha12` (the head of PR #75). Lease anchor
  `77f4e05`. Implicit in the dispatch's "rebase #N" framing.
- **Top-level summary comment** on PR #75 after the push lands,
  briefly noting that the mirror was re-synced to upstream
  `endojs/endo#3232` (head `71055ef`) and rebased on current bot
  `master` (`5865ff10`), and that any conflict resolution was
  recorded. The `endo-but-for-bots` standing broad-comment
  authorization covers this without further per-action grant.

## Notes and pitfalls

- The upstream PR is CONFLICTING against its own base
  (`mergeStateStatus: DIRTY`). The conflict is between the
  upstream PR's 11 commits and intervening master commits since
  `bf951df`; you will hit those same conflicts when rebasing onto
  bot master (the two masters are in sync).
- Net diff is **not** guaranteed invariant across this rebase: the
  conflict resolution may consolidate or adjust hunks against the
  newer master state. Record any resolution decisions in your
  `result` entry so the panel re-run (next driver tick) can read
  them.
- This is **not** a retcon. Keep the 11 commits as 11 commits. If
  you find the rebase produces an obviously wrong shape (e.g., a
  commit that becomes empty under the resolution), drop the empty
  commit and note the drop in the result; do not regroup into per-
  package commits.
- The mirror PR's `reviewDecision` is CHANGES_REQUESTED. After the
  push, the prior inline review comments may or may not still pin
  to the same lines; the panel re-run (driver lane) will sort that
  out. The weaver does not address review feedback.

## Deliverable

A `result` entry under `journal/entries/2026/06/06/` naming:

- The pre-rebase and post-rebase mirror HEAD SHAs.
- The base SHA at rebase time (current bot master).
- Per-file or per-hunk conflict-resolution notes for any non-trivial
  resolution.
- The summary-comment URL (if posted).
- A `Self-improvement: ...` line per the standing skill.
