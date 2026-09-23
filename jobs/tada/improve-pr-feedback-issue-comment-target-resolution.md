Done. All 32 tests pass, committed and pushed to `main2` (`a0cdc10068`).

## Completion report

**Job:** improve-pr-feedback-issue-comment-target-resolution

**The bug.** `scripts/jobs/gardening/pr-feedback-preflight.sh` resolved a triggering feedback id on only two surfaces — `pulls/<pr>/reviews/<id>` (review) and `pulls/comments/<id>` (inline comment). A PR **conversation** (issue) comment id lives on a third, disjoint surface, `issues/comments/<id>`. The comment-watcher mints feedback jobs from those conversation comments (`surface=pr-comment`, sourced from the `issues/comments` stream), so their ids resolved on *neither* surface, hit the could-not-resolve fail path, and **failed open with a throttled maintainer alert on every such job** — a wrong-surface alert flood, and no peer-resolution recheck ever ran.

**The fix.**
- Added a third resolution branch (`kind=issue_comment`) querying `repos/<repo>/issues/comments/<id>`, with an updated no-resolution message and header docs.
- Built appropriate evidence metadata for it: a conversation comment has no associated commit, so `reviewed_head_sha` is set to the **current head** — this satisfies the correlation contract's non-empty-SHA requirement while leaving the SHA-gated generic-acknowledgement path inert (that path fires only when the head has advanced past a reviewed head; a conversation comment has none). `created_at` is taken from `.created_at`.
- For this kind, the comment corpus also folds in the PR's conversation-comment timeline (the natural acknowledgement surface). Those comments carry no `in_reply_to_id`/`review_id`, so they can only match the id-citation body scan, never the thread checks.
- Refactored the two duplicated jq assembly blocks into one that extracts the target's scalar fields in bash and passes only the unbounded arrays via `--slurpfile` temp files — preserving the existing MAX_ARG_STRLEN/E2BIG protection.

**Tests.** Added four live-path tests (genuine gather path, fake `gh` that distinguishes single-object target lookups from paginated corpus fetches): clean resolution with **no gather-failure alert** (the core fix), commit-citation → NO-OP, conversation-comment-citation → NO-OP (proves the corpus is consulted), and generic ack without id-citation → PROCEED (proves the SHA path is inert). Suite: 32 passed, 0 failed. Existing review/inline behavior is byte-identical (verified by the unchanged pre-existing tests).

**Follow-ups:** none.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-pr-feedback-issue-comment-target-resolution.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 39 tokens (1475469 cached reads)
- Output: 33854 tokens
- Cost: $2.3355895
- Wall-clock: 433s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
