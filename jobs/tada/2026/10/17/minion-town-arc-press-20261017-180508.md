No PRs merged since the 15:25Z tick and no issue-58 checklist box changed, but I found a new blocker: CI throughput. I posted one job for it, `minion-town-ci-harness-path-gate`.

**The blocker**
- **The runner isn't stalled, it's overloaded.** There is one self-hosted runner (`ci-minion-town`). It's online and working through jobs one at a time. Every PR push queues two Claude-harness image builds (amd64 and arm64, up to 20 minutes each) plus tests, and nothing limits that to PRs that touch the harness. About 20 jobs are queued and PR CI is taking more than 3 hours.
- **Production validation is lagging too.** The scheduled prod probe passed at 16:20Z (run 39045639323), but its `report` job has been queued since then. While it waits, later probe runs get cancelled or stay pending.
- **The job I posted** asks for the harness builds to run only when harness files change or on pushes to `main`, as skipped jobs so required checks still pass. It may also gate the browser gate the same way and move the probe report off the queue. It must not turn on hosted runners, and must not add AWS instances without a cost note in the PR.

**Triage of the open PRs**
- **#192 and #197:** both are ready for review (no longer drafts) with new heads (`3374bd2`, `962b72c`). Their tests have been queued since 19:40Z, so the screen can't merge them until CI runs. The fix that pins merge jobs to a host that can read CI is on `main2` (`f5477a650ff`).
- **Bearer-token ruling:** the maintainer ruled that a bearer token is fine unless it identifies a person rather than a specific object. #203 writes that test into section 7 of the git-remote design and is in its review gauntlet. The audit of #180 found no identity-like secret that a guest can reach. One point still waits on the maintainer: whether the owner credential counts as object-designating. They've read that question but haven't answered.
- **#178, #180, #181:** nothing posted this tick. #178 is out of review rounds (12/12) and should get a fresh gauntlet once #203 merges, with #180 and #181 after it. The next tick picks that up.
- **#198 to #203:** gauntlets are already running.
- **Merging:** the proxy screen is `active`.

**Issue 58**
- I updated only the header evidence, pointing it at the 16:20Z probe run. No boxes changed and the architecture text is untouched.
- I posted one tick comment: https://github.com/kriscendobot/garden/issues/58#issuecomment-6240678958

No garden `main2` changes this tick.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-arc-press-20261017-180508.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 52 tokens (2038081 cached reads)
- Output: 12968 tokens
- Cost: $1.3421762
- Wall-clock: 171s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
