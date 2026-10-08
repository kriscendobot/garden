I applied all nine must-fix items from the round-1 panel on kriscendobot/minion.town#171, pushed one follow-up commit `ec6c927` to `feat/claude-arc-prod-validation`, and CI is green (`ci-wait-merge` rc 0, 3/3 checks).

**What I fixed:**
1. **AWS credentials and npm (locksmith, migrator):** the workflow now has a separate `harness` job. Only that job holds the deploy role, and it installs nothing: it checks out only the new `deploy/probe/claude-harness.mjs` and `release.json` and runs them with the runner's own Node and AWS CLI. The script uses only Node built-ins. The probe job that runs `npm ci` now has only `contents: read` and receives just the observation JSON as a job output. This goes further than the panel's minimum ("configure credentials after `npm ci`"). The panel's preferred structural fix, a probe-only role limited to a fixed custom SSM document, needs an IAM change, so I left it out. `DEPLOYMENT.md` and the PR body say so.
2. **Running the binary as root before hashing it (wire-watcher, engine-realist):** the on-box program now hashes the binary first. It runs `--version` only when the hash matches the tracked digest, and then as `minion-mcp` under `env -i`, the same way `deploy-app.sh` does.
3. **`DISABLE_UPDATES` check:** it now reads `/proc/<MainPID>/environ` of the running service and uses the last assignment. If the service isn't running, the check fails with a named reason.
4. **Strict probe staying red until #167 lands:** `claude-stdio-mcp-confinement` now declares `awaiting: …/pull/167`. While the credential is missing it reports `deferred`. That is never a pass, but it doesn't turn strict runs red. It still shows in the summary's `deferred` list and as a run notice.
5. **One OIDC/STS failure killing every check:** the credential step is `continue-on-error`. A credential failure, or a harness job that fails outright, now fails only the harness check, with a named reason, and the other 7 checks still run.
6. **Missing expected values counting as a match:** `expectedHarness()` rejects a tracked manifest without a semver version, a 64-hex linux/arm64 digest, or a non-empty fingerprint. Tests cover each missing field.
7. **PR body:** it now says #167 is an open draft with blocking open questions, and notes the deferral and the fix round.
8. **Hard-coded production IDs:** the default instance ID is gone from the source, and the script fails loudly when the variable is unset. The ID and ARN are set once, in the harness job's `env`. The panel asked for repo variables "matching `deploy.yml`", but `deploy.yml` itself uses a literal workflow `env` and the repo has no Actions variables, so I matched that pattern.
9. **Incomplete rename:** the workflow name and the `prod-objectives.mjs` header now say "production objectives".

**Should-fix items I also did:**
- The check now covers the four parent directories (owner and no group/other write bits), uses `lstat` on the files, and keeps leading zeros in modes.
- The confinement check is renamed in the docs as a historical gate.
- The scalar `issue` summary field is dropped; nothing in the repo read it.
- `withSession` now goes through `withBearerSession`.
- `toolPayload` splits on `okJson`'s newline instead of the first `{`.
- All SSM calls share a 240 s budget, and the harness job's timeout is 8 minutes.
- The Buffer→string issue went away with the rewrite.
- `DEPLOYMENT.md`'s CD-role section now names the probe as a user of the role.

**Verification:**
- The probe test suite passes 30/30.
- `actionlint` reports nothing on `prod-probe.yml`.
- I ran the new harness observation against the production box over SSM (read-only). It reported zero violations: version 2.1.283, matching binary and manifest digests, `DISABLE_UPDATES=1` in the running service, both files root-owned with no write bits, and all four parent directories root-owned with no group or other write bits.

**Follow-ups (not posted as jobs):**
- A probe-only IAM role with a fixed custom SSM document, via `deploy-cd-iam.mjs`.
- Remove the confinement check's `awaiting` field once #167 lands, so the check becomes strict.
- Rebase onto #166 before merge (this was already noted in the PR).

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr171-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 68 tokens (3377417 cached reads)
- Output: 36388 tokens
- Cost: $2.3464034000000003
- Wall-clock: 648s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
