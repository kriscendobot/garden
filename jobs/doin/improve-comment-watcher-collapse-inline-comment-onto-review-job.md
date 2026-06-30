Collapse the `pr-review-comment` surface onto the per-review job so one maintainer review can never mint two differently-keyed jobs (the #548 duplicate-fold: gardener `d6db5f` and designer `b93848` both folded erights' `pullrequestreview-4597029908` feedback, producing a redundant commit and two PR comments on 2026-06-30).

Root cause: in `scripts/jobs/handlers/comment-source-gh.sh` block 2 emits a `pr-review-comment` TSV line keyed on the inline comment id, while block 3 emits the `[INLINE-REVIEW]` `pr-review-body` line keyed on the review id. In `scripts/jobs/comment-watcher.sh` the `case "$VERB"` basename map sends the former through the `*` fallback (`base="$slug-pr$pr-$(shorthash "$cid$body")"`) and the latter through `review)` (`base="$slug-pr$pr-review-$(shorthash "$cid")"`). Different basenames ⇒ `verify_posted` never dedups them ⇒ two jobs for one review.

Fix (deterministic, no LLM): every inline comment carries a `pull_request_review_id`, and block 3 already surfaces every inline-bearing review as one `[INLINE-REVIEW]` unit, so the standalone per-inline-comment job is always redundant.
- In `comment-source-gh.sh` block 2, append `(.pull_request_review_id // empty)` to the `pr-review-comment` TSV tuple (add the column at the end so the watcher's positional `IFS=$'\t' read` is unaffected for existing surfaces).
- In `comment-watcher.sh`, when `surface = pr-review-comment` and a review id is present, set `VERB=review` and key the basename on `$slug-pr$pr-review-$(shorthash "$review_id")` (the same key block 3 uses). Then `verify_posted` collapses both surfaces onto the single `review` job — the inline ask gets handled exactly once by the review job that enumerates all inline comments. A `pr-review-comment` with no review id (shouldn't occur, but be defensive) keeps its current fallback behavior.
- Add a regression case to `scripts/jobs/test/comment-watcher-test.sh`: feed both a `pr-review-comment` line and the matching `[INLINE-REVIEW] pr-review-body` line for one review id and assert exactly one job basename is posted.

---
claim:
  host: endolinbot2
  gardener: 82
  claimed_at: 2026-06-30T03:52:57Z
