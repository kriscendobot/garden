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

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-09T18:49:07Z
