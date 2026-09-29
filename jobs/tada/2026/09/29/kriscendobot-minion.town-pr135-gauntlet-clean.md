Clean stage report for kriscendobot/minion.town#135 ("deploy(npm-registry): dark provisioning code for npm.minion.town", still a draft): I added one test file, and CI is green on the new head.

**Starting state:** CI was already green at head `8b9ee5c`, but no coverage pass had been done yet, so I didn't skip the stage. The PR only adds files (9 files, +685/−0): shell deploy scripts, a Caddy fragment, a systemd unit and docs. It changes no existing code, so nothing was left unused and there was no dead code to remove.

**Coverage pass:**
- All five new scripts pass `bash -n` and `shellcheck`. The only shellcheck output is an informational SC1091 note about the `common.sh` source line, which every existing deploy script also triggers.
- The repo already tests deploy scripts with vitest (`test/deploy-render-reconcile.test.ts`), so I added `test/npm-registry-preflight.test.ts`. It runs `npm-registry-preflight.sh` against a temporary directory and checks three cases:
  - an owned state directory with enough free space passes;
  - a missing state directory is refused;
  - free space below the configured minimum is refused.
- Not covered by tests:
  - **The state-directory owner check** would need a directory owned by a different user, which the test run can't create.
  - **`npm-registry-backup.sh`** has to run as root and needs systemctl and the installed release.
  - **The `deploy-npm-registry*.sh` scripts** call AWS.
- Locally, `vitest` passed 3/3 and `npm run typecheck` was clean.

**Push and CI:**
- I pushed commit `e155214` ("test(npm-registry): cover the preflight state-dir and free-space gates") with `safe-push-pr-head.sh`. It was a fast-forward, `8b9ee5c..e155214`.
- `ci-wait-merge.sh --no-merge` returned 0 (green). At head `e155214`, all three checks passed: `test`, `Claude harness (amd64)` and `Claude harness (arm64)`.

**Follow-ups:** None. The PR stays a draft for the next gauntlet stages.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr135-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (816608 cached reads)
- Output: 4778 tokens
- Cost: $0.6770736000000002
- Wall-clock: 384s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
