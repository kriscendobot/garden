# Gauntlet fix round 2: kriscendobot/minion.town PR #171

I fixed what the round-2 panel's six request-changes seats asked for and pushed it to the PR head as `ce06e2d`. CI is green on that commit: `ci-wait-merge.sh --no-merge` returned 0, and all three checks passed (test, Claude harness amd64 and arm64). Locally, the 33 probe tests and the typecheck pass. The SSM path is still not verified in production, and the PR stays draft until it has been.

## Fixes by seat
- **curator** (the one must-fix): no file in the repo or its workflows reads `summary.issue`. The summary now keeps `issue` (#58) and adds the `issues` list beside it, so nothing that reads the old field breaks.
  - The deployed layout and the SSM document name now live only in `claude-harness-observe.cjs`. `claude-harness.mjs` and `deploy-cd-iam.mjs` import them from there, and `claude-harness.mjs` no longer re-exports them.
  - I dropped the `clientName` parameter, which no caller set.
- **prover**:
  - `observe()` now takes an optional root directory and command runner, so tests can call it for real instead of matching its source text. They check that a binary with the wrong digest is never run, that a matching one runs as `minion-mcp` under `env -i`, and that real file metadata passes through the verdict code with the right shape.
  - New tests run the harness check itself (pass, fail, skip) and cover each SSM failure path against a stand-in AWS CLI.
- **saboteur**:
  - **Stale document version:** `deploy-cd-iam.mjs` now sets the SSM document's default version to the latest even when the content is already current. Before, a run that died between the two calls left the old version as the default.
  - **Unscoped grant:** the comments, `DEPLOYMENT.md` and the IAM comment now state that `GetCommandInvocation` can read the output of any SSM command in the account.
  - **Directory chain:** the protected directories now run from `/` down, including `/opt`.
  - **Manifest parse errors:** an unreadable manifest now produces a `manifestError` that names the file, instead of the error being silently dropped.
  - **`ssm wait`:** I replaced it, and its catch-all error handler, with a polling loop inside the time budget. The loop retries only the "invocation does not exist yet" error; anything else fails the observation.
- **corner-prober**:
  - Pinned files now fail the check if they carry a setuid, setgid or sticky bit, not just a write bit.
  - A missing path is reported as missing by name instead of crashing the observer.
  - An `error` member of any type now fails the observation, keeping only the first line.
  - New tests cover the instance-id length limits and the boundary cases they listed.
- **archivist**: the AWS/SSM, comparison, provisioning, canary and credential subsections of `DEPLOYMENT.md` are now real headings, and the check table links to them.
- **pruner**:
  - I deleted the paragraph in `DEPLOYMENT.md` that narrated the workflow's job structure.
  - The PR body's "Least privilege" section is cut down to a link plus "Closes #172". The body now also says the SSM path is unit-tested only and not verified live.

## Follow-ups
- To produce live evidence, a maintainer still has to run `node deploy/aws/scripts/deploy-cd-iam.mjs`, create the `prod-probe` GitHub environment so it admits only `main`, and then deploy.
- I did not apply the corner-prober's comment-only point that a deploy finishing mid-observation could make the harness check fail once. It has no retry.
- I did not re-run the panel. The driver posts panel round 3.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr171-gauntlet-20261010-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 70 tokens (3603423 cached reads)
- Output: 30943 tokens
- Cost: $2.3686885999999996
- Wall-clock: 1347s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
