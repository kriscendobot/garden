# Fix: review-directive job bodies emit a non-paginated comment-fetch command

## Problem

`scripts/jobs/comment-watcher.sh` line ~386 bakes this command into every
review-directive ("whole review as the unit of work") job body it emits:

    gh api repos/<repo>/pulls/<pr>/comments --jq '[.[]|select(.pull_request_review_id==REVIEW_ID)]'

This is MISSING `--paginate`. The `gh api` default page size is 30, so on any
PR whose total review-comment count exceeds 30, this command silently returns
a SUBSET (often an EMPTY set, because the targeted review's comments tend to
have the highest ids and land on later pages). A gardener that follows the
job body literally will under-count or entirely miss the inline comments it is
supposed to resolve — exactly the "fetch ALL inline comments tied to a review"
failure the maintainer has corrected before.

Observed live on endojs/endo-but-for-bots PR #507 review 4576852574
(2026-06-26): the templated command returned `[]` while the review actually
carried 17 inline comments. The job was only completed correctly because the
gardener noticed the discrepancy via a peer message and re-fetched with
`--paginate`. The handler script `scripts/jobs/handlers/comment-source-gh.sh`
already uses `--paginate` correctly; only the human-facing instruction string
in the job body is wrong.

## Fix

In `scripts/jobs/comment-watcher.sh`, the `printf` that emits the enumerate
command (currently around line 386): add `--paginate` to the `gh api` call so
the job body reads:

    gh api --paginate repos/<repo>/pulls/<pr>/comments --jq '[.[]|select(.pull_request_review_id==REVIEW_ID)]'

Grep the rest of the file (and any sibling templates under scripts/jobs/) for
other `gh api .../comments` or `.../reviews` enumerations emitted into job
bodies WITHOUT `--paginate` and fix them the same way. The review-body fetch
on the next line (`pulls/<pr>/reviews/REVIEW_ID --jq .body`) is a single
object and does not need pagination.

## Build note

This is a shared-file edit in the garden repo. Build it in an isolated
worktree off origin/main2 (the shared /home/kris main2 tree is concurrently
mutated by other gardeners): worktree-add off origin/main2, apply the one-line
edit, commit the explicit pathspec, push HEAD:main2. Do not `git reset --hard`.

## Done when

- The emitted review-directive job body contains `gh api --paginate ...` for
  the inline-comment enumeration.
- A grep of scripts/jobs/ confirms no other job-body-emitted comment/review
  enumeration is missing `--paginate`.

---
claim:
  host: endolinbot
  gardener: 69
  claimed_at: 2026-06-26T05:57:02Z
