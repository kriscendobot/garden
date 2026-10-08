**PR #94 viability: proceed.** `kriscendobot/minion.town` PR #94 ("fix(security): authenticate the thunk token endpoint; close the /tmp secret window") has not been superseded, and the problem it fixes is still present on `main`.

**What I checked** (read-only; no clean, panel, fix or CI budget spent):
- **PR state:** open, not a draft, head `e8518a2f`, base `main-d750b09`. It is 6 commits ahead of `main` and 9 behind.
- **Recent `main` history:** the 9 newer commits on `main` (since `d750b09`) are all shell/clip-gutter and `/account/clips` work. None of them touches the thunks or `deploy/aws/scripts`.
- **The High fix is still needed:** on `main`, `deploy/aws/lambda/github-oidc-thunk/index.js` has no client authentication on `/token`. There is no `client_secret` check and no constant-time compare, so a leaked authorization code can still be redeemed by anyone.
- **The SIWE fixes are still needed:** on `main`, `deploy/thunks/siwe/src/openid.js` still looks up the client with `clientId in clients`, which follows the prototype chain (lines 87 and 162), and compares the secret with plain `!==`.
- **The `/tmp` fix is still needed:** on `main`, `deploy-billing-secrets.sh` still downloads secrets to fixed `/tmp/minion-billing.env` and `/tmp/caddy-billing.env` paths.
- **Competing PRs:** draft PR #152 converts several deploy scripts to JavaScript, including two of the shell scripts #94 edits (`deploy-billing-secrets.sh`, `deploy-account-endpoint-secret.sh`). It is unmerged and does not touch the thunk `/token` fix, so whichever PR lands second will need a rebase. It does not displace #94. No other PR implements these fixes.
- **Earlier gauntlet:** the previous run (`kriscendobot-minion.town-pr94-gauntlet-20261008`) completed two panel rounds with CI green. It then stopped because the fix-2 stage ran out of retries for an unclassified reason. That is a problem with the run, not a sign the PR is obsolete.

Deciding question: Does `main` still lack authentication on the GitHub OIDC thunk's `/token`, and the related SIWE and `/tmp` secret-handling fixes, with no other merged or open PR delivering them?
Evidence: Yes. `main` still accepts a bare `code` at `/token`, still uses `in`/`!==` for SIWE client checks, and still stages secrets at fixed `/tmp` paths. The 9 commits since the PR's base touch only shell and clip code, and the only overlapping PR (#152) is an unmerged draft that does not include these fixes.

Follow-up: none from this stage. The gauntlet may proceed.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr94-screen-e8518a2f-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 14 tokens (335290 cached reads)
- Output: 2682 tokens
- Cost: $0.48544199999999993
- Wall-clock: 38s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
