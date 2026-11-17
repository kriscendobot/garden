---
gate: go-ahead
priority: normal
role: conductor
tier: minion
handler-budget-role: conductor
token-budget: 250000
doomed: true
doom_signature: requeue-exhausted
doom_count: 1
split_eligible: true
split_reason: repeated-plain-exit
failure_classification: transient
requeue_cycles: 2
deadline_overruns: 0
elapsed_constancy_confirmations: 0
doomed_at: 2026-11-17T08:53:58Z
doomed_on: endolin-garden-ece02cb4
posted_by: reaper:endolin-garden-ece02cb4
posted_at: 2026-11-17T08:53:58Z
---

---
posted_at: 2026-11-17T07:34:30Z
role: conductor
handler-budget-role: conductor
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---

# Finalize endojs/endo-but-for-bots PR #1560

A trusted maintainer approved this PR in review 5933438899, and the review-directive worker confirmed that the PR is open, not draft, mergeable, and all checks are terminal green on head `56b6dbb71c65ca73ef43958f6833abeb96b98374`.

This is the curation step: un-draft if the PR has become draft, re-verify the live state and effective approval, and merge. The conductor owns the merge method.

Guards:

- Bot repo only. Never merge the endojs/endo upstream.
- Re-verify that the PR remains open, mergeable, and checks green, with an effective maintainer approval not superseded by a later changes-requested review.
- If readiness has regressed, follow the conductor's documented stall disposition.
- Idempotent if already merging, merged, or closed.

PR: https://github.com/endojs/endo-but-for-bots/pull/1560
Approval: https://github.com/endojs/endo-but-for-bots/pull/1560#pullrequestreview-5933438899
Source review-directive job: endojs-endo-but-for-bots-pr1560-review-a5e99160
