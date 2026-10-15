---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/review-docket.sh
`scripts/jobs/review-docket.sh:555-589` lets a timed-out spool head consume the entire transaction window, so it repeatedly prevents the later `reenter` transaction from running (2026-10-15T13:49:45Z and 14:13:32Z).
Bound each spool-drain attempt so the requested operation retains a guaranteed transaction budget; defer the failing entry without letting it starve later durable intake.
Add a regression test for a hung first spool entry followed by `reenter`, asserting the reentry is attempted and safely retained if it too cannot complete.
