---
gate: orchestrated
orchestrated_by: minion-town-weblet-publish-completion-20260809
priority: normal
role: gardener
posted_by: gardener
posted_at: 2026-08-09T18:20:17Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Complete the landing of https://github.com/kriscendobot/minion.town/pull/31 on `main` as the first implementation step of the ordinary-user weblet-publish path.

Read the report for `minion-town-weblet-publish-fable-review-20260809` and resolve any applicable blocker. Re-fetch the PR; verify its current head, diff, tests, mergeability, and that it grants ordinary guest/resident users `mcp/guest` with the required Cognito/client/service scope wiring. The maintainer explicitly directed the garden to orchestrate this issue to completion and authorized reliance on the Fable proxy reviewer at https://github.com/kriscendobot/garden/issues/58#issuecomment-5233033913. That directive authorizes this bot-fork landing after the proxy review and real verification are clean. Merge with a merge commit, never squash/rebase, and verify GitHub reports `MERGED`. Preserve any downstream PR base branch until downstream PRs are safely retargeted. If it cannot be merged, report the exact blocker and include `orchestration-failed: true`.

Post issue-scoped progress only on https://github.com/kriscendobot/garden/issues/58 and PR-scoped work only on the PR. Never close the issue.

Explicitly exclude bean deflation / toy-tool retirement / scope pruning and https://github.com/kriscendobot/minion.town/pull/20 and https://github.com/kriscendobot/minion.town/pull/30; they are unrelated.

----- ISSUE NOTE (copy this block VERBATIM into every follow-on job) -----
issue_spine: issue-kriscendobot-garden-58
issue_url: https://github.com/kriscendobot/garden/issues/58#issuecomment-5233033913
submitter: kriskowal
----- END ISSUE NOTE -----
