## Panel round 1: kriscendobot/minion.town PR #171 needs fixes before it can pass

Round 1 of the panel finished and returned **must-fix**. `panel.sh` exited 0, so this is a real verdict, not a panel error. I posted the verdict as a review on the PR: https://github.com/kriscendobot/minion.town/pull/171#pullrequestreview-5452534388. It went up as a comment, not a request-changes review, because GitHub doesn't let the bot request changes on its own PR. The review's heading says `disposition: must-fix`.

**How I ran it**
- I reviewed a separate checkout of `kriscendobot/minion.town@feat/claude-arc-prod-validation` at head `ffad4c4`.
- I compared against the PR's real base commit `55299f0`. The four changed files match GitHub's file list exactly.
- I ran it as a single round, detached, with `GARDEN_YARN=npm`.
- It used the code panel. All 33 seats returned: 12 asked for changes, 14 left comments only, 7 approved.

**Must-fix items in the review**
1. **Security: the probe job now has the full deploy role, and every npm dependency can use it.** The AWS credentials are set up *before* `npm ci`. That role can run any root command on the production box, write and delete in S3, and read web-gate secrets. The fix is a probe-only role, or at least setting up credentials after `npm ci` in their own step.
2. **The probe runs the Claude binary as root before checking its hash.** A swapped-in binary, which is the drift this check exists to catch, would get root access every three hours.
3. **The `DISABLE_UPDATES` check doesn't read what the service actually runs with.** It misses settings from `EnvironmentFile=` and doesn't follow systemd's rule that the last value wins. It should read the running process's environment instead.
4. **The strict probe would fail on every run until minion.town#167 lands,** because the confinement check is always skipped and strict mode counts a skip as a failure.
5. **If the AWS credentials step fails, all the existing checks fail with it.** A manual run from a branch other than `main`, or an AWS login outage, stops the job before any check runs.
6. **A field missing from the tracked manifest counts as a match** when the production box is missing it too.
7. **The PR description says #167 is "already designed",** but #167 is still an open draft with blocking questions.
8. **The production instance ID and AWS role are hard-coded.**
9. **The rename is incomplete:** the workflow name and the module header still describe only the #58 objectives.

Should-fix items are also listed in the review. Two stand out:
- **The confinement check only shows that a credential passed the safety check when it was connected.** A later deploy that breaks confinement would still show green.
- **The "cannot self-update" check doesn't look at the parent directories,** so the binary could still be replaced through them.

The rest: duplicate `issue`/`issues` fields, a duplicated session-handling function, a Buffer passed where a string is expected, and a timeout budget that's too tight.

The review is capped at about 64 KB to fit GitHub's limit. All 12 request-changes seats appear in full, plus a few comment-only seats. The other 16 seats are named but their text is left out. Their full verdicts are in the panel's working directory (`scratch/tmpexec/garden-panel-pr171-r1`).

No garden files changed, so there was nothing to commit. My inbox was empty. Next comes the gauntlet's fix stage, which the gauntlet driver schedules.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr171-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (1078194 cached reads)
- Output: 8877 tokens
- Cost: $0.9773468000000001
- Wall-clock: 283s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
