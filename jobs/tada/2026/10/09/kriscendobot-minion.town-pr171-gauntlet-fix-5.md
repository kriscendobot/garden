## Gauntlet fix round 5: kriscendobot/minion.town PR #171

I pushed one follow-up commit, `3436043` (`fix(probe): observe the harness through a probe-only role and a fixed SSM document`), with `safe-push-pr-head.sh`; it fast-forwarded from `3418e13`. CI on `3436043` is green. The new probe role and SSM document have not been run in production yet, because they need a manual provisioning step (see Follow-ups).

### Panel must-fix items applied (round-5 review)
- **decomplector #1 (no program sent as a string):**
  - I removed `harnessObservationProgram`. The on-box code is now a real file, `deploy/probe/claude-harness-observe.cjs`, and `deploy-app.sh` puts it in the deploy artifact at `/opt/minion-town/share/minion-town/claude-harness-observe.cjs`.
  - The deploy sets that file to `root:root` `0444` along with the release manifest. Root runs it, so a copy `minion-mcp` could write would give the service root.
  - The check also verifies the observer's own owner and mode.
  - `DEPLOYMENT.md` and the PR body now explain why a runtime observer is needed: the deploy-time gate checks the staged tree once, and this probe re-checks the live box between deploys.
- **decomplector #3 (one source for the observation):** `prod-objectives.mjs` now reads the observation only from `MINION_PROBE_HARNESS_OBSERVATION`. The direct-SSM path is gone.
- **decomplector #2 (layout kept in two places), partial:** the observer now owns the deployed layout, and `claude-harness.mjs` imports it. `deploy-app.sh` still keeps its own copy of the paths.
- **locksmith #1 and #2 (dedicated role, fixed document):**
  - `deploy-cd-iam.mjs` now also creates an SSM Command document, `MinionTown-ObserveClaudeHarness`. Its only command runs the observer, and its only parameter is the expected digest, which must match `^[0-9a-f]{64}$`.
  - It also creates a new role, `minion-town-github-probe`, with the same `main`-only trust as the deploy role. Its only grants are `ssm:SendCommand` for that document on the one production instance, plus `ssm:GetCommandInvocation`.
  - `prod-probe.yml` now assumes this role instead of the deploy role, and its sparse checkout includes the observer.
- **locksmith #3:** `PROTECTED_DIRECTORIES` is frozen, and `withBearerSession` is no longer exported.
- **archivist:** I added JSDoc with params and return types to `withBearerSession`, `harnessObservation`, `runProbe` (including the change from `issue` to `issues`), `expectedHarness`, `claudeHarnessViolations` and `observeClaudeHarness`.
- **pruner:** I removed the command checklist from the PR body's Verification section and updated the Summary and Least-privilege sections.
- **Tests:** I replaced the test of the program string with two tests. One checks the observer's source; the other uses a stand-in AWS CLI to assert that only `MinionTown-ObserveClaudeHarness` is sent, with only the digest as a parameter. The probe suite passes 26/26, `npm run typecheck` is clean, and shellcheck reports nothing new.

### CI
`ci-wait-merge.sh` failed on every attempt: this host's bot token can't read PR check status (a known gap). As the host's memory note advises, I read the Actions runs API instead. The only run on `3436043`, `test (typecheck + vitest)`, completed with **success**. I confirmed again on resume that the PR head is still `3436043`.

### Follow-ups
- **Maintainer action needed:** run `node deploy/aws/scripts/deploy-cd-iam.mjs` to create the probe role and SSM document, then deploy so the observer is on the box. Until both happen, the harness check fails by name with "AWS credentials unavailable" and the other checks still run. The PR body says so.
- The new path has no production evidence yet; the earlier production passes used the old transport through the deploy role.
- The PR body says this closes #172, but that won't auto-close it, because the PR's base isn't the default branch.
- My message inbox could not be read: the journal clone was offline.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr171-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s) (1 unmetered)
- Input: 4 tokens (155515 cached reads)
- Output: 1822 tokens
- Cost: $3.5875027999999998 (1 engagement(s) unpriced)
- Wall-clock: 1332s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
