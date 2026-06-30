Harden the review/attention dedup in `scripts/jobs/comment-watcher.sh` so a single COMMENTED review fans out to exactly one job. Today the review base key is `$slug-pr$pr-review-$(shorthash "$cid")` (per inline-comment id), while a sibling attention job for the same review keys differently, so `verify_posted` does not collapse them — the 4ae554560 review-comment/review-body dedup misses the case of a COMMENTED review carrying a single inline comment and an empty body (exactly the #544 fan-out). Make the review job base key canonical per `(repo, pr, review_id)` — resolve the enclosing `pull_request_review_id` for inline-comment and review-body surfaces and key on it — so all jobs minted from one review (inline comment, review body, and any attention sibling) share one `verify_posted` base and the second producer's post is an idempotent skip rather than a duplicate claim.

---
claim:
  host: endolinbot2
  gardener: 72
  claimed_at: 2026-06-30T04:22:19Z
