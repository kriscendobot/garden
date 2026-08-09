---
role: gardener
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-08-09T18:37:04Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Complete the landing of https://github.com/kriscendobot/minion.town/pull/27 on `main` after https://github.com/kriscendobot/minion.town/pull/31 has merged.

Coordinate with or incorporate the result of the already-active PR 27 rebase/gauntlet job. Rebase onto current `main`, preserve the intended net diff, run the full repository gauntlet and all relevant typecheck/build/tests, address current review feedback, and verify the publish capability, owner isolation, charge-before-intern behavior, shared-store wiring, and fail-closed behavior. Read the Fable proxy review report and resolve any applicable blocker. The maintainer explicitly directed the garden to orchestrate this issue to completion and authorized reliance on the Fable proxy reviewer at https://github.com/kriscendobot/garden/issues/58#issuecomment-5233033913. That directive authorizes this bot-fork landing after review and real verification are clean. Merge with a merge commit, never squash/rebase, and verify GitHub reports `MERGED`. If it cannot be merged, report the exact blocker and include `orchestration-failed: true`.

Post issue-scoped progress only on https://github.com/kriscendobot/garden/issues/58 and PR-scoped work only on the PR. Never close the issue.

Explicitly exclude bean deflation / toy-tool retirement / scope pruning and https://github.com/kriscendobot/minion.town/pull/20 and https://github.com/kriscendobot/minion.town/pull/30; they are unrelated.

----- ISSUE NOTE (copy this block VERBATIM into every follow-on job) -----
issue_spine: issue-kriscendobot-garden-58
issue_url: https://github.com/kriscendobot/garden/issues/58#issuecomment-5233033913
submitter: kriskowal
----- END ISSUE NOTE -----
