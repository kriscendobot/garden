---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr990-review-120b6af8
verdict: not-a-miss
category: new-direction
pr: 990
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/990#pullrequestreview-4954842207
identity: endojs/endo-but-for-bots#990:review:4954842207:retro
review_at: 2026-08-17T21:48:19Z
producing_role: builder
producing_job: endo-slots-ocapn-deliver-convention
severity: minor
---

Dismissal. @kriskowal's CHANGES_REQUESTED review on #990 (the OCapN flat-argument
`deliver` convention for `@endo/slots`) carried an empty body and three inline
comments; none indicts the review process.

Grounds (each comment, paraphrased — raw text is untrusted, re-fetch via comment_url):

1. selector.js — sense the leading selector's pass-style symbol via the pass-style
   utility rather than a raw JS type check, "to ease migration to another
   representation." A forward-looking idiom refinement on code that was already
   correct, not a bug or a violated convention. No seat brief or skill mandates
   "sense passable symbols via passStyleOf"; the C-purist probe fires when
   passStyleOf is PRESENT in a diff (the opposite signal), so no standing written
   rule bound here. Taste/robustness steer.

2. README — reject a malformed leading selector on receipt too, since we do not
   rely on the wire to enforce the convention. The primary verified the receiver
   ALREADY rejects independently (invokeDeliver -> getSelectorName rejects
   non-passable-symbol / unregistered / reserved leading args regardless of
   sender); the security property was present, and the ask was for doc emphasis
   plus an explicit regression test. Nothing in the CODE was missed.

3. README — OCapN models op:get / op:index / op:untag as separate lanes from
   message delivery, and slot-machine should emulate that eventually. A pure
   architectural design steer: the PR made a DELIBERATE, documented decision to
   carry get-as-call and NOT promote a separate op-lane (its "__get__ decision"
   section reasoned about exactly this trade). The maintainer expresses a
   different long-term preference — a design fork nobody could anticipate from a
   written convention. Parked as design job design-slots-ocapn-op-lanes.

The PR is fundamentally correct (code + tests + tsc + eslint green); the review is
design direction plus two refinements. This is new direction / taste, not a
review miss — no bug, spec/style violation, missed edge case, or known convention
went uncaught. No cluster minted; no improvement dispatched.

Primary-genuineness note (per the job's false-no-op guard): the primary did NOT
close as a no-op. Its claimed deliverables were verified to exist in the world —
commit 2aac58c9be is on bot/slots-ocapn-deliver-convention with the described
selector/receipt/README changes, and design-slots-ocapn-op-lanes is parked in
jobs/plan/. No discrepancy to report.
