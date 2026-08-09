---
gate: orchestrated
orchestrated_by: minion-town-weblet-publish-completion-20260809
priority: normal
role: gardener
posted_by: gardener
posted_at: 2026-08-09T18:20:38Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Land the ordinary-user powers-reference implementation produced by `minion-town-weblet-powers-reference-build-20260809`.

Read that job's report and locate the PR by its fixed head branch `feat/weblet-user-powers-reference`. Re-fetch and review the actual current diff; run all relevant tests and security/capability-isolation checks. Resolve review or CI blockers within scope. The maintainer explicitly directed the garden to orchestrate this issue to completion and authorized reliance on proxy review at https://github.com/kriscendobot/garden/issues/58#issuecomment-5233033913. This bot-fork merge is authorized once the implementation and verification are clean. Merge with a merge commit, never squash/rebase, and verify GitHub reports `MERGED`. If it cannot be merged, report the exact blocker and include `orchestration-failed: true`.

Post issue-scoped progress only on https://github.com/kriscendobot/garden/issues/58 and PR-scoped work only on the PR. Never close the issue.

Explicitly exclude bean deflation / toy-tool retirement / scope pruning and https://github.com/kriscendobot/minion.town/pull/20 and https://github.com/kriscendobot/minion.town/pull/30; they are unrelated.

----- ISSUE NOTE (copy this block VERBATIM into every follow-on job) -----
issue_spine: issue-kriscendobot-garden-58
issue_url: https://github.com/kriscendobot/garden/issues/58#issuecomment-5233033913
submitter: kriskowal
----- END ISSUE NOTE -----
