I pushed the round-6 fixes to [kriscendobot/minion.town#154](https://github.com/kriscendobot/minion.town/pull/154) as commit `69b78b9` (head moved from `e461d76`), and CI passed (3/3 checks, none failed).

**Must-fix items (all three applied)**
1. **Node tarball hash check.** A new helper, `resolveNodeTarball` in `deploy/aws/scripts/lib/common.js`, reads both the digest and the filename from the official `SHASUMS256.txt`. `deploy-endo-daemon.js`, `deploy-app.js` and `deploy-npm-registry.js` now all use it and pass `NODE_SHA256` to the remote program. Both `deploy-endo-daemon.remote.txt` and `deploy-app.remote.txt` now run `sha256sum -c` before root extracts the tarball into `/usr/local`. The panel said `deploy-app.js` already checked the hash, but it didn't: it had the same gap, and this fixes it too.
2. **Bad `ENDO_CLAUDE_*` lines now stop the deploy.** `claudeProductionConfiguration` throws `non-canonical ENDO_CLAUDE_* line` for any line that doesn't match `^Environment=ENDO_CLAUDE_[A-Z_]+=[^\s"]*$`. That covers values with spaces, quoted values, lowercase names and leading whitespace; before, such lines were silently dropped.
3. **Validation and hostile-input tests for the root-script builders.**
   - In `provision-guest-reminders.js`, the provision, demo and deprovision programs are now separate exported functions. Each one checks the agent name against `^[a-z0-9][a-z0-9-]{2,47}$` itself, whatever the caller already checked, and the demo program also checks that the period is an integer. The command-line path checks the name the same way for every command.
   - `makeRollbackProgram` now rejects any snapshot name that doesn't match `snapshotNamePattern`.
   - New tests in `test/deploy-script-helpers.test.mjs` cover hostile agent and snapshot names, check the generated scripts with `bash -n`, confirm a hostile stage path stays literal, cover the bad `ENDO_CLAUDE_*` lines and the digest parsing, and check that all three remote templates verify the hash before `tar`.

**Should-fix items done in the same pass**
- Changed the stale `ENDO_COMMIT` mentions to `endoCommit` in `DEPLOYMENT.md` and `.github/workflows/test.yml`.
- `deploy/aws/daemon/README.md` now suggests a `deploy-daemon.js` instead of a `.sh` script.

**Checks run locally**
- `test/deploy-script-helpers.test.mjs` and `test/endo-pin-drift.test.ts` pass, and `tsc` is clean.
- The full vitest run has three failures that exist without this change: two `tools/claude-harness` test files that `npm test` excludes, and one host-environment failure in `test/git-remote/capability.test.ts`.

**Not done (follow-ups)**
- The breaker asked for a PR-body note that the JS `quote(agent)` closes a real injection hole in the old `.sh` script. I haven't edited the PR body.
- The other should-fix items are still open:
  - the reaper "always exits 0" check in `test/endo-pin-drift.test.ts`
  - module comments lost in the converted scripts
  - edge-case and property tests for `sha256File` and `quote()`
  - the slow regex in `remote-template.js`
  - standardizing on one way to fill in remote programs

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-shell-to-js-20261004-part3-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 48 tokens (1884264 cached reads)
- Output: 14040 tokens
- Cost: $1.3596688000000003
- Wall-clock: 497s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
