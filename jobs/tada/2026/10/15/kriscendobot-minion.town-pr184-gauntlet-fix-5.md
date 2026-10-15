Fix round 5 for kriscendobot/minion.town PR #184: I applied the round-5 panel's must-fix items, pushed them as commit `1f2a33d`, and CI is green (`ci-wait-merge` rc 0).

The round-5 verdict (posted as a comment, head `b52836a`) had two seats requesting changes: the decomplector and the pruner.

**Decomplector: the backstop gets its own module**
- **New Lambda module:** the backstop now lives in `deploy/aws/ci-runner/lambda/prod-probe-backstop.mjs` and ignores its event entirely. The repository comes from the `REPO` setting fixed at deploy time, so DEPLOYMENT.md's "takes no input from its event" is now true.
- **Shared helpers:** the GitHub and Secrets Manager helpers (`tokenFromSecret`, `readTokenFrom`, `makeGithubFetch`) moved to a new `lambda/github.mjs`. That is the only code the two Lambdas share.
- **Minter restored:** `lambda/index.mjs` is back to its base two-op form (`mint`/`prune`), apart from importing the shared helpers. The deploy-time switch (`OPS`, `KNOWN_OPS`, `getProbeToken`) is gone, so which code is deployed now decides which credential a function reads.
- **Provisioner:** `provision-ci-runner.sh` now packages each entry module with `github.mjs` and sets each function's handler (`index.handler` and `prod-probe-backstop.handler`). It also no longer passes the `op` input to the schedule. I checked that the packaged zip loads and exports a handler.
- **Tests:** `test/index.test.mjs` is back to the base minter tests. The backstop tests moved to a new `test/prod-probe-backstop.test.mjs`, which adds a check that every event field is ignored, including `repo`. `.github/workflows/test.yml` runs both files, and all 27 tests pass locally.

**Pruner: cuts only**
- **PR body:** cut from about 441 to 196 words. The test tally and the counting-rule, IAM and credential bullets are gone, replaced by one pointer to DEPLOYMENT.md § Dispatch backstop.
- **DEPLOYMENT.md:** removed the repeated trust-boundary paragraph and the third statement that the host can't invoke the backstop. Also dropped the stale `OPS` and `{"op":…}` wording; the manual invoke example now sends `{}`.
- **Code comments:**
  - The counting rules now live only in DEPLOYMENT.md, and the minter's header no longer describes per-deployment credentials.
  - In `provision-ci-runner.sh`, the probe-token seeding command and the duplicated backstop description are gone, and the name-pattern note is trimmed to three lines.
  - The backstop test file has no fixture-narration comment.

**Follow-ups:** none. The driver re-posts panel-6.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr184-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 46 tokens (2093280 cached reads)
- Output: 19772 tokens
- Cost: $1.74904
- Wall-clock: 1279s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
