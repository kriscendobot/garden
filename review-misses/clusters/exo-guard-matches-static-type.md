---
slug: exo-guard-matches-static-type
category: spec-violation
status: improvement-dispatched
count: 3
members:
  - kriscendobot-agoric-sdk-pr15-review-396a141c
  - kriscendobot-agoric-sdk-pr15-review-63f630f8
  - kriscendobot-agoric-sdk-pr15-review-9a12af5e
prs: [15]
improvement_job: review-improve-exo-guard-matches-static-type
---




An exo interface-guard PR reaches the maintainer with loose M.any()/M.record()/M.string() guards on methods whose static type is precisely known, when the repo convention (agoric-sdk CONTRIBUTING § TypedPatterns) is that each guard match its static type as tightly as possible and any remaining looseness be a documented, reasoned exception; the code panel affirms the loose guards as upgrade-safe rather than flagging the under-specification, because no seat carries the guard-tightness-vs-known-type lens.

**Threshold rationale:** Dispatch under the severity bypass. The `exo-guard-matches-static-type` cluster
now holds THREE `severity: major` review-process misses (396a141c argument
guards, 63f630f8 return guards, 9a12af5e a third return guard on
`withdrawHandler.handle`), each grounded in the repo's standing, documented
`CONTRIBUTING` § TypedPatterns convention (each interface guard should match its
known static type as tightly as possible; looseness must be a documented,
reasoned exception). That standing rule already existed and did not bind — the
severity-bypass criterion — and it has now failed to bind three times on the same
PR while a full 16-seat gauntlet returned unanimous approve and affirmatively
praised the loose guards as "compatibility-first / upgrade-safe."

The plain floor's two-PR requirement is not met (all three members are PR #15),
but that requirement exists to stop one messy PR's coincidentally co-located bugs
from masquerading as a systemic pattern. This is the opposite: a single
structural review-lens gap — "no code-panel seat carries the
guard-tightness-vs-known-type lens" — demonstrated repeatedly against a documented
convention, with the maintainer forced to hand-file a cascade of guard-tightening
reviews (4725911405, 4726462863, 4726472818, 4726486961, 4726532241, 4726535732)
one guard at a time. The gap is general to every future exo-interface-guard PR in
agoric-sdk (now in the garden's active experimentation scope), not specific to
#15. Holding for a second PR would leave the panel re-missing the same pattern on
the next exo-guard change. Dispatching one `review-improve-exo-guard-matches-static-type`
builder job.
