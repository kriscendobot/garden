# Comment-watcher must not overlap the issue-inbox: skip issue-comments on issue-inbox repos; re-arm kriskowal-garden PR-only

Map: **build** (garden infra) on branch main2. Isolated worktree off origin/main2;
explicit-pathspec commits; push HEAD:main2 via git-rebase CAS. Touches
`scripts/jobs/comment-watcher.sh` / `scripts/jobs/handlers/comment-source-gh.sh` and the
`comment-repos` arming.

## Problem (observed on kriskowal/garden #9, 2026-06-30)
`garden-issue-inbox` AND `garden-comment-watcher@kriskowal-garden` BOTH poll kriskowal/garden
ISSUE-comments. A maintainer comment on issue #9 therefore got a job from EACH watcher (the
journal shows both an `issue-kriskowal-garden-9` job and a `kriskowal-garden-pr9-*` job, both
done by endolinbot2 gardeners) → DUPLICATE responses. The maintainer read it as "endolinbot and
endolinbot2 both responding"; it is actually ONE host running two overlapping watchers (the
git committer is named `endolinbot` while the host's GARDEN is `endolinbot2`, which adds to the
confusion — the GARDEN side is handled by the queued
`leader-marker-journal-leader-and-garden-env-var` refactor).

Interim already applied: the `kriskowal-garden` comment-watcher is stopped/disabled AND its
`comment-repos/kriskowal-garden` arm record is removed, so the issue-inbox is the sole handler
and a deploy won't re-enable the overlap. This job restores PR-review coverage WITHOUT the overlap.

## Root cause
The comment-watcher surfaces issue-comments for any armed repo, unaware that a repo may also be
covered by an **issue-inbox** watcher (which owns issues + issue-comments, per
`config/garden-repo`). The two watchers' surfaces overlap on issue-comments.

## Required fix
1. **The comment-watcher handles only its UNIQUE surface on issue-inbox-covered repos** — PR
   comments + PR reviews — and SKIPS `surface=issue-comment` for any repo that an issue-inbox
   watcher covers (the repo equals the issue-inbox's `config/garden-repo`, or a per-repo arming
   flag). Issue-comments there belong solely to the issue-inbox. Make it deterministic and logged.
2. **Re-arm `comment-repos/kriskowal-garden` in PR-ONLY mode** so garden PR reviews (e.g. the #5
   "convert to job" review) are still caught — add an arming field such as `surfaces: pr-only`
   (or derive pr-only automatically when an issue-inbox covers the repo). endo-but-for-bots (no
   issue-inbox) keeps full coverage.
3. **Secondary — cursor must advance past a DROPPED newest comment.** The kriskowal-garden
   comment-watcher was re-dropping the same `cid=4839300009` (verb-gate:not-actionable) on every
   tick without advancing past it. The boundary dedup ("skip at-or-before cursor") must skip a
   comment whose `created_at == cursor`, and the drop's high-water mark must persist, so a dropped
   newest comment is not re-processed each tick. Affects all comment-watcher instances (incl.
   endo-but-for-bots).

## Tests
A maintainer issue-comment on an issue-inbox-covered repo is processed by the issue-inbox ONLY
(comment-watcher skips it, logged); a PR review on that same repo IS processed by the
comment-watcher; a dropped newest comment is not re-processed on the next tick; endo-but-for-bots
(no issue-inbox) still gets full comment+review coverage.

## Deliverable
No surface overlap between the comment-watcher and the issue-inbox (comment-watcher = PR-only on
issue-inbox-covered repos), kriskowal-garden re-armed PR-only, the cursor-advance-past-drop fix,
with tests pinning no-duplication + retained PR-review coverage.
