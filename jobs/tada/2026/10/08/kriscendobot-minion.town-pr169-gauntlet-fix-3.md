Fix round 3 for kriscendobot/minion.town PR #169 is pushed and CI is green (3 of 3 checks passed, rc 0).

**The must-fix item.** The decomplector seat said to remove `deploy-guest-recovery-key.sh` and keep only the startup preflight. The two earlier must-fix rounds had both landed on that script, a second CD writer for `/etc/minion-mcp/account.env`. Its own should-fix (re-rendering the key on every deploy silently installs a changed key) goes away with it.

**What changed** (commit `80403034e33`, pushed with `safe-push-pr-head.sh`; the head moved from `cfa7685` to `8040303`):
- **Writer removed:** I deleted `deploy/aws/scripts/deploy-guest-recovery-key.sh` and its workflow step in `.github/workflows/deploy.yml`.
- **IAM grant removed:** `deploy-cd-iam.mjs` is back to the base version, so the CD role no longer reads `minion/guest-recovery-key`. No IAM re-run is needed before merge.
- **Helpers:** `lib/guest-recovery-helpers.sh` now holds only the key pattern, the fetch function and `minion_mcp_secret_preflight`. The merge and validity helpers are gone. When the preflight fails, its error now tells the operator to run `deploy/aws/scripts/deploy-account-endpoint-secret.sh`.
- **Comments:** the header in `deploy-account-endpoint-secret.sh` now says it is the only writer of `account.env`. The comment in `common.sh` no longer mentions rendering.
- **`DEPLOYMENT.md`:** back to the base version, plus one paragraph under "What it runs". It describes the preflight and points to the provisioning script. This also removes the unclear "Phase 12" label another seat flagged.
- **Tests:** I removed the tests for the merge, the Secrets Manager extractor, the writer's remote script and the workflow ordering. I added an assertion that the error message names the provisioning script. `vitest test/deploy-secret-preflight.test.ts` passes 11 of 11, and `tsc --noEmit` is clean.
- **PR body:** rewritten for the preflight-only design. It now says plainly that no IAM change is needed.

**Not addressed:** Prettier flags `DEPLOYMENT.md`, but the base version is already flagged and CI does not run Prettier. The should-fix items that only applied to the merge function no longer apply now that it is gone. That includes the breaker's suggestion to test that a malformed fetched file is refused. I did not re-run the panel; the driver posts panel round 4.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr169-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (1214965 cached reads)
- Output: 9052 tokens
- Cost: $1.0130970000000001
- Wall-clock: 465s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
