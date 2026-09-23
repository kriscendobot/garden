---
type: result
role: gardener
job: pr-ebfb-507-fixer
repo: endojs/endo-but-for-bots
pr: 507
branch: design/notifier-pubsub-migration
project: endo-but-for-bots
anchor: 528458a29
pushed: 8c2a46bed
date: 2026-06-24T09:48:58Z
prs:
  - https://github.com/endojs/endo-but-for-bots/pull/507
---

# Result: gardener job pr-ebfb-507-fixer (fixer on #507)

Design PR #507 (`design: notifier pubsub migration to @endo/exo-pubsub`) on the
`llm`-based `design/notifier-pubsub-migration` branch. CHANGES_REQUESTED;
heavy multi-revision discussion. Worked as fixer.

## What I addressed (revision 5, HEAD 8c2a46bed)

Enumerated all review threads. Four must-fix items were outstanding: the three
from kriskowal's latest CHANGES_REQUESTED (review 4557273696) plus one earlier
request (coalescing accumulator, comment 3457330315) that revisions 3 and 4 had
never replied to.

1. **makeCancelKit home** (3463086558): resolved to `@endo/cancel`. Verified the
   package does NOT exist on `llm` (no `packages/cancel/`, no `makeCancelKit`),
   so per the maintainer's "otherwise gated on merging the cancel package" the
   design is now explicitly gated on `@endo/cancel` landing. Surfaced as a
   prerequisite sibling PR (does not yet exist; no open PR for it).
2. **Latest replay** (3463089226): folded "Latest always replays to a late
   subscriber" into `makeLatestPubSub` as a settled decision.
3. **hot/cold** (3463095990): added both `hotTopicFromExoStream` (eager) and
   `coldTopicFromExoStream` (lazy) as sibling adapters; recommended the
   reactive-streams hot/cold naming with rationale.
4. **Coalescing accumulator** (3457330315): added first-class `coalesceReader`
   consumer-side middleware with caller-supplied reducer (OT-capable) + optional
   debounce.

Open questions section emptied; resolved items folded into prose. Updated the
metadata status to revision 5 and the cross-design coordination table.

## Outward-facing artifacts (standing authorization: endo-but-for-bots is "yours")

- 4 inline thread replies citing SHA 8c2a46bed (discussion_r3466109345,
  r3466109456, r3466109586, r3466111399).
- Top-level summary comment (issuecomment-4787944947) with an @kriskowal mention.

## Coordination / follow-ups

- **Prerequisite**: `@endo/cancel` must be created and land on `llm` before the
  pubsub packages can build. No PR or job exists for it yet; candidate for a
  builder/designer dispatch.
- **Parallel work**: `@endo/pubsub` implementation is in flight as #513 (job
  pr-ebfb-513-gamut in doin); this design stays aligned.
- **Minor**: `designs/README.md` has no row for this design (pre-existing gap,
  not review-flagged); left out of scope to avoid a half-baked plan row.

## CI / re-request

Re-pushed for CI; design checks were green pre-push. Re-requesting kriskowal's
review once CI converges green on the new head.

Self-improvement: nothing this time.
