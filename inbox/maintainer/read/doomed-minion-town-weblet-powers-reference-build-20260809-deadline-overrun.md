from_host: endolin-garden2-5bcdff64
from: reaper:endolin-garden2-5bcdff64
sent_at: 2026-08-09T21:43:09Z
doom_base: minion-town-weblet-powers-reference-build-20260809
doom_signature: deadline-overrun
notice_count: 1
first_seen: 2026-08-09T21:43:09Z
last_seen: 2026-08-09T21:43:09Z
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
The work is preserved at jobs/plan/minion-town-weblet-powers-reference-build-20260809; it stays HELD until a human promotes it
(promote-plan.sh minion-town-weblet-powers-reference-build-20260809) or removes it.
Original job base: minion-town-weblet-powers-reference-build-20260809

--- original job body ---
---
role: builder
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-08-09T18:49:03Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Implement the missing ordinary-user powers-formula creation/discovery path required to verify weblet powers end to end in kriscendobot/minion.town.

Start from current `main` after https://github.com/kriscendobot/minion.town/pull/31 and https://github.com/kriscendobot/minion.town/pull/27 have merged. Use the isolated project worktree helper for this job. Design the narrowest capability-safe user surface that lets an ordinary OAuth-provisioned guest create or discover a powers formula reference they are authorized to pass to `weblet_publish`; do not expose arbitrary daemon lookup or another user's references. Add negative capability-isolation tests and an end-to-end local publish/powers bootstrap test. Use fixed head branch `feat/weblet-user-powers-reference`, open a bot-fork PR against `main`, and run the full build gauntlet through a clean ready-for-landing state. Report the PR URL and exact verification evidence. If the capability cannot be safely completed, report the blocker and include `orchestration-failed: true`.

Post issue-scoped progress only on https://github.com/kriscendobot/garden/issues/58 and PR-scoped work only on the created PR. Never close the issue.

Explicitly exclude bean deflation / toy-tool retirement / scope pruning and https://github.com/kriscendobot/minion.town/pull/20 and https://github.com/kriscendobot/minion.town/pull/30; they are unrelated.

----- ISSUE NOTE (copy this block VERBATIM into every follow-on job) -----
issue_spine: issue-kriscendobot-garden-58
issue_url: https://github.com/kriscendobot/garden/issues/58#issuecomment-5233033913
submitter: kriskowal
----- END ISSUE NOTE -----


<!-- garden-deadline-overrun: 1 -->
