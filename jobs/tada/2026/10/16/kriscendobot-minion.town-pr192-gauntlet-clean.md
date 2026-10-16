PR #192 (kriscendobot/minion.town, `fix/node-install-root-ownership`, head `ed06164ac5`) already passed the clean stage, so I changed nothing and pushed nothing.

- **CI:** green at the current head. `ci-wait-merge.sh --no-merge` returned rc 0 (CI GREEN, 1 run, 0 failed). This host's bot token can't read the PR's check summary, so the script fell back to the Actions runs API. That API shows only GitHub Actions runs, not commit statuses or check runs from other services. The one run, "test (typecheck + vitest)", succeeded.
- **Coverage:** already in the PR. The new helper `deploy/aws/scripts/lib/install-node22.sh` has its own test, `test/install-node22.test.ts`. It covers a fresh install, an existing v22 install where ownership is reset, a checksum mismatch where nothing is unpacked, and checks that all three deploy scripts use the helper. The paths it doesn't test are the error returns when `curl` or `chown` fail, which are simple one-line returns. I added nothing.
- **Dead code:** none. The PR fully removes the copied install blocks from `deploy-app.sh`, `deploy-endo-daemon.sh` and `deploy-npm-registry.sh` and replaces them with calls to the helper, so nothing is left unused.
- **Follow-ups:** none from this stage. The PR is still a draft. The rest of the gauntlet (panel review, fix-loop, un-draft) belongs to the driver. The PR's "step 2" is blocked on #171 and already has its own parked job.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr192-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (203783 cached reads)
- Output: 1696 tokens
- Cost: $0.3911886
- Wall-clock: 46s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
