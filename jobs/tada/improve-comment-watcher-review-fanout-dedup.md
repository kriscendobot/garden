Done. Completion report:

## Completion report

**Job:** Harden the review/attention dedup in `scripts/jobs/comment-watcher.sh` so a single COMMENTED review fans out to exactly one job (the #544 fan-out).

**What I found.** Two prior commits already on `main2` partially addressed this: `4ae554560` (per-poll `subsumed` marking — dedups only when the review-body and inline comment co-surface in one poll) and `2161742cc` (folds an inline `pr-review-comment` onto its review id across ticks). What remained, per the task's explicit "any attention sibling" requirement: the review base key's canonicality was *implicit* (the `pr-review-body` path relied on the source convention `cid == review_id`), and the comment-id `*)` fallback could still mint a sibling job for a review surface that didn't classify as `review`.

**What I changed** (`scripts/jobs/comment-watcher.sh`):
- Resolve the enclosing `pull_request_review_id` **once, up front**, into a canonical `REVIEW_KEY` for all three review surfaces (`pr-review-body`'s `cid` *is* the review id; the inline surfaces carry it in the 8th TSV column). The `review` job keys on this.
- Removed the now-redundant `REVIEW_KEY="$review_id"` assignment inside the fold (pre-resolved).
- Hardened the base-key fallback: any job minted from a surface that demonstrably belongs to a review (a review body, or an inline comment carrying a real `review_id`) keys on the review id — never the comment id — so an `attention`/verb sibling can't fan out a second job. Standalone PR-line comments (no `review_id`) and conversation/issue comments keep their comment-id key.

**Test** (`scripts/jobs/test/comment-watcher-test.sh`): added **DEDUP4**, the exact #544 across-tick shape — an empty-body COMMENTED review in tick 1, then its single inline comment in a later poll — asserting exactly one `review` job (idempotent `verify_posted` skip), no comment-id-keyed sibling, fold logged, cursor advanced. Full suite: **134 passed, 0 failed**, both before and after rebase.

**Pushed:** `99d8d478b` → `main2` (rebased cleanly over a concurrent unrelated commit; CAS push succeeded on attempt 1).

**Follow-ups:** none required. The new `*)` review-surface branch is defensive depth — under the current fold/classify invariants a review surface always classifies as `review`, so it's a guard against future routing changes rather than a currently-reachable path.
