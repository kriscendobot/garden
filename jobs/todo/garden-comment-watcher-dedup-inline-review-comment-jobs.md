# Garden infra: comment-watcher mints duplicate jobs for inline-bearing reviews

## Defect

A single maintainer review that carries ONE inline comment (empty top-level
body) mints TWO jobs:
  1. a `review` job from the `pr-review-body` surface line (the [INLINE-REVIEW]
     path), whose body already instructs "enumerate EVERY inline comment tied to
     this review", and
  2. a separate `attention`/verb job from the standalone `pr-review-comment`
     surface line for the SAME comment.

The two are not deduplicated, so an inline comment is worked twice.

## Observed (evidence)

On endojs/endo-but-for-bots PR #548, erights left three inline comments on
2026-06-30 (designs/inter-package-plain-re-exports.md lines 139, 144, 149), each
submitted as its own empty-body COMMENTED review. The watcher produced SIX jobs
for the three comments:
  - pr-review-body: review-0ce05d3a (review 4597002890, line 139),
    review-3acbe409 (review 4597007634, line 144),
    review-77a2abe1 (review 4597012672, line 149)
  - pr-review-comment: 7d53248c, de62d521, 7ad385cd (the same three comments)
Six gardeners claimed and raced to edit the same design-doc section and push to
the same PR branch. It resolved without damage only because one gardener won the
consolidation race (commit 5055d0577 + one summary comment + three inline
replies) and the others stood down after a coordination message; absent that,
this is 6 racing pushes and up to 6 redundant summary comments on one PR.

## Root cause

- scripts/jobs/handlers/comment-source-gh.sh emits a `pr-review-comment` TSV
  line per inline comment (~line 107) AND a `pr-review-body` line per
  inline-bearing review (~line 178, the [INLINE-REVIEW] path added for garden
  #4 so inline-only empty-body reviews are not dropped). Both carry the same
  underlying inline comment(s).
- scripts/jobs/comment-watcher.sh routes the `pr-review-body` line to exactly
  ONE keyed `review` job (good) but processes each `pr-review-comment` line
  independently with no check for "is this comment already covered by a
  review-body job for its review id?" There is no dedup between the two surfaces.

## Proposed fix (author's discretion)

When a `pr-review-comment` belongs to a review that is (or will be) surfaced as
an inline-bearing `pr-review-body` job, DROP the standalone comment job — it is
subsumed by the review job, which already enumerates every inline comment tied
to the review. Concretely, the source already knows each comment's
`pull_request_review_id`; suppress a `pr-review-comment` line whose review id is
also emitted as a `pr-review-body` line in the same poll. Keep surfacing a
`pr-review-comment` only when its review is NOT inline-review-surfaced (rare:
e.g. a comment whose parent review is untrusted/non-actionable and dropped, or a
standalone PR-line comment not tied to a formal review). Slide the cursor past
the suppressed comment with a logged reason (never a silent drop, per the
existing ack_or_log_slide discipline). Add a regression case to
scripts/jobs/test/comment-watcher-test.sh: an empty-body inline-bearing review
with one inline comment yields exactly ONE job, not two.

## Constraints

- comment-watcher.sh / comment-source-gh.sh are actively-touched (HEAD commit
  1fc9b3cd9 is a comment-watcher change). Rebase on current origin/main2 and
  re-read both files before editing; the line numbers above will drift.
- Do all development in your own worktree off origin/main2; commit explicit
  pathspecs; push HEAD:main2 via a rebase CAS loop.
- Preserve the garden #4 guarantee (inline-only empty-body reviews are never
  silently dropped) and the sender-trust gate.
