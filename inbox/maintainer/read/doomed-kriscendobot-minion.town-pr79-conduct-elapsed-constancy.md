from_host: endolin-garden2-5bcdff64
from: reaper:endolin-garden2-5bcdff64
sent_at: 2026-09-02T20:45:41Z
doom_base: kriscendobot-minion.town-pr79-conduct
doom_signature: elapsed-constancy
notice_count: 1
first_seen: 2026-09-02T20:45:41Z
last_seen: 2026-09-02T20:45:41Z
---
DOOM job PARKED in jobs/plan/ (held, gate=go-ahead) after 2 elapsed-constancy confirmations on endolin-garden2-5bcdff64.
The handler repeatedly failed at a near-constant elapsed below its wall-clock budget.
The first confirmation was requeued; the reaper parked only after the 2-confirmation threshold.
Read the handler log for the fast failure cause. Raising the handler budget will not help.
The work is preserved at jobs/plan/kriscendobot-minion.town-pr79-conduct; it stays HELD until a human promotes it
(promote-plan.sh kriscendobot-minion.town-pr79-conduct) or removes it.
Original job base: kriscendobot-minion.town-pr79-conduct

--- original job body ---
---
role: conductor
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---

# Finalize (curate -> merge) kriscendobot/minion.town PR #79

A trusted maintainer APPROVED this PR (the approval is still effective
even if the head has since advanced) and the approval RECONCILER
confirmed it is OPEN, mergeable, and checks green.
The event-driven comment/review watcher MISSED this approval (it was
down, over a cursor gap, or rate-limited when the review landed); this
periodic backstop caught it. This is the CURATION step: dispatch the
**conductor** to un-draft (if the PR is still draft) and merge. Do NOT
name a merge method — the conductor owns that (roles/conductor/AGENT.md).

Guards (the reconciler already enforced these; re-verify before merging):
  - Bot repo only (kriscendobot/minion.town). NEVER merge agoric-sdk or the endojs/endo
    upstream, and never link to upstream agoric/agoric-sdk.
  - The PR must still be OPEN, mergeable, and checks green, with an
    effective maintainer approval (not dismissed, not superseded by a
    later CHANGES_REQUESTED). If it has regressed (conflicts, red CI,
    approval dismissed), dispatch the shepherd/fixer instead of the merge.
  - Idempotent: if the PR is already merging/merged/closed, do nothing.

PR: https://github.com/kriscendobot/minion.town/pull/79
Head: kriscendobot/minion.town (bot-pushable)
Posted AUTOMATICALLY by the approval reconciler on endolin-garden2-5bcdff64 (no maintainer comment).
