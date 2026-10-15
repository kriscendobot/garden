Fix round 7 for kriscendobot/minion.town PR #184 is pushed and CI is green.

I pushed one follow-up commit, `425a3f5`, to `fix/prod-probe-dispatch-backstop` (fast-forward from `3253475`) using `safe-push-pr-head.sh`.

**Changes, following the panel-7 must-fix items:**
- **Decomplector 1–2:** every `prod-probe.yml` run now passes `--strict`.
  - The `strict` `workflow_dispatch` input and the `STRICT` env expression are removed.
  - The backstop Lambda now dispatches `{ ref: 'main' }` with no inputs, and its test checks that.
  - DEPLOYMENT.md no longer has the HTTP 422 cutover-order steps, the non-strict manual-run sentence, or the `-f strict=true` instruction.
  - Because no run is non-strict any more, a non-strict manual run can no longer count as a recent probe and delay the backstop's strict dispatch.
  - The exit-status comment in `deploy/probe/prod-objectives.mjs` and the probe section of DEPLOYMENT.md now say every run is strict.
- **Pruner 1:** DEPLOYMENT.md now states the one-hour queued-run rule once. The "proves dispatch works, not that the probe executed" clause moved into the offline paragraph. Both repeats in the "Check by hand" paragraph are gone.
- **Pruner 2–3:** these went away with the input: the duplicate non-strict sentence and the comment above the old `STRICT` expression are both deleted.
- **Pruner 4:** this was a proposed rule, so no code change.

**PR updates:** I rewrote the PR body to match. I also posted a summary comment for round 7, because the scribe seat flags a missing summary.

**Tests and CI:**
- The Lambda tests passed locally (29/29), and so did the `prod-objectives` tests.
- `ci-wait-merge.sh --no-merge` returned rc 0 (CI green). It read status through the Actions runs API because the token cannot read `statusCheckRollup`, and found one run, `test (typecheck + vitest)`, which succeeded.

**Follow-up:** manual `gh workflow run prod-probe.yml` runs are now strict as well, so a skipped objective turns them red. The summary artifact still has the diagnostic detail. The maintainer may want to confirm this design choice; the decomplector offered it as one of two options.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr184-gauntlet-fix-7.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 38 tokens (1253302 cached reads)
- Output: 9776 tokens
- Cost: $1.0129244000000002
- Wall-clock: 1144s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
