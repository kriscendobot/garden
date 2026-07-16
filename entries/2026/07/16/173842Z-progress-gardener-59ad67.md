---
kind: progress
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-07-16T17:38:44Z
---
# SturdyRef press tick (2026-07-16T17:35 dispatch, job endo-sturdyref-press-20260716-173508)

**Headline: HOLDING — all critical-path artifacts are maintainer-gated, and the
gates were re-surfaced on #737 only one hour before this tick (16:32Z). No push
this tick; CI on the rename head verified green.**

## State verified this tick (gh, 17:36–17:42Z)

- **#737** (`build/sturdyref-pass-style-ocapn-single`, the single-review
  replacement for closed #521): OPEN, DRAFT, head `ce7341b47d` (the directed
  `sturdyref` → `sturdyRef` rename from last tick). **CI green on that head:**
  `gh pr checks 737` → all listed checks pass (25 pass, 0 fail, 0 pending;
  run 29515959256). **Zero reviews from kriskowal yet.** The two decisions
  (marshal rank-prefix A/`q` vs B/`t` vs C/`w`; stack-collapse preference) sit
  re-surfaced in issuecomment-4994276944.
- **#695** (agent provide/accept design): CHANGES_REQUESTED 07-15 05:00Z,
  addressed same hour — still awaiting re-review.
- **#697** (cross-peer bridge design): CHANGES_REQUESTED 07-15 05:37Z,
  addressed same hour — still awaiting re-review.
- **#541** (+ bridge cuts #698–#704): unchanged since 07-11, still stacked on
  closed #521's old branch `build/sturdyrefs-pass-style-ocapn`; restack vs
  fold-in gated on the collapse answer.
- **#511 / #539**: design drafts unchanged (06-26 / 07-11).
- Maintainer is active elsewhere in the repo (comments through 07-15/16 on
  #714, #676, #669, #621, …) but has not touched the sturdyref set since
  07-15 ~05:40Z (~36h). Not a stall — active repo presence; do not escalate.
- No live sturdyref peer (inbox-list: only this job + liaison + unrelated
  lanes; `jobs/doin/` empty). Job inbox empty.

## Why no push

Every next artifact is behind a maintainer gate: marshal encode/decode arms
need the prefix pick; #541/#698–#704 restack needs the collapse answer; the
agent provide/accept build needs the #695 re-review. #737 was deliberately
shaped as a single squashed commit for holistic review — piling opportunistic
commits onto it while the first review is pending would dilute that shape.
Re-pinging one hour after the last surfacing would be noise.

## Confinement statement

No behavior changed this tick, so no confinement surface moved. Standing
invariants remain as last verified (16:33Z entry): the swiss-num secret is
never a property on a SturdyRef instance (shape tests incl. forged/decoy
rejections were green in the CI run above); the raw locator stays off-band in
the ocapn session manager's closely-held map. Token unlinkability
(no-identification) remains pending the #695-gated provide/accept build.

## Guidance for the next tick

Unchanged from 16:33Z: watch for kriskowal's first review on #737, re-reviews
on #695/#697, the prefix pick, and the collapse answer. On the pick, implement
the marshal encode/decode arms + `encodeSturdyRef`/`decodeSturdyRef` hooks on
#737's branch (encode a host-supplied ordinal, never the secret). On a
collapse "yes", fold #541 + #698–#704 into #737; otherwise restack them onto
`build/sturdyref-pass-style-ocapn-single`. If the sturdyref set is still
untouched after ~3 more gated ticks (~07-16 late/07-17), consider one
message-user nudge summarizing the three open gates.
