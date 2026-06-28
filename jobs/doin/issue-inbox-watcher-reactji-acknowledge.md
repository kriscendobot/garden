# issue-inbox-watcher: reactji-acknowledge issues + issue-comments (parity with the comment-watcher)

Map: **build** (garden infra) on branch main2. Isolated worktree off origin/main2;
explicit-pathspec commit; push HEAD:main2 via git-rebase CAS. Touches
`scripts/jobs/issue-inbox-watcher.sh` and `scripts/jobs/handlers/comment-reactji-gh.sh`.

## Gap (observed on kriskowal/garden #13, 2026-06-28)
The issue-inbox watcher posts a job for a trusted maintainer issue/comment but **never fires a
reactji** — `grep reactji scripts/jobs/issue-inbox-watcher.sh` finds nothing. The maintainer
opened #13 ("Garden bulletin needs favicon"), the watcher correctly posted
`issue-kriskowal-garden-13`, but the issue got **no 👀** and the maintainer was left "waiting for
a reactji." The comment-watcher already does this (👀 before posting); the issue path must match,
so the maintainer gets the immediate "I saw this" acknowledgment, not just an eventual reply.

## Required change
1. **Extend `comment-reactji-gh.sh` with an `issue` surface** → `repos/$repo/issues/<number>/reactions`
   (note: the id for an issue body is the ISSUE NUMBER, not a comment id). Keep the existing
   `issue-comment` / `pr-review-comment` surfaces.
2. **Fire the reactji in `issue-inbox-watcher.sh`** for every TRUSTED maintainer interaction it
   dispatches, BEFORE/with posting the job or sending the message (mirror the comment-watcher's
   ordering):
   - new ISSUE → react 👀 on the issue (surface `issue`, id = number);
   - new ISSUE-COMMENT → react 👀 on the comment (surface `issue-comment`, id = comment id).
   Wire it via a `GARDEN_ISSUE_REACTJI` handler default (like `GARDEN_COMMENT_REACTJI`), and on a
   reactji failure log a WARN and still post (don't block the dispatch).
3. Consistency: a reactji means "received," independent of actionability — pair this with the
   sibling no-silent-drop rules so a trusted interaction is ALWAYS at least acknowledged with 👀.

## Tests
Stub the reactji handler: assert a new trusted issue gets an `issue`-surface react and a new
trusted issue-comment gets an `issue-comment`-surface react, both before the job/message; assert
the `issue` surface hits `/issues/<n>/reactions`; assert a reactji failure does not block posting.

## Deliverable
The issue-inbox watcher reactji-acknowledges trusted issues and issue-comments (👀) like the
comment-watcher, the reactji helper gains the `issue` surface, with tests pinning the
acknowledge-before-post behavior.

---
claim:
  host: endolinbot
  gardener: 69
  claimed_at: 2026-06-28T17:48:06Z
