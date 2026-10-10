## Fix round 4 for kriscendobot/minion.town#171: CI green

I fixed both must-fix items from the round-4 panel plus three of the should-fixes, and pushed two follow-up commits to `feat/claude-arc-prod-validation` (head `1a3326d` → `d034536`). All 3 CI checks passed (`ci-wait-merge` returned 0). The PR stays draft. I did not re-run the panel; the driver posts panel-5.

**Must-fix items:**
- **stylist:** in `deploy/probe/claude-harness-observe.cjs`, renamed the `args` parameter of `runCommand` to `commandArguments`, and changed its JSDoc to match.
- **migrator (rollout ordering):** `DEPLOYMENT.md` § One-time provisioning already listed the order. I made it harder to miss:
  - The header comment of `prod-probe.yml` now says the strict harness check fails until the provisioning pieces exist, and points to that section. It also says steps 1-3 must be done before merge.
  - Step 4 now explains why the post-deploy run already sees the observer: it fires on the deploy workflow's `completed` event, after the swap. It also says a scheduled run that lands between the merge and the swap fails once.
  - New paragraph for local runs: without `MINION_PROBE_HARNESS_OBSERVATION`, the harness check is skipped, the summary is `incomplete`, and a `--strict` run fails. This was migrator's should-fix 2.

**Should-fixes also done:**
- **saboteur #1:** a new exported `reportedMessage()` in `claude-harness.mjs` sanitizes error text from the box: first line only, mention and markdown characters replaced, capped at 200 characters. Both `observationError()` and `harnessObservation()` in `prod-objectives.mjs` now use it. I added tests for both paths.
- **saboteur #4:** pinned `actions/checkout` to SHA `11d5960…` (v4) in the `harness` job, which holds the AWS role.

**Checks:** `node --test deploy/probe/prod-objectives.test.mjs` passed 35/35, and the vitest artifact test passes.

**Not addressed, left for later rounds or the maintainer:**
- Re-checking the probe environment's "only `main`" policy on every run, not just at provisioning (breaker, saboteur).
- Pinning the observer's own digest in the SSM document (breaker).
- Having the observer report non-regular files and `--version` failures as violations instead of crashing (saboteur #2).
- Gating `gh` use in `deploy-cd-iam.mjs` (migrator #3).
- Renaming `GH` (stylist should-fix).

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr171-screen-ce06e2d3-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (1272827 cached reads)
- Output: 7850 tokens
- Cost: $1.0512614000000002
- Wall-clock: 1273s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
