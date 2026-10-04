Fix round 4 for kriscendobot/minion.town#151 is done. I fixed all four must-fix items from the panel-4 review, pushed five follow-up commits (head moved from `29c7541` to `b74c55e`), and CI came back green on all 3 checks (`ci-wait-merge` returned 0).

**Must-fix items:**
1. **Paths read as URLs (`ff23336`).** In `tools/check-javascript-only-scripts.js`, `readFirstLine` now builds the path with `path.join(fileURLToPath(root), file)` instead of `new URL(file, root)`. New test rows for `run#x`, `run?x` and `100%zz` check both `readFirstLine` and `checkRepository`. I put the old code back temporarily and all three rows failed.
2. **Preflight relied on Node's syntax detection (`383d20f`).** The source file is now `npm-registry-preflight.mjs`, and the deploy installs it as `/usr/local/lib/npm-minion-registry/preflight.mjs`. I updated the systemd unit, the README and the test to match. After the new unit is loaded, the deploy deletes the old `preflight.js` and `preflight.sh`. A new test copies the script alone into a temporary directory and runs it with syntax detection turned off. I checked that the same file saved as `.js` fails there.
3. **Writability check had no test (`724144e`).** I moved the check into an exported `isWritable(file, access, mode)` with a stand-in `access` for testing. The in-container program now uses that function's source code. Tests cover EACCES, EPERM and EROFS (treated as read-only) and ENOENT and EIO (rethrown). I confirmed the generated program still parses.
4. **Duplicated AWS settings (`c85dc32`).** `deploy-cd-iam.mjs` now imports the AWS binary path, region, account, instance, bucket and `log` from `lib/common.js` instead of repeating them.

**Should-fix items also done (`b74c55e`):**
- `gen-allowed-emails.js` lowercases ASCII letters only, with a test for the Kelvin sign and `İ`.
- `vendor-endo-claude.js` uses `replaceAll` and fails if the old import specifier is still there.

**Testing:** The four affected test files pass (71 tests). Locally the full `npm test` run had one failure, in `test/git-remote/capability.test.ts` ("propagates a git failure"). Nothing I changed touches that code, and it passed in CI, so it looks like a quirk of this machine. I didn't confirm that by running it on the old head.

**Still open:**
- Should-fix items:
  - Symlink-safe main-module guard.
  - Reject `env -u` shebangs.
  - Validate `ROUTE53_MODULE_VERSION`.
  - Use the URL form for `repositoryRoot` everywhere.
  - Test that importing `vendor-endo-claude.js` has no side effects.
  - Regroup the commits and refresh the PR description.
  - Restore the dropped header comments.
  - Post a completion-summary comment.
- The comment-only notes.

The panel-5 stage will see all of these.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-shell-to-js-20261004-part1-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 54 tokens (2026097 cached reads)
- Output: 15423 tokens
- Cost: $1.3874554
- Wall-clock: 468s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
