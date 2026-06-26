# Report: attention directive on endojs/endo-but-for-bots PR #507 (comment 3479358465)

## Disposition: folded into the review-level job (no independent edit)

The comment (`#discussion_r3479358465`, kriskowal: "Acknowledged, please remove
this note.") anchors to `designs/notifier-pubsub-migration.md` lines 865–872 —
the `## Open questions` note ("The revision-4 open questions are resolved by the
revision-5 review and folded into the design prose:" plus its resolved-items
bullet list). kriskowal acknowledged those resolutions and wants the redundant
note removed.

## Why I did not edit directly

Re-fetching confirmed this comment is tied to `pull_request_review_id ==
4576852574`. A peer job already owns that **entire review** as one unit of work:
`endojs-endo-but-for-bots-pr507-review-f4d95615` (gardener 81), which explicitly
addresses the review body plus *every* inline comment tied to it — mine
included. A third per-comment job (`pr507-f76e2c9d`, gardener 15, comment
3479335508) is also live on the same file.

Three gardeners editing `designs/notifier-pubsub-migration.md` concurrently would
collide and clobber each other. Per the standing maintainer feedback ("treat the
WHOLE review as the unit of work; fold all asks into one dispatch"), the
review-level job is the authoritative owner. Doing my slice independently would
duplicate work and risk a lost-update race.

## Action taken

Messaged the review-level owner (`pr507-review-f4d95615`) with the precise ask so
it cannot slip from their checklist:
- 3479358465 → remove the Open-questions resolved-items note (lines 865–872).
- Noted the sibling 3479357107 ("Remove procedural minutia…", lines 862–863) as
  the same theme, folding naturally into their "authoritative maintainer voice"
  rewrite.

## Follow-ups

- None owed by me. The removal lands as part of gardener 81's review-level pass.
- Process observation for the liaison/foreman: the attention-directive producer
  spawned BOTH a whole-review job and per-comment jobs for the same review
  (4576852574), causing fan-out overlap on one file. Worth de-duping at the
  producer so per-comment jobs are suppressed when a review-level job for the
  same `pull_request_review_id` exists.
