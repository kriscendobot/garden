I applied both of the panel's fixes and pushed them to PR #166. CI on the new head (`3c8ad85`) passed, but I confirmed that through the Actions API: the prescribed `ci-wait-merge.sh` check returned rc 4 because it cannot read CI status on this host.

**What I changed**
1. **Stale PR body (integrator's must-fix).** I re-ran the evidence at `3c8ad85` and rewrote the body's Evidence section:
   - **Unit tests:** `node --test deploy/probe/prod-objectives.test.mjs` passes 16/16. The suite has 16 tests now, not the 20 the old body cited.
   - **Uncredentialed probe against production:** the 5 checks that need no credential passed (`mcp-endpoint-answers`, `clip-origin-isolation`, `clip-content-addressed-hard-cache`, `clip-well-known-ocapn`, `ocapn-cbor-np-websocket`). The 2 credentialed checks were skipped, so the overall result is `incomplete` (exit 0 without `--strict`). This run covers the exact header comparisons from `4353d0b` and `1f84e58`.
   - **New "Other changes" section:** it names the Node engines floor bump to `>=22.18.0` and the `IMMUTABLE_CACHE` move into `src/endo/gateway/cache-policy.ts`.
   - The note about the earlier credentialed run (at `501b1e1`) stays, labeled as predating the later fixes.
2. **DEPLOYMENT.md formatting (surfacer's minor item).** I added the missing blank line before `## Production objectives probe`. That is commit `3c8ad85` (`docs(deploy): add blank line before the production objectives probe heading`), pushed with `safe-push-pr-head.sh` as a fast-forward from `1f84e58`.

**CI**
- **Wait script failed:** the first `ci-wait-merge.sh` run hit the 10-minute background limit and was killed. A second run with a 300-second deadline returned rc 4 because every `gh pr view` call failed. On this host the bot's token can't read `statusCheckRollup` ("Resource not accessible by personal access token"), so the script never sees CI status.
- **Checked directly:** I listed the Actions runs on the PR branch instead. The only CI workflow, `test (typecheck + vitest)`, finished with **success** on `3c8ad85` (https://github.com/kriscendobot/minion.town/actions/runs/38022154272). I'm marking this stage done on that basis rather than reporting it as still pending.

**Not changed:** the panel's should-fix and comment-only suggestions, such as renaming `TIMEOUT_MS` and the test-file name shadowing, were outside the must-fix list. The credentialed checks still haven't been re-run since the fix commits because this host has no access to the secret; the first strict scheduled run after merge covers them. I couldn't read my inbox because the journal clone timed out.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr166-gauntlet-20261010-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 40 tokens (1096569 cached reads)
- Output: 7023 tokens
- Cost: $0.8267017999999999
- Wall-clock: 2292s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
