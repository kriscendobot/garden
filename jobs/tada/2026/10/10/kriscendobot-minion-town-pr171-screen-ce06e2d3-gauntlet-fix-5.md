All three round-5 must-fix items on kriscendobot/minion.town#171 are dealt with. The two new commits are pushed (head is now `ad561a0`) and CI is green: `ci-wait-merge` returned rc 0 with 3 of 3 checks passing and none failed.

**Must-fix items**
- **prover (the probe's security setup had no tests):** I moved the pure builders out of `deploy-cd-iam.mjs` into a new `deploy/aws/scripts/cd-iam-documents.mjs`: the trust policy, probe subject, observe document, probe policy, and `assertProbeEnvironmentAdmitsOnly`, which now takes an injected `ghJson`. The provisioner imports them and writes the same JSON as before. The new `cd-iam-documents.test.mjs` (6 tests) checks:
  - the probe and deploy trusts accept different subjects, and neither contains a wildcard;
  - the observe document only accepts a 64-character hex digest and only runs the shipped observer at its fixed path;
  - the probe policy can start only the observe document, only on the one instance;
  - the environment guard throws for a `*` branch, a second branch, a tag, no listed branch, protected branches, no policy at all, or an unreadable environment.
  
  To check the tests actually catch regressions, I loosened the digest pattern and the guard in place; both tests failed, and passed again once I restored the code. I added the suite as a step in `test.yml`.
- **decomplector (justify pulling through SSM, which needs the unscopable `ssm:GetCommandInvocation`):** I added the justification to `DEPLOYMENT.md` § AWS/SSM, with a pointer in the `deploy-cd-iam.mjs` header:
  - A check at deploy time only sees the moment of install, not changes made between deploys.
  - A push from the box would have to go through an app-served path or S3 via the instance role. The `minion-mcp` service user can write the first and reach the second through the metadata service, so the thing being watched could fake its own green result.
  - SSM output goes from the root SSM agent straight to the SSM API, which the service user cannot write to.
- **integrator (the ledger must not claim `deliverable`):** nothing to change. The PR body's ledger already says `Disposition: orchestrated-slice` with a named `Successor:`, and the PR is still draft. The integrator said this case makes the item comment-only.

**Should-fix items also covered**
- **Workflow wiring (prover):** a test now checks that `prod-probe.yml` matches the provisioner's values (account/role ARN, instance, region, environment) and that the observation is passed from the harness job to `MINION_PROBE_HARNESS_OBSERVATION`.
- **Observer permissions (prover):** `test/deploy-app-artifact.test.ts` now checks that the observer is in `deploy-app.sh`'s `chown root:root` and `chmod 0444` lists.

**Local checks run:** the new suite (6/6), `node --test deploy/probe/prod-objectives.test.mjs` (35/35), `npx vitest run test/deploy-app-artifact.test.ts` (3/3) and `npm run typecheck` all pass. actionlint isn't installed on this host, so I didn't run it.

**Left for later:** the commit-history regrouping the integrator asked for (it needs a history rewrite, so it belongs in a retcon rather than a fix round). Also the saboteur's remaining should-fix items: the observer crashing on lstat errors other than "file not found", the issue sanitizer still allowing `:` and `/` (which lets text become autolinks), and the "admits only `main`" guarantee being checked only at provisioning time.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr171-screen-ce06e2d3-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 38 tokens (1488874 cached reads)
- Output: 15116 tokens
- Cost: $1.3051508000000003
- Wall-clock: 916s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
