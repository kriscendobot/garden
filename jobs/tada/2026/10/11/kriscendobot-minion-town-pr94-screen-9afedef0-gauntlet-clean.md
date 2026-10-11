# Clean stage report: kriscendobot/minion.town PR #94 (gauntlet `kriscendobot-minion-town-pr94-screen-9afedef0-gauntlet`)

The coverage on PR #94 is good, I found no dead code to remove, and CI is green at the current head. I pushed nothing. The one caveat: the green verdict comes from the GitHub Actions runs API, not from `ci-wait-merge.sh`, because that script can't read CI status on this host.

**PR shape:** open, not a draft. Head is `57d05a58` on branch `security/token-client-auth-and-secret-umask`.

**Coverage pass** (isolated checkout from `ensure-project-worktree.sh`):
- **vitest:** the two suites the PR touches pass, 71 tests (`test/github-oidc-thunk-token-auth.test.ts` and `test/caddy-environment-sync.test.ts`).
- **v8 coverage of the thunk test:**
  - `deploy/thunks/shared/client-authentication.cjs` has 100% line coverage and 94% branch coverage. The two unexercised branches are fallbacks: an invalid raw reading after a bad percent-escape, and a missing request body.
  - `github-oidc-thunk/index.js`: the whole new `/token` client-authentication block is covered, including the 401, 500, Basic and post paths. The uncovered lines are in the `/authorize` and `/userinfo` routes, which this PR doesn't touch.
- **SIWE `node --test`** (CI excludes this suite): 28 of 28 pass. The shared module has 100% line coverage. The uncovered lines in `openid.js` are older error branches the PR didn't change.
- **Dead code:** none. The old inline Basic parsing in the SIWE `/token` was removed and replaced by the shared module. `secret.js` is still used. The `install_secret` helper is wired into every secret deploy script. The only `/tmp` uses left in `deploy-oauth2-proxy.sh` handle the oauth2-proxy binary tarball, not secrets.
- Installs used `--no-save`, so the project tree stayed clean. I removed the scratch temp directory afterwards.

**CI:** `ci-wait-merge.sh` was hanging without a verdict, which is the known gap that the bot's token on this host (oros-studio) can't read CI status. I stopped it. The Actions runs API shows the only workflow at head `57d05a58`, "test (typecheck + vitest)", as **completed / success**: https://github.com/kriscendobot/minion.town/actions/runs/38098933491

**Follow-up:** the bot token on oros-studio still can't read checks or statuses, so `ci-wait-merge.sh` can't return a verdict on this host. This has happened before; it is recorded in memory.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr94-screen-9afedef0-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (1023387 cached reads)
- Output: 6228 tokens
- Cost: $0.7931094000000001
- Wall-clock: 853s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
