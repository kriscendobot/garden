I built part 3 of the shell-to-JS migration and opened it as draft PR https://github.com/kriscendobot/minion.town/pull/154. It stacks on #153 (merge order #151 → #152 → #153 → #154). Nothing ran against the live box; the first real run will be CD on merge.

**What changed**
- **Scripts converted:** the last 7 shell scripts in `deploy/aws/scripts/` are now Node ESM. They are `deploy-app`, `deploy-endo-daemon`, `rollback-endo-daemon`, `endo-root-host`, `deploy-npm-registry`, `deploy-siwe-thunk` and `provision-guest-reminders`. The `.sh` files and `common.sh` are deleted, and none of the new scripts uses python3.
- **CD workflow:** `deploy.yml` now runs the three CD steps (endo-daemon, app, npm-registry) with `node …js` instead of `bash …sh`.
- **Endo pin:** it now lives in `deploy-endo-daemon.js` as `export const ENDO_COMMIT = "<40hex>";`. Everything that reads the pin was updated to the new file and line shape: the vendor tool and `PROVENANCE.json`, the pin-drift and vendor tests, and the federation script.
- **Allowlist:** it now holds only the three box-side shell files. Docs and comments name the `.js` scripts.
- **Tests:** three new behavioural test files cover the new scripts.

**Verification**
- **Comparison method:** each original `.sh` and its `.js` replacement ran against the same fake `aws` command, which records every call. Across 30+ runs covering every subcommand and error branch, the programs sent to the box were byte-identical, as were the AWS call sequences and the `deploy-app` tarball checksum.
- **Deliberate differences:** box-side hints that named deleted `.sh` files now say `.js`.
- **Two bash bugs fixed:** in each script, a comment inside an unquoted heredoc contained backticks, so bash ran the quoted command on the deploy host. In `deploy-endo-daemon.sh` that was `systemctl restart`; in `deploy-app.sh` it was `env -i`. The JS sends the comments as written and runs nothing on the host.
- **Checks:** the script-policy check and `tsc --noEmit` pass. Full vitest: 871 passed, 1 failed. The failure is `test/git-remote/capability.test.ts` "propagates a git failure", which also fails on #152 and #153 and is untouched here. The run also reports "no test suite found" for the two `tools/claude-harness` test files, which `npm test` excludes.

**Follow-ups**
- The three box-side shell files still on the allowlist could be a part 4.
- eslint and prettier weren't run because they aren't installed in the checkout.
- The gauntlet for #154 should run after #153's.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fu-minion-town-shell-to-js-20261004-part2-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 42 tokens (1663419 cached reads)
- Output: 16015 tokens
- Cost: $7.8549106
- Wall-clock: 763s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
