---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr990-review-8896f456
verdict: not-a-miss
category: new-direction
repo: endojs/endo-but-for-bots
pr: 990
identity: endojs/endo-but-for-bots#990:review:5122822671:retro
comment_url: https://github.com/endojs/endo-but-for-bots/pull/990#pullrequestreview-5122822671
review_at: 2026-09-05T20:10:06Z
producing_role: builder
producing_job: endo-slots-ocapn-deliver-convention
missed_by: none
severity: n/a
---

Dismissal — new direction, not a review miss.

The CHANGES_REQUESTED review (kriskowal, 2026-09-05) states the design invariant
that no OCapN operation may overshadow or be interpreted as a different operation
(a get cannot become a delivery and vice versa; data must round-trip to the same
form), and on that basis asks the bot to **additionally implement** the analogs of
op:get, op:index, and op:untag — surfaced as E.index/E.untag, with get-on-array,
index-on-object, and untag-on-unmatched-tag all failing, and HandledPromise
reflecting the protocol on handlers and static methods.

This is an additive scope/design decision first fully committed in the comment, not
a defect the review process could have anticipated:

- **No gauntlet/panel ran on #990** (a draft PR under the manual-gauntlet-trigger
  regime; `journal/jobs/tada/` holds only the review-feedback and shepherd jobs for
  it, never a gauntlet or panel job), so there was no rubric to have missed this.
- The ask is a **resolution of a previously-identified design fork**. The earlier
  #990 retro (`endojs-endo-but-for-bots-pr990-review-120b6af8`, recorded as a
  dismissal) already noted the maintainer's steer toward separate
  op:get/op:index/op:untag lanes at README.md:110 as "a design fork, unanticipable,"
  which the PR had deliberately and documentedly chosen the other way, and parked it
  as `design-slots-ocapn-op-lanes`. This review is the maintainer picking that fork's
  additive branch — a taste/scope call, not a violated known convention.
- **No standing rule bound.** No seat brief, skill, or COMMON.md norm mandates
  separate operation lanes; the PR's contrary choice was legitimate at authoring
  time, so nothing was "missed."

Primary-genuineness check (per the false-no-op guard): the primary did NOT close as
a no-op. Its claimed deliverables exist in the world — commits 964275b331
(feat(eventual-send): separate OCapN data operations (#990)), 2365da8202, and
617cb4521a are on the PR head (617cb4521a54f1b92ff8c30f18878c47c3d11d15), and CI is
green. No discrepancy to report.

Grounds: not a bug, spec/style violation, missed edge case, or violated known
convention — a first-stated additive protocol-design requirement. No cluster minted;
no threshold evaluation; no review-improve job dispatched.
