Pushed to main2 (`8f5bc6e7d..4ae554560`). 

## Completion report

**Job:** `garden-comment-watcher-dedup-inline-review-comment-jobs` — eliminate the duplicate jobs minted for an inline-bearing review (one `review` job from the `pr-review-body` surface + a separate job from the standalone `pr-review-comment` surface for the same inline comment).

**What I did**

Rebased on `origin/main2`, re-read both actively-touched files (line numbers had drifted), and implemented the dedup at the source/watcher boundary so the suppression stays observable in the journal.

- **`scripts/jobs/handlers/comment-source-gh.sh`** — reordered emission so inline review-comments (section 2) are emitted *after* the open-PR review walk (section 3). Section 3's review-body lines now go to a temp file from which I extract `surfaced_inline_rids` (the review ids surfaced this poll as `[INLINE-REVIEW]` pr-review-body jobs, parsed from section 3's *own* output so the set can't diverge). Section 2 then classifies each inline comment by its `pull_request_review_id`: if its parent review is in the surfaced set, it's emitted as `surface=pr-review-comment-subsumed`; otherwise it keeps the actionable `pr-review-comment` surface (covering closed/out-of-bound PRs, untrusted/dropped parents, and standalone PR-line comments — never lost). Watcher re-sorts by `created_at`, so the reorder is invisible there. Header TSV-surface enumeration updated.
- **`scripts/jobs/comment-watcher.sh`** — added a handler right after the boundary-dedup guard: a `pr-review-comment-subsumed` line is dropped without a job or reactji (the review job is its acknowledgment and will reply on the inline thread) and the cursor slides past it with a `SUBSUMED:` log line — honoring the ack_or_log_slide "never a silent drop" discipline.
- **`scripts/jobs/test/comment-watcher-test.sh`** — added `DEDUP1` (watcher: an `[INLINE-REVIEW]` body + its subsumed comment yields exactly ONE job, logged slide, cursor advances) and `DEDUP2` (source: a comment whose review is inline-surfaced is marked subsumed and not also emitted as plain `pr-review-comment`, while a comment whose review is *not* surfaced keeps the actionable surface).

**Verification:** full suite **123 passed, 0 failed** (was 115 + 8 new assertions). `bash -n` clean on both scripts; shellcheck shows only pre-existing `SC2034` warnings (GARDEN_TAG/bot, used via sourced common.sh), none in my edited regions. Existing source-level cases Q/Z/EE/SS1 still pass under the reorder.

**Correctness note:** I chose a `pr-review-comment-subsumed` surface (emitted, not silently dropped at the source) deliberately — a silent source drop could wedge the cursor when a comment's `created_at` is strictly newer than its review's `submitted_at` (the review re-surfaces at the inclusive boundary and is then boundary-skipped, leaving nothing to advance the cursor past the comment). Emitting the line lets the watcher advance the high-water mark while logging the suppression.

**Guarantees preserved:** garden #4 inline-only empty-body reviews are still surfaced (`[INLINE-REVIEW]`), and the sender-trust gate is untouched.

**Follow-ups:** none required. Three *distinct* reviews still correctly yield three per-review `review` jobs (each its own unit); consolidating concurrent edits across separate reviews on one PR is a different concern not in this job's scope.
