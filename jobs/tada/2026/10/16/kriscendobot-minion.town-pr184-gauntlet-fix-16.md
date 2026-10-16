**Fix round 16: kriscendobot/minion.town PR #184**

I applied all of the panel-16 must-fix and should-fix items and pushed them as two follow-up commits (`bee6c06..63f7edb`). CI is green: `test` and both `Claude harness` legs pass, and `ci-wait-merge` returned rc 0.

**Must-fix items**
- **decomplector:** The backstop now has its own stack in `deploy/aws/prod-probe-backstop/`, made of `index.mjs`, `provision.sh`, `teardown.sh` and two test files. It owns its role, secret seeding, Lambda, EventBridge rule, resource policy and teardown. I reverted `provision-ci-runner.sh`, `teardown-ci-runner.sh` and the JIT minter (`lambda/index.mjs` and its test) to their pre-PR form, and removed the shared `github.mjs` and the `seed_secret`/`ensure_function`/`package_lambda` helpers. Seeding the probe token no longer runs runner provisioning, and tearing the runner down no longer deletes the probe's clock.
- **migrator:** Reverting the minter resolves this. The visible-ASCII check now applies only to the new probe secret, so the existing `minion/ci-runner-github-token` behaves as before.

**Should-fix items**
- **saboteur / breaker:** `provision.sh --seed-token-stdin` now checks the seed with the Lambda's own `tokenFromSecret`, called through `node`. Multi-document stdin, `nan` and `NaN` are refused before anything is written. The provisioner tests cover these cases, as do the tests for the parser itself.
- **purist:**
  - The GitHub client is now `makeGithubRequest({ fetch })`, with `fetch` passed in, so the tests no longer patch `globalThis.fetch`.
  - The client is called `githubRequest` everywhere.
  - The Lambda reads `SECRET_ID`, the same name the minter uses.
- **pruner:**
  - The seeding instructions now appear only in DEPLOYMENT.md § Dispatch backstop, which also covers the credential, provisioning, checks and teardown. The secrets table has a one-row entry for the probe secret.
  - I deleted the sentences that repeated nearby text, merged the two health-check paragraphs into one, and dropped the `@returns` line from the JSDoc.

**Non-blocking notes**
- DEPLOYMENT.md now says what an Actions: write token can do, including disabling `prod-probe.yml` (the locksmith's note).
- The PR body now states that a manual `workflow_dispatch` run is strict and will alert.
- `test.yml` has separate steps for the minter tests and the backstop tests.

All 30 tests pass locally (minter, backstop Lambda and provisioner). Shellcheck reports only the info-level SC1091 notice about the sourced `common.sh`, which the ci-runner scripts also get.

**Follow-ups:** none for this stage. The driver will post panel-17.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr184-gauntlet-fix-16.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 54 tokens (2700363 cached reads)
- Output: 24267 tokens
- Cost: $1.9548846000000002
- Wall-clock: 1018s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
