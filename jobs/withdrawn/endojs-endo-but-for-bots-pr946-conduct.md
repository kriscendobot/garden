---
withdrawn: true
withdrawn_reason: the merge window closed while this sat parked: it was queued to curate an APPROVED, mergeable, checks-green PR on 2026-08-23, but endojs/endo-but-for-bots#946 has since gone CONFLICTING. Replaced by a weave job with a conduct successor blocked on it (2026-09-01 muster)
withdrawn_by: producer
withdrawn_at: 2026-09-01T20:25:19Z
withdrawn_from_gate: go-ahead
---

---
gate: go-ahead
priority: normal
role: conductor
tier: minion
token-budget: 250000
doomed: true
doom_signature: requeue-exhausted
doom_count: 1
requeue_cycles: 5
deadline_overruns: 0
elapsed_constancy_confirmations: 0
doomed_at: 2026-08-23T03:43:16Z
doomed_on: endolin-garden-ece02cb4
posted_by: reaper:endolin-garden-ece02cb4
posted_at: 2026-08-23T03:43:16Z
---

---
role: conductor
tier: minion
token-budget: 250000
---
<!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-08-22T13:58:28Z cleared=none -->

---
role: conductor
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---

# Finalize (curate → merge) endojs/endo-but-for-bots PR #946

A trusted maintainer APPROVED this PR and the watcher confirmed it is
OPEN, mergeable, and checks green. This is the CURATION step: dispatch the
**conductor** to un-draft (if the PR is still draft) and merge. Do NOT name
a merge method — the conductor owns that choice (roles/conductor/AGENT.md).

Guards (the watcher already enforced these; re-verify before merging):
  - Bot repo only (endojs/endo-but-for-bots). NEVER merge agoric-sdk or the endojs/endo
    upstream — those are the maintainers / boatmans call.
  - The PR must still be OPEN, mergeable, and checks green. If it has
    regressed (conflicts, red CI), dispatch the shepherd/fixer instead of
    forcing the merge.
  - Idempotent: if the PR is already merging/merged/closed, do nothing.

Source: pr-review-body by kriskowal
Approval: https://github.com/endojs/endo-but-for-bots/pull/946#pullrequestreview-4941598685
