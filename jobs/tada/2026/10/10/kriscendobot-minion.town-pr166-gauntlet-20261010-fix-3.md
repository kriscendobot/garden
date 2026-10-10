Fix round 3 for PR #166 is pushed and CI is green at `e5f7548` (`ci-wait-merge.sh` returned 0; all 3 checks passed). The new probe client can't be tested against production until this PR merges and deploys. The first post-deploy probe run on `main` will be its first real test.

**Must-fix 1 (locksmith: the probe held a full-guest credential).** The probe used the shared `minion-mcp-test-cc` client, which can reach `evaluate`, `send`, `adopt` and the `claudeAgents` tools.
- **Server change:** an entry in `config/policy.json` can now carry a `tools` list. A session for that identity registers only the listed tools, so the rest never appear in `tools/list` and can't be called (`src/auth/policy.ts`, `src/server.ts`). New tests cover the policy lookup, the shipped probe entry, and an HTTP check that the session lists exactly three tools and refuses `evaluate`.
- **New client:** I wrote `deploy/aws/scripts/deploy-cognito-probe-client.sh`, which creates the client if missing and reuses it otherwise. I ran it against production with `--github`. That created:
  - the Cognito client `minion-mcp-prod-probe` (`1sfubi3lucuvthr5or880cuvmv`), with its own guest; a token grant works and carries `mcp/guest mcp/tools`.
  - its secret in Secrets Manager as `minion/prod-probe-client`.
  - the `prod-probe` environment secrets on the repo.
- **Wiring:** `config/policy.json` limits the client to `status`, `writeText` and `readText`, and its id is added to `OAUTH_ALLOWED_CLIENT_IDS` in `minion-mcp.service`.
- **Workflow:** the probe job now runs in `environment: prod-probe`. That environment already existed and admits only `main`.
- **Old secrets:** I deleted the four repo-level copies of the full-guest secret (`MINION_PROBE_CLIENT_CREDENTIALS_*` and the older `MINION_PROBE_CC_*`); nothing on `main` read them. The values are still in Secrets Manager under `minion/test-cc-client`.

**Must-fixes 2–4 (pruner):**
- The workflow header is now one line pointing to DEPLOYMENT.md.
- I removed the duplicate "summary is public" sentence from DEPLOYMENT.md; the probe script's header keeps it.
- In the probe script, I deleted the comments on `websocketUpgrade` and `callTool`, reduced the `hardCacheViolations` one to its `cache-policy.ts` reference, and cut `withSession`'s comment to its two rationale sentences.

**Should-fix:** the locksmith's documentation item is done: the DEPLOYMENT.md credential section and client table now describe the narrow client. I skipped the wrong-ETag check and the `node-version` pin; `"22"` already resolves to a release at or above 22.18.

**Commits and PR body:** two commits, `9fb582a` (the client change) and `e5f7548` (comment cleanup), pushed with `safe-push-pr-head.sh`. The PR body now describes the new client and the deleted secrets, and says the credentialed checks were last run at `501b1e1` with the old shared client.

**Tests:** typecheck is clean and the probe's own tests pass 16/16. One local failure in `test/git-remote/capability.test.ts`, which this PR doesn't touch, did not appear in CI.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr166-gauntlet-20261010-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 88 tokens (4152665 cached reads)
- Output: 22924 tokens
- Cost: $2.1763090000000003
- Wall-clock: 1084s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
