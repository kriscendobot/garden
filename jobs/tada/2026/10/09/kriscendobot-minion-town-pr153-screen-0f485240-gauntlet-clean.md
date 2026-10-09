PR #153 (kriscendobot/minion.town) passed the clean stage: I fixed four stale references and CI is green at the new head `17cf1642793`. One caveat: the gauntlet's CI-wait script couldn't confirm that itself. On this host the bot token can't read the PR's check status, so I read the result from the GitHub Actions API instead.

**Coverage:** no new tests needed. The PR already brings behavioural tests for the scripts it converts, in `test/deploy-cd-scripts.test.mjs` and `test/deploy-render-reconcile.test.mjs`.

**Dead code:** I checked the repo for anything still pointing at the 7 deleted `.sh` scripts. Only 4 comments and docs still named `deploy-caddy.sh`. I confirmed `deploy-caddy.js` keeps the same behaviour (it holds the caddy-environment lock and checks the `/account/claude` routing), so these were just outdated names. I changed them to `deploy-caddy.js` in:
- `DEPLOYMENT.md`
- `test/caddy-environment-sync.test.ts`
- `deploy/aws/scripts/deploy-app.sh`
- `deploy/aws/scripts/lib/caddy-environment-sync.sh`

`node tools/check-javascript-only-scripts.js` passes. I committed this as `17cf164` ("chore: update stale deploy-caddy.sh references to deploy-caddy.js") and pushed it with `safe-push-pr-head.sh` (`0f48524..17cf164`).

**CI:**
- **Actions API:** the only workflow, "test (typecheck + vitest)", finished with **success** at head `17cf1642793644fd8883377a23cb8fbeae465c73`: https://github.com/kriscendobot/minion.town/actions/runs/37868498192. The commit statuses endpoint also returns 403.
- **`ci-wait-merge.sh`:** it returned rc 4, but only because every `gh pr view` call failed. GitHub answers "Resource not accessible by personal access token" when asked for the check status. That is the known missing checks:read permission on this host, not CI still running. The first run, with the 3600s deadline, ran into the tool's 10-minute limit and was moved to the background; I didn't get its result. A second run with a 300s deadline is the one that returned rc 4.

**Follow-up:** while this host's token lacks checks:read, every gauntlet CI wait on minion.town from oros-studio will time out the same way. Either `ci-wait-merge.sh` should fall back to the Actions runs API, or the token needs checks:read.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr153-screen-0f485240-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (742981 cached reads)
- Output: 4953 tokens
- Cost: $0.6108802
- Wall-clock: 1332s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
