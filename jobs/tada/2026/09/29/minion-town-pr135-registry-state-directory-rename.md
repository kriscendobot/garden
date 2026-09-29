I renamed every `REGISTRY_STATE_DIR` to `REGISTRY_STATE_DIRECTORY` in kriscendobot/minion.town#135 and pushed it to the PR head. CI passed on the new commit.

**What changed:** one commit, `9a680fb` (`fix(npm-registry): rename REGISTRY_STATE_DIR to REGISTRY_STATE_DIRECTORY`), pushed to `build/npm-minion-town-registry` on top of `661a4ee`. It changes 17 lines across 8 files:
- `deploy/aws/systemd/npm-minion-registry.service`: the `Environment=` line.
- `deploy/aws/npm-registry/npm-registry-backup.sh`: both the default setting and the `runuser … env` call that runs the admin `verify` step.
- `deploy/aws/npm-registry/npm-registry-preflight.sh`
- `deploy/aws/scripts/deploy-npm-registry.sh` and `deploy/aws/scripts/deploy-npm-registry-secret.sh` (the second is a usage comment).
- `deploy/aws/npm-registry/README.md`
- `test/npm-registry-backup.test.ts` and `test/npm-registry-preflight.test.ts`

After the change, a whole-word search of the branch finds no remaining `REGISTRY_STATE_DIR`.

**Checks:**
- **Local:** the two affected test files pass (34 tests).
- **CI on `9a680fb`:** all three checks pass (`test`, `Claude harness (amd64)`, `Claude harness (arm64)`).

**Follow-ups:** none from this job. #135 still needs the Endo side (endojs/endo-but-for-bots#1362, which makes `src/config.js` require the new name) to land. After that, the service will start once the npm.minion.town provisioning is enabled.

## Panel-head freshness

Disposition: **review required**. The last completed panel reviewed `a3ca6fca385e7524a97373dd6cced7f5dd7ade21`; this job presented `9a680fb9b49a04e34f985952070ddd50c80b85dd`. The old panel verdict does not cover the current head. No gauntlet was staged; the maintainer received a deduplicated stale-review action.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-pr135-registry-state-directory-rename.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 16 tokens (370283 cached reads)
- Output: 2187 tokens
- Cost: $0.4511006
- Wall-clock: 339s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
