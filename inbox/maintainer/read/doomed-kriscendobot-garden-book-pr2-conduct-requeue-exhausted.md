from_host: endolin-garden-ece02cb4
from: reaper:endolin-garden-ece02cb4
sent_at: 2026-10-03T05:14:07Z
doom_base: kriscendobot-garden-book-pr2-conduct
doom_signature: requeue-exhausted
notice_count: 1
first_seen: 2026-10-03T05:14:07Z
last_seen: 2026-10-03T05:14:07Z
---
SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
The work is preserved at jobs/plan/kriscendobot-garden-book-pr2-conduct; it stays HELD until a human promotes it
(promote-plan.sh kriscendobot-garden-book-pr2-conduct) or removes it, so nothing is lost.
Original job base: kriscendobot-garden-book-pr2-conduct

--- original job body ---
---
role: conductor
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---

# Finalize (curate -> merge) kriscendobot/garden-book PR #2

A trusted maintainer APPROVED this PR (the approval is still effective
even if the head has since advanced) and the approval RECONCILER
confirmed it is OPEN, mergeable, and checks green.
The event-driven comment/review watcher MISSED this approval (it was
down, over a cursor gap, or rate-limited when the review landed); this
periodic backstop caught it. This is the CURATION step: dispatch the
**conductor** to un-draft (if the PR is still draft) and merge. Do NOT
name a merge method — the conductor owns that (roles/conductor/AGENT.md).

Guards (the reconciler already enforced these; re-verify before merging):
  - Bot repo only (kriscendobot/garden-book). NEVER merge agoric-sdk or the endojs/endo
    upstream, and never link to upstream agoric/agoric-sdk.
  - The PR must still be OPEN, mergeable, and checks green, with an
    effective maintainer approval (not dismissed, not superseded by a
    later CHANGES_REQUESTED). If it has regressed (conflicts, red CI,
    approval dismissed), dispatch the shepherd/fixer instead of the merge.
  - Idempotent: if the PR is already merging/merged/closed, do nothing.

PR: https://github.com/kriscendobot/garden-book/pull/2
Head: kriscendobot/garden-book (bot-pushable)
Posted AUTOMATICALLY by the approval reconciler on endolin-garden-ece02cb4 (no maintainer comment).
