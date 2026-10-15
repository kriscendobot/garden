I applied the round-8 panel's must-fix items on kriscendobot/minion.town#184, pushed them as one follow-up commit (head moved from `425a3f5` to `111051f`), and CI finished green. The two Lambda test files pass 33 of 33 locally.

**Changes:**
- **Probe evidence (archivist, saboteur, breaker):** a finished run now holds off a dispatch only if its `probe` job's `Probe production` step ended `success` or `failure`. The Lambda reads this from the run's jobs. Before this, a run that failed during checkout, setup or `npm ci` also ended `failure` and was wrongly counted as having probed.
  - Runs older than the 3.5-hour window are not inspected, because they trigger a dispatch either way.
  - A comment on the workflow step says the backstop reads its name. If the job or step is renamed, the backstop will dispatch on every check until the Lambda is updated.
- **Waiting statuses (wire-watcher):** only `queued`, `waiting`, `requested` and `pending` count as a run still waiting for a runner. A missing, null or unknown status no longer suppresses a dispatch.
- **Docs claim (benchmarker):** `DEPLOYMENT.md` now calls the "about once an hour" figure a bound that follows from the queue rule, not a measured rate. It also documents the probe-step and status rules.
- **Smaller items:**
  - Renamed `makeGithubFetch` to `makeGitHubFetch` and updated `index.mjs` (stylist).
  - Gave the returned functions names (spec-keeper).
  - Removed the restating JSDoc and the test-file header comment (pruner).
- **Tests:**
  - Exact edges: a run dated exactly five minutes ahead, and runs queued or waiting exactly one hour (corner-prober).
  - Probe-step cases, the new status cases, and malformed jobs responses or run ids.
  - A fast-check property comparing the handler with a separate model of the rules, over up to 100 ordered runs, 500 runs (fast-checker). I changed one comparison from `<` to `<=` as a check, and the property caught it.

**Not taken (reasons are in the commit message):**
- **decomplector** asked to replace the freshness check with an unconditional scheduled dispatch. I declined: its round-7 review called this mechanism justified, and the check is what lets the 3-hourly scheduled runs and post-deploy runs count, instead of adding extra production probes. If the maintainer wants the unconditional design, or wants the backstop provisioned separately from the CI runner, that should be a separate job.
- **integrator** asked (should-fix) to squash the ten-commit history. I left that for merge time so the panel rounds stay reviewable.
- **coverage-auditor** couldn't check new-line coverage because there is no coverage report. That needs no change to the PR.

The bot's token can't read the PR's combined check status, so the CI wait used the Actions runs API, which covers only Actions runs. The one run on `111051f` passed.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr184-gauntlet-fix-8.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 44 tokens (1652778 cached reads)
- Output: 20518 tokens
- Cost: $1.4158675999999997
- Wall-clock: 1826s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
