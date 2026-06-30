Done. Completion report:

## Completion report

**Job:** Collapse the `pr-review-comment` surface onto the per-review job so one maintainer review can never mint two differently-keyed jobs (the #548 erights duplicate-fold).

**What I did** — implemented the deterministic, no-LLM fix exactly as specified, in three files:

1. **`scripts/jobs/handlers/comment-source-gh.sh`** — block 2 now appends the inline comment's `pull_request_review_id` (the existing `$rid` jq var, `// "" | tostring`) as a trailing **8th TSV column** on the `pr-review-comment`/`pr-review-comment-subsumed` surfaces. Appended last so the watcher's positional `read` is unaffected for every other surface (none carry an 8th column). Updated the header's TSV-columns doc to record the new optional column and why.

2. **`scripts/jobs/comment-watcher.sh`** — added `review_id` to the loop's `IFS=$'\t' read`. When `surface = pr-review-comment` and a review id is present, a trusted sender's inline comment now folds onto its review: `VERB=review` (with `PRIMARY_VERB` reset to avoid a stale carry) and the base keyed on `$slug-pr$pr-review-$(shorthash "$REVIEW_KEY")` where `REVIEW_KEY` = the review id — the **same key** the `pr-review-body` line uses. So `verify_posted` collapses both surfaces onto the single per-review `review` job *across ticks* (the durable complement to the per-poll `subsumed` marking, which only dedups when both co-surface in one poll). Untrusted reviewers' inline comments are dropped via `ack_or_log_slide`, mirroring the review-body path's untrusted-drop. A `pr-review-comment` with no review id falls through to the unchanged classify path. The fold is logged (`FOLD:`), never silent.

3. **`scripts/jobs/test/comment-watcher-test.sh`** — added **DEDUP3**: feeds a `pr-review-comment` line (with the 8th review-id column) plus the matching `[INLINE-REVIEW]` `pr-review-body` line for one review id, and asserts exactly one job basename (`$SLUG-pr548-review-…`) is posted, the fold is logged, and the cursor advances past both.

**Verification** — full suite: **127 passed, 0 failed** (was 123 before; +4 from DEDUP3). `bash -n` clean on all three; shellcheck shows only pre-existing SC2034 warnings unrelated to the change. DEDUP1/DEDUP2 (the existing per-poll subsumed-dedup cases) still pass, confirming no regression.

**Pushed:** `2161742cc` on `origin/main2` (CAS push succeeded first attempt). Inbox was empty.

**Follow-ups:** none required. One minor latent note for a future pass (out of scope here, not introduced by this change): the `review` job-body template's "REVIEW_ID is the trailing number in the Review URL" instruction assumes a review URL; when a `review` job is minted *from* an inline comment (the rare case where the comment surfaces alone, e.g. on a closed PR), the URL is the inline-comment URL whose trailing number is the comment id — but the job body also gives the exact `pull_request_review_id` enumeration command, so a gardener can still resolve it. Worth tightening only if it ever bites.
