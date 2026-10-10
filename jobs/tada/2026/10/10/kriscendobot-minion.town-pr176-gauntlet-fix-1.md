Round-1 fix for PR #176 is pushed and CI is green. I applied both must-fix items from the panel and pushed one follow-up commit, `adacedd`, on top of `8530b82`.

**CI:** the only workflow, `test (typecheck + vitest)`, passed on `adacedd` ([run](https://github.com/kriscendobot/minion.town/actions/runs/38083592423)). `ci-wait-merge.sh` never returned a result: this host's bot token gets a 403 on the PR's check status and check-runs. It ran past the 10-minute command limit and printed nothing, so I read the result from the Actions runs API instead, which shows one run on that commit, completed with success.

**Must-fix items applied:**
- **Stylist (naming):**
  - `git-remote-partition.sh`: the `jq --arg a` and `--arg h` arguments are now `attenuation` and `tokenHash`, the `r` locals are `record`, and `*_B64` is `*_BASE64`. The `desc` locals (also in `common.sh`) are now `description`, the `out()` helper is `emit()`, and the `*_RE` names are `*_PATTERN`.
  - `test/git-remote-partition-script.test.ts`: `SCRIPT`/`COMMON` are now `PARTITION_SCRIPT_PATH`/`COMMON_SCRIPT_PATH`, `helper(call, remote)` is `runCommonShell(shellCommand, reply)`, and the `makeFakeAws` parameter `remote` is now `reply`.
- **Pruner (prose):**
  - The DEPLOYMENT.md Phase 13 cell is cut down to status, date and artifact.
  - The PR body's step-by-step Outcome list is now one sentence. The body is 175 words (the limit is 300), and no bullet starts with a code span.

**Should-fix items I also did:**
- **`mint` can't lose a token:** it reads the reply with `jq -er`, checks the token hash, and writes the URL file under `set -C` (refuse to overwrite, so a dangling symlink can't redirect the secret). If anything fails, the error names the token hash to revoke. I added a test for this.
- **macOS:** the script uses `base64 | tr -d '\n'` instead of the GNU-only `base64 -w0`.
- **Not changed:** the panel said `ssm_invoke` never uses `desc`, but it does (`--comment`), so I kept the parameter and only renamed it.

**Checks:** all 18 tests in the test file pass, and `bash -n` (syntax check) passes on both scripts. Prettier flags the test file, but it already did before my change and CI doesn't run it.

**Follow-ups:**
- The other should-fix items are still open: the `mint`/`revoke` race with the running service, `destroy` reaching into the store's on-disk files, and the missing evidence for the Phase 13 claim.
- `ci-wait-merge.sh` can't see CI results on this host (oros-studio), so it may report fix stages here as pending forever.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr176-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 52 tokens (1745111 cached reads)
- Output: 10394 tokens
- Cost: $1.1158222
- Wall-clock: 1458s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
