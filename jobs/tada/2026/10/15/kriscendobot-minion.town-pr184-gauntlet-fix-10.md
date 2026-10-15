# Gauntlet fix round 10 for kriscendobot/minion.town PR #184: fix pushed, CI green

I applied the round-10 panel's request-changes items to the PR head `fix/prod-probe-dispatch-backstop` in one follow-up commit, `163b80e`. `ci-wait-merge.sh --no-merge` exited 0 (CI green). The 44 Lambda tests also pass locally.

**What changed:**
- **Dispatch storm (saboteur #1, breaker #1):** before, a probe run that failed before its `Probe production` step was ignored, so the backstop dispatched again on every 5-minute check. Now any `workflow_dispatch` run from the last hour holds off the next dispatch, whatever its outcome. In that case the handler returns a new result, `action: 'cooling-down'`.
  - A new test fails every dispatched run in setup and runs 3 hours of checks. It expects exactly 3 dispatches, where the old code would have made 36.
  - Another new test covers the edges: exactly one hour old, a run dated in the future, and different conclusions.
  - The randomized model test now knows about the cooldown.
- **Lambda timeout (saboteur #2, breaker #3):** `ensure_function` now takes the timeout as an argument. The backstop gets 90 seconds; the minter keeps 30.
- **Probe target (saboteur #3):** the backstop now reads its own `PROBE_REPO` setting instead of the first entry in `REPOS`.
- **Decomplector's must-fix:** DEPLOYMENT.md § Dispatch backstop now says in one sentence why the backstop checks first instead of dispatching on a fixed schedule. Every probe run logs in to production, takes a runner, and comments on the tracking issue when it fails. Dispatching on a schedule as well as GitHub's cron and post-deploy runs would double that load and noise even when GitHub's schedule is working. The handler's doc comment now says "keeps no local state".
- **Pruner's trims:**
  - Removed from the test file: the repeated job/step-name comment.
  - Removed from the handler's doc comment: the paragraphs that repeated DEPLOYMENT.md, replaced with a pointer to it.
  - Removed from the provisioner header: the duplicate "until it is seeded" line.
  - Removed from DEPLOYMENT.md: the duplicate sentences about seeding and the name-pattern grant, and the "GitHub's cron is a useful first trigger, but it is not the clock" sentence. The serialization paragraph is shorter and now states the once-an-hour limit, including the cooldown.

**Not done:** two should-fix findings are left as they are:
- breaker #2: a run stalled before the probe step counts as evidence until its 10-minute job timeout.
- decomplector #2: the workflow could record its own outcome instead of the backstop reading job and step names.

No follow-ups were posted. The driver re-posts panel-11.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr184-gauntlet-fix-10.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 48 tokens (1967863 cached reads)
- Output: 14149 tokens
- Cost: $1.4612165999999998
- Wall-clock: 1534s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
