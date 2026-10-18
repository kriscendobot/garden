**Viability report: kriscendobot/minion.town PR #206** ("fix(deploy): chunk oversized landing assets")

The PR is open, unmerged and still a draft. Its head is `269a86c7` and its base is `main-cfafabe`, a pinned snapshot at `cfafabea`.

Deciding question: Is `main` still at `cfafabe`, with no newer change that chunks or stages oversized landing assets, and is the continuous deploy still failing on the size gate for `shell.js` that this PR removes?

Evidence:
- Comparing `cfafabe...main` gives `identical` (ahead_by 0). Nothing has landed on `main` since the PR's base, so no newer implementation has replaced it.
- Among the 15 most recent PRs, none other deals with landing-asset chunking. #197 (live clip frame, merged) is the change that made `shell.js` larger. It is the cause of this PR, not a replacement for it.
- The latest `deploy (continuous deployment)` run on `main` at `cfafabea` (2026-10-18 12:14Z) failed with `FATAL: www/shell.js is 76088B base64 — near the single-SSM-document ceiling; chunk it or move to the staging scheme`. That message comes from the 70000-byte gate at `deploy/aws/scripts/deploy-www.sh:53` on `main`, which is the gate this PR replaces with chunked staging. The problem the PR was opened for still exists.
- The PR has no reviews and no human discussion. The only comments are two earlier gauntlet "halted" notes about a floating base. The base is now the pinned `main-cfafabe`, so those notes look out of date.

Both conditions hold: nothing has replaced the PR, and the deploy failure it fixes is still happening on `main`. The gauntlet can begin. I spent no clean, panel, fix, CI-wait or un-draft budget, and changed nothing.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr206-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (202875 cached reads)
- Output: 1681 tokens
- Cost: $0.37961900000000004
- Wall-clock: 36s

<!-- garden-usage-end -->
