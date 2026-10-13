The panel came back **must-fix** on PR #184 (kriscendobot/minion.town). I posted the verdict on the PR as a comment review, because GitHub won't accept a request-changes review from the bot on its own PR. The review body is still the panel verdict, with must-fix and should-fix sections. Per the job spec, I did not fix anything or un-draft the PR.

- **Checkout:** I made an isolated project checkout of `kriscendobot/minion.town@fix/prod-probe-dispatch-backstop` at head `d8679a4`.
- **Panel run:** I ran `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh` against base `main-bc11010` (`bc11010`). It exited 0 with disposition **must-fix**.
- **Restart:** my first attempt was launched under a 10-minute background limit, so I killed it and restarted it detached. Only the second run produced the verdict.
- **Seats:** 33 seats ran. Five requested changes (stylist, migrator, saboteur, breaker, engine-realist), ten approved and the rest were comment-only.
- **Review:** posted at 2026-10-13T02:57:57Z. The full panel output was about 75 KB, more than GitHub allows in a review body. The posted review is a 22 KB summary with the full findings of the five seats that requested changes, plus assessor.

**Must-fix items:**
1. **Bootstrap aborts:** `bootstrap.sh` runs under `set -euo pipefail`, so if the first backstop smoke-start fails, the whole host bootstrap aborts.
2. **Deploy before merge fails every run:** the Lambda sends a `strict` input that GitHub rejects until the workflow change is on `main`. If the backstop is deployed first, every run fails. The deploy order is not documented.
3. **Provision now hard-fails on existing installs:** re-running provision fails on any install where the probe secret hasn't been seeded yet.
4. **Snap conflict:** the `NoNewPrivileges=yes` setting in `prod-probe-backstop.service` conflicts with the `aws` CLI, which `bootstrap.sh` installs as a snap.
5. **Abbreviated names:** the jq `--arg` names in `provision-ci-runner.sh` and `PROBE_MAXIMUM_AGE_MS` in `index.mjs` need spelling out.

**Should-fix items:**
- **Caller-supplied `force` and `ref`:** the Lambda accepts both from the runner host, which the design treats as hostile. A runner job could dispatch strict runs from any branch.
- **Freshness check scope:** it isn't limited to `main` or scheduled runs, so runs on other branches, or a run stuck in the queue, silence the backstop.
- **Future-dated runs:** a run with a future `created_at` silences the backstop indefinitely, and there is no dedupe window between ticks.
- **Silent Lambda failures:** failures only show up in journald.

**Follow-up:** the next stage is the fixer pass on these must-fix items.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr184-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (1034706 cached reads)
- Output: 5879 tokens
- Cost: $0.9305932
- Wall-clock: 234s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
