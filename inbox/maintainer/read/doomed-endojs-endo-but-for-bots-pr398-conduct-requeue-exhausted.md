from_host: endolin-garden-ece02cb4
from: reaper:endolin-garden-ece02cb4
sent_at: 2026-08-19T07:43:08Z
doom_base: endojs-endo-but-for-bots-pr398-conduct
doom_signature: requeue-exhausted
notice_count: 2
first_seen: 2026-08-19T06:13:10Z
last_seen: 2026-08-19T07:43:08Z
---
DOOM notice — occurrence #2 (first seen 2026-08-19T06:13:10Z, latest 2026-08-19T07:43:08Z).
This job has been doom-parked 2 times for the same condition (requeue-exhausted);
this is an AMENDED notice, not a new one. Latest detail:

DOOM job PARKED in jobs/plan/ (held, gate=go-ahead) after 5 requeue cycles on endolin-garden-ece02cb4.
Its handler appears to fail every time; the reaper stopped requeueing it.
The work is preserved at jobs/plan/endojs-endo-but-for-bots-pr398-conduct; it stays HELD until a human promotes it
(promote-plan.sh endojs-endo-but-for-bots-pr398-conduct) or removes it, so nothing is lost.
Original job base: endojs-endo-but-for-bots-pr398-conduct

--- original job body ---
---
role: conductor
tier: minion
token-budget: 250000
---
<!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-08-19T06:36:23Z cleared=none -->

---
role: conductor
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---

# Finalize (curate → merge) endojs/endo-but-for-bots PR #398

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
Approval: https://github.com/endojs/endo-but-for-bots/pull/398#pullrequestreview-4968635368
