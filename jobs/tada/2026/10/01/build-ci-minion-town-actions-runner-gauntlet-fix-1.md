## Gauntlet fix round 1: kriscendobot/minion.town PR #145

I fixed every must-fix item from the round-1 panel review and pushed one follow-up commit (`efba4c2`) to the `ci-minion-town-runner` branch, moving it forward from `352719f`. CI is green: all 3 checks passed (`ci-wait-merge` returned rc 0).

**Must-fix items:**
- **stylist (4 items):** Spelled out the abbreviated names:
  - `FUNC`, `FUNC_ROLE`, `FUNC_ARN` and `FUNC_ROLE_ARN` are now `FUNCTION`, `FUNCTION_ROLE`, `FUNCTION_ARN` and `FUNCTION_ROLE_ARN`.
  - `DIST` is now `DISTRIBUTION`.
  - `CONTROLLER_B64` and `UNIT_B64` are now `CONTROLLER_BASE64` and `UNIT_BASE64`.
  - The `tmp` variable in `bootstrap.sh` is now `temporary_dir`.
- **breaker (temp-file cleanup):** Between jobs, the cleanup step (`scrub()`) now empties `/tmp`, `/var/tmp` and `/dev/shm` whatever the files' owner. Before, a job could chown a file to root through docker and it would survive into the next job. Only systemd's private temp directories (`systemd-private-*`) and `snap-private-tmp` are kept. The self-test workflow now plants a root-owned file through docker to check this.
- **wire-watcher (metadata block):** The cleanup step now re-applies the iptables rule that keeps job code off the instance metadata service, before every job. A job could previously flush that rule and leave it off for every later job.
- **corner-prober (no tests for the Lambda that mints runner registrations):**
  - The AWS SDK is now imported only when first used, and a `makeHandler` factory lets tests swap in fake dependencies.
  - Unknown operations and an empty repo name are now refused before the GitHub credential is read.
  - The cleanup of offline runners now reads every page of GitHub's runner list, not just the first 100.
  - A new test file, `lambda/test/index.test.mjs` (6 cases, `node --test`), covers the repo allowlist, operation handling, name cleaning and truncation at 48/49 characters, multi-page cleanup, and the empty case. All 6 pass locally, and a new step in `test.yml` runs them in CI.

**Should-fix items I also took on, since each was small:**
- `provision-ci-runner.sh` now refuses any allowlisted repo that is public (breaker and wire-watcher).
- The runner loop now waits 60 seconds after a failed `cp`/`chown`, so it can't register a new runner about once a second (assessor).
- If the instance ID can't be read, the runner name now gets a random tag instead of the shared literal `host` (corner-prober).
- `DEPLOYMENT.md` uses ASCII `->` arrows and describes the stronger cleanup (typist).

All the shell scripts pass `bash -n` and `shellcheck -S warning`.

**Not done, and follow-ups:**
- I couldn't run the new public-repo check by hand, because GitHub's API rate limit was hit at the time.
- The new controller isn't on the live runner host yet. Someone needs to run `deploy-ci-runner-host.sh` and `provision-ci-runner.sh`, then trigger the "ci-runner selftest" workflow to prove the new cleanup. Both scripts change AWS, so I didn't run them here.
- I left these alone: integrator's suggestion to move the scripts into `deploy/aws/scripts/`, the stylist's comment-only AWS shorthand names (`SG`, `IGW` and similar), breaker's point about checking the controller file for tampering, and the naming mismatch between `minion-town-ci` and `ci-minion-town`.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-ci-minion-town-actions-runner-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 42 tokens (1705339 cached reads)
- Output: 14616 tokens
- Cost: $1.3715158000000003
- Wall-clock: 808s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
