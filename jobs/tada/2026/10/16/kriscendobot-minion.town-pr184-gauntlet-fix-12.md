Fix round 12 for kriscendobot/minion.town PR #184 is pushed as commit `2f19ca5` on `fix/prod-probe-dispatch-backstop`, and CI is green (`ci-wait-merge` rc=0; one Actions run, nothing failed).

**Pruner (all three applied):**
- Removed "Every run passes --strict." from the `prod-probe.yml` header.
- Removed the `--strict` parenthetical from the header of `deploy/probe/prod-objectives.mjs`.
- Shortened the `provision-ci-runner.sh` header to a pointer at DEPLOYMENT.md § Dispatch backstop.

**Decomplector must-fix (is a second clock needed?):** I kept the backstop and added evidence for it.
- **The evidence:** I pulled the scheduled-run history from the Actions API. From when the workflow was created (2026-10-11 16:36Z) to 2026-10-15 21:22Z, GitHub started only 15 of 34 scheduled prod-probe slots. Every gap between scheduled runs was over 3.5 hours, and the longest was 9.9 hours.
- **DEPLOYMENT.md:** § Dispatch backstop now gives these numbers. It also explains why the workflow keeps its own cron: a fork or an account without the backstop provisioned still probes.
- **PR reply:** I commented on the PR answering each decomplector point. The `github.mjs` split stays because the backstop now uses it too. `--strict` stays on manual dispatch because the workflow can't tell a backstop dispatch from a manual one, so a lenient manual path would make the backstop lenient too.
- **Maintainer:** the juror asked for maintainer confirmation, so I messaged the maintainer with the evidence. The liaison replied that keeping the backstop is provisional and can be reversed; merging and approving the standing credential stay the maintainer's call.

The Lambda tests pass locally (21 of 21) and `provision-ci-runner.sh` passes `bash -n`.

**Follow-ups:**
- If the maintainer decides to drop the backstop and only alert on staleness, a fixer would need to strip it out.
- The bot's GitHub API rate limit was hit briefly during the CI wait. The wait finished anyway.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr184-gauntlet-fix-12.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 46 tokens (1475140 cached reads)
- Output: 10293 tokens
- Cost: $1.0171359999999998
- Wall-clock: 2577s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
