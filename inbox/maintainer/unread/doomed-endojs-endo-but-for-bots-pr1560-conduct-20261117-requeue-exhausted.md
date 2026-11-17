from_host: endolin-garden-ece02cb4
from: reaper:endolin-garden-ece02cb4
sent_at: 2026-11-17T08:54:31Z
doom_base: endojs-endo-but-for-bots-pr1560-conduct-20261117
doom_signature: requeue-exhausted
notice_count: 1
first_seen: 2026-11-17T08:54:31Z
last_seen: 2026-11-17T08:54:31Z
---
SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
The work is preserved at jobs/plan/endojs-endo-but-for-bots-pr1560-conduct-20261117; it stays HELD until a human promotes it
(promote-plan.sh endojs-endo-but-for-bots-pr1560-conduct-20261117) or removes it, so nothing is lost.
Original job base: endojs-endo-but-for-bots-pr1560-conduct-20261117

--- original job body ---
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
