I opened draft PR https://github.com/kriscendobot/minion.town/pull/159 that fixes the `/account/claude` 404, and replied on the issue thread with the PR URL and evidence. CI hasn't run on it: GitHub reports no checks for the branch, probably because the PR targets a frozen base branch rather than `main`.

**Cause:** the app serves `/account/claude` and `/account/claude/<nonce>`, but the Caddy site only proxied the exact `/account` path. Signed-in requests to either Claude path fell through to the static file handler and got 404. Signed-out requests redirect to sign-in either way, which is why the bug only appeared after login.

**What changed** (branch `claude-account-caddy-route`, commit `02ddb6d`, base `main-9d563c9`, a frozen snapshot of `origin/main` at `9d563c9`):
- **Caddy route:** `deploy/aws/caddy/conf.d/minion-town.caddy` now has a route matching only `/account/claude` and `/account/claude/*`, so sibling paths like `/account/claude-foo` don't match. It uses the same login check as the other account routes, forwards `X-Auth-Request-Sub`, and attaches `X-Account-Gate-Token` before proxying to the app.
- **New test:** `test/caddy-account-routes.test.ts` models how the site picks a route and fails if either Claude path reaches the static handler. Against `origin/main`, 3 of its 6 cases fail. It also checks that the deploy scripts contain the checks below.
- **`deploy-caddy.sh`:** after the reload, it checks that the live config has the new route. It then sends signed-out requests for both paths through Caddy itself, not the app's loopback port. Each must get the sign-in redirect without the `X-Frame-Options` header that the static handler adds to its own redirect.
- **`deploy-app.sh`:** the check that the app refuses a forged subject with 403 now covers the stable page as well as the nonce route.

No Claude setup token was requested or exposed.

**Verification:**
- I ran a real Caddy v2.10.2 locally, with stand-ins for the sign-in service and the app:
  - The old config returns 404 for a signed-in `/account/claude`, which reproduces the bug.
  - With the new config, signed-in requests to both paths reach the app (GET and POST). The subject comes from the sign-in service, a forged subject sent by the client is overwritten, and the gate token is attached. Signed-out requests still redirect to sign-in, and static pages are unchanged.
  - The new check in `deploy-caddy.sh` passes against the new config and fails against the old one. The config check and the request check each catch the old config independently.
- `npm test`: 838 passed and 1 failed. The failure is in `test/git-remote/capability.test.ts`, and it also fails on unmodified `origin/main` on this host. `npm run typecheck` is clean.

**Follow-ups:**
- The review gauntlet is staged automatically when this build job completes.
- After merge, deploy the `caddy` target for the fix and the `app` target for the stronger `deploy-app.sh` check.
- The issue stays open.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-minion-town-claude-account-caddy-route.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 56 tokens (2056639 cached reads)
- Output: 24389 tokens
- Cost: $1.5584357999999996
- Wall-clock: 321s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
