---
slug: exo-guard-matches-static-type
category: spec-violation
status: closed
count: 5
members:
  - kriscendobot-agoric-sdk-pr15-review-396a141c
  - kriscendobot-agoric-sdk-pr15-review-63f630f8
  - kriscendobot-agoric-sdk-pr15-review-9a12af5e
  - kriscendobot-agoric-sdk-pr15-review-ccb767b7
  - kriscendobot-agoric-sdk-pr15-review-d6c7561e
prs: [15]
improvement_job: review-improve-exo-guard-matches-static-type
improved_by: 8ec780c5ac: roles/builder/AGENT.md, roles/jurors/spec-keeper/AGENT.md, skills/panel-hints/SKILL.md, skills/panel-hints/probes/C-spec-keeper.sh
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

**Threshold rationale:** Re-closed by the ccb767b7 retro (review 4726535732). This member reopened the
cluster with recurrence=1, but the reopen is a concurrent-backlog-drain artifact,
NOT a genuine post-improvement recurrence. Review 4726535732 was submitted
2026-07-17, three days BEFORE the improvement commit 8ec780c5ac landed
(2026-07-20). It is one more entry in the same pre-improvement PR #15
guard-tightness cascade the cluster already characterizes, queued behind the peer
retro (9a12af5e) that dispatched and closed the improvement. It is not new work
the panel re-missed after the fix, so the recurrence-after-closure maintainer
escalation does NOT apply and none was sent. Re-litigation test re-verified: the
improved skills/panel-hints/probes/C-spec-keeper.sh fires the spec-keeper seat on
a PR #15-shaped diff (an added M.any()/M.record() guard in a portfolio *.exo.ts /
M.interface(...) block), and roles/builder/AGENT.md now carries the
match-known-static-type prevention directive. The cluster's terminal state is
closed; a TRUE recurrence would be a miss on a DIFFERENT PR authored after
8ec780c5ac deploys.

**Threshold rationale:** Re-closed without a second improvement dispatch. This review was submitted before
the existing improvement commit 8ec780c5ac and is a queued member of the same
PR #15 cascade, not evidence that the new prevention or sensing failed. The
existing builder guidance, spec-keeper guard-tightness check, and C-spec-keeper
panel-hints probe re-litigate this member: its additional loose exo
M.interface() argument and return guards match the historical PR #15 diff signal
that the probe fires on. The cluster remains closed after escalation so a later,
post-improvement miss can be assessed as a genuine recurrence.
