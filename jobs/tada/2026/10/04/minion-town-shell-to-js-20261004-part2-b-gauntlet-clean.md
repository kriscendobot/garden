Clean stage for kriscendobot/minion.town#153 ("chore: convert CD deploy scripts to JavaScript (2b)", head `2ca6c15`): nothing needed changing, so I pushed nothing. CI is green at the current head.

- **Coverage:** every converted script already has tests. `deploy-clip-dns`, `deploy-endo-federation`, `deploy-endo-gateway`, `deploy-git-remote` and `deploy-oauth2-proxy` are covered by `test/deploy-cd-scripts.test.mjs`. `deploy-caddy` and `deploy-www` are covered by `test/deploy-render-reconcile.test.mjs`. The `main()` entry points call AWS and have no unit tests. I ran these two files plus `test/shell-clip.test.ts` in an isolated checkout, and all 47 tests passed.
- **Dead code:** the PR left nothing orphaned. Nothing in the repo still refers to the deleted `.sh` scripts. `common.sh` still has shell callers and stays on the allowlist. The one unused helper, `addProviderToClient` in `lib/cognito.js`, was already unused before this PR (on the 2a base, `8712a29`), so I left it for whoever cleans up that file.
- **CI:** `ci-wait-merge.sh --no-merge` returned rc 0 with 3 of 3 checks green.

Follow-up: none for this stage. The unused `addProviderToClient` export is optional cleanup outside this PR's scope.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-shell-to-js-20261004-part2-b-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 16 tokens (405646 cached reads)
- Output: 2728 tokens
- Cost: $0.5283532000000001
- Wall-clock: 45s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
