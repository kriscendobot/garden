from_host: endolin-garden-ece02cb4
from: reaper:endolin-garden-ece02cb4
sent_at: 2026-09-27T15:34:19Z
doom_base: endojs-endo-but-for-bots-pr1345-conduct
doom_signature: requeue-exhausted
notice_count: 1
first_seen: 2026-09-27T15:34:19Z
last_seen: 2026-09-27T15:34:19Z
---
SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
The work is preserved at jobs/plan/endojs-endo-but-for-bots-pr1345-conduct; it stays HELD until a human promotes it
(promote-plan.sh endojs-endo-but-for-bots-pr1345-conduct) or removes it, so nothing is lost.
Original job base: endojs-endo-but-for-bots-pr1345-conduct

--- original job body ---
---
role: conductor
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---

# Finalize (curate -> merge) endojs/endo-but-for-bots PR #1345

A trusted maintainer APPROVED this PR (the approval is still effective
even if the head has since advanced) and the approval RECONCILER
confirmed it is OPEN, mergeable, and checks green.
The event-driven comment/review watcher MISSED this approval (it was
down, over a cursor gap, or rate-limited when the review landed); this
periodic backstop caught it. This is the CURATION step: dispatch the
**conductor** to un-draft (if the PR is still draft) and merge. Do NOT
name a merge method — the conductor owns that (roles/conductor/AGENT.md).

Guards (the reconciler already enforced these; re-verify before merging):
  - Bot repo only (endojs/endo-but-for-bots). NEVER merge agoric-sdk or the endojs/endo
    upstream, and never link to upstream agoric/agoric-sdk.
  - The PR must still be OPEN, mergeable, and checks green, with an
    effective maintainer approval (not dismissed, not superseded by a
    later CHANGES_REQUESTED). If it has regressed (conflicts, red CI,
    approval dismissed), dispatch the shepherd/fixer instead of the merge.
  - Idempotent: if the PR is already merging/merged/closed, do nothing.

PR: https://github.com/endojs/endo-but-for-bots/pull/1345
Head: endojs/endo-but-for-bots (bot-pushable)
Posted AUTOMATICALLY by the approval reconciler on endolin-garden-ece02cb4 (no maintainer comment).
