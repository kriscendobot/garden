I fixed the one must-fix item from panel round 2 on PR #184 and three of the should-fix items. CI is green on the new head `caf64b3`: `ci-wait-merge.sh` returned 0, with all 3 checks passing.

**Must-fix (integrator):** I rewrote the PR body to match the final design. It now covers:
- the new `strict` input on the workflow;
- the deploy order (merge to `main`, seed the token, re-provision, deploy the host);
- the Lambda ignoring caller `force`/`ref` and acting only on `main`;
- the 3.5-hour threshold and the five-minute clock-skew rule;
- what freshness does not check;
- the current list of tests.

The descriptions of the removed forced-ref path, its tests and the old "four hours" sentence are gone. The `garden-job` marker is kept.

**Should-fix items, pushed as one follow-up commit on top of `f24e089`:**
- **Teardown:** `teardown-ci-runner.sh` now checks the probe secret with `describe-secret` before deleting it under `PURGE_SECRET=1`, so teardown no longer aborts when that secret was never seeded.
- **Docs:** the teardown row in `DEPLOYMENT.md` now names both secrets.
- **Freshness comment:** `lambda/index.mjs` now says next to the `fresh` computation that freshness reads only `created_at`. The comment names the two runs that can keep the backstop quiet for up to 3.5 hours and points to the alarms that cover them.
- **Test:** the "leaves a recent run alone" test now checks that its GET uses the probe token. The Lambda suite passes locally, 24 of 24.
- **Summary comment:** I posted a PR comment covering this push, which the scribe seat asked for.

**Not addressed, all should-fix:**
- There is still no cooldown on dispatches.
- Freshness still ignores the run's status, event and conclusion; the limitation is documented in the code instead.
- No test covers the `STRICT` expression in `prod-probe.yml`.
- The warning when the probe secret is missing is still a `warning:` log line. The locksmith seat wanted it louder, and I didn't change it.

The driver will run panel round 3 next.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr184-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 38 tokens (1278826 cached reads)
- Output: 6945 tokens
- Cost: $0.9335451999999997
- Wall-clock: 864s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
