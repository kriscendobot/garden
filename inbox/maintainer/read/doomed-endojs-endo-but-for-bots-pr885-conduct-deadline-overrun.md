from_host: endolin-garden2-5bcdff64
from: reaper:endolin-garden2-5bcdff64
sent_at: 2026-08-06T07:13:06Z
doom_base: endojs-endo-but-for-bots-pr885-conduct
doom_signature: deadline-overrun
notice_count: 1
first_seen: 2026-08-06T07:13:06Z
last_seen: 2026-08-06T07:13:06Z
---
DOOM job PARKED in jobs/plan/ (held, gate=go-ahead) after 1 early-escalation cycle(s) on endolin-garden2-5bcdff64.
The gardener stamped the deadline-overrun counter, so the reaper surfaced it after 1
cycle(s) rather than the full 5-cycle doom threshold. The effective handler budget in
force for this job is 2400s. That counter is stamped for two DISTINCT shapes; check the
gardener log for the actual elapsed to tell which applies:
  (a) GENUINE wall-clock overrun — elapsed ≈ 2400s (rc=124 at the wall). The job does not
      fit one claim: SPLIT it into claim-sized stages, or raise its handler-timeout.
  (b) FAST repeated failure — elapsed far below 2400s (e.g. a 1–2s usage-cap/API rejection)
      flagged by elapsed-constancy. The budget is NOT the problem; read the handler log
      for the real cause (quota/usage cut, swallowed error) — raising the budget will not help.
The work is preserved at jobs/plan/endojs-endo-but-for-bots-pr885-conduct; it stays HELD until a human promotes it
(promote-plan.sh endojs-endo-but-for-bots-pr885-conduct) or removes it.
Original job base: endojs-endo-but-for-bots-pr885-conduct

--- original job body ---
---
role: conductor
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Finalize (curate → merge) endojs/endo-but-for-bots PR #885

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
Approval: https://github.com/endojs/endo-but-for-bots/pull/885#pullrequestreview-4871644069

<!-- garden-deadline-overrun: 1 -->
