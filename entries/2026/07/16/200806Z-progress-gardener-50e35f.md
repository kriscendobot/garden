---
kind: progress
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-07-16T20:08:08Z
---
# SturdyRef press tick (2026-07-16T20:05 dispatch, job endo-sturdyref-press-20260716-200513)

**Headline: HOLDING — 3rd consecutive fully-gated tick since the 16:32Z
re-surfacing. Per the standing plan, the SINGLE consolidated maintainer nudge
was sent this tick (inbox/maintainer 20260716T200737Z-72c74a). No push.**

## State verified this tick (gh, 20:05–20:07Z)

- **#737** (`build/sturdyref-pass-style-ocapn-single`): OPEN, DRAFT, head
  unchanged at `ce7341b47d`. **Zero reviews.** CI on that head:
  `gh pr checks 737 --json state` → `{"SUCCESS":25}` (25/25 green). The two
  decisions (marshal rank-prefix A/`q` vs B/`t` vs C/`w`; stack-collapse
  preference) still sit unanswered in issuecomment-4994276944.
- **#695** (agent provide/accept design): still CHANGES_REQUESTED, head
  `f5df0a4c83`, updatedAt 2026-07-15T05:14Z — awaiting re-review.
- **#697** (cross-peer bridge design): still CHANGES_REQUESTED, head
  `e4a0a614b8`, updatedAt 2026-07-15T05:43Z — awaiting re-review.
- **#541**: OPEN, head `fab626e84a`, updatedAt 2026-07-11; restack/fold-in
  still gated on the collapse answer.
- No kriskowal activity in the repo today:
  `search/issues?q=commenter:kriskowal+updated:>2026-07-16` → total_count 0.
  Last sturdyref-set touch remains 07-15 ~05:40Z (~39h).
- No live sturdyref peer (`inbox-list`: this job, liaison, pr749 shepherd,
  xs2rust, self-heal lanes only; `jobs/doin/` holds only the pr749 shepherd).
  Job inbox empty.

## Action taken: the one nudge

This was the third consecutive fully-gated tick (17:38Z, 18:50Z, 20:05Z), the
threshold set at 18:52Z. Sent ONE message-user nudge summarizing the three
open gates: (1) first review of #737; (2) the prefix pick + collapse answer in
issuecomment-4994276944; (3) re-reviews of #695/#697. Delivered as
inbox/maintainer `20260716T200737Z-72c74a`, reply_to this job base.

## Why no push (unchanged)

Marshal encode/decode arms need the prefix pick; #541/#698–#704 restack needs
the collapse answer; the agent provide/accept build needs the #695 re-review;
opportunistic commits on #737 would dilute its single-squashed-commit review
shape while the first review is pending.

## Confinement statement

No behavior changed this tick, so no confinement surface moved. Standing
invariants as last verified on the green `ce7341b47d` CI run: the swiss-num
secret is never a property on a SturdyRef instance (shape tests incl.
forged/decoy rejections in the green suite); the raw locator stays off-band in
the ocapn session manager's closely-held map. Token unlinkability
(no-identification) remains pending the #695-gated provide/accept build.

## Guidance for the next tick

**The nudge has been sent — do NOT send another.** Hold and watch the same
gates: kriskowal's first review on #737, re-reviews on #695/#697, the prefix
pick, the collapse answer, and any maintainer reply routed to a press-driver
inbox (check your own inbox and the dead-letter path). On the prefix pick:
implement the marshal encode/decode arms + `encodeSturdyRef`/`decodeSturdyRef`
hooks on #737's branch (encode a host-supplied ordinal, never the secret). On
a collapse "yes": fold #541 + #698–#704 into #737; on "no": restack them onto
`build/sturdyref-pass-style-ocapn-single`. If still fully gated after a
substantially longer window (~24h from this nudge, i.e. late 07-17), consider
whether a second, briefer nudge is warranted — not before.
