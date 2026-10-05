**Viability report: kriscendobot/minion.town PR #159** ("fix(caddy): route /account/claude and its nonce form to the app")

**Verdict:** `proceed`. The PR is open and still a draft. It has no merge, no reviews and no comments, and it was opened today (2026-10-05) at 14:17Z.

**Deciding question:** Does the Caddy config on current `main` still lack a route for `/account/claude` (and `/account/claude/*`) to the app, so that a signed-in user still gets the reported 404, with no other PR or commit fixing it?

**Evidence:** The answer is yes.
- **The bug report is current.** kriskowal reported the 404 at 14:01Z today (https://github.com/kriscendobot/garden/issues/89#issuecomment-5996039708: "Claude account page is 404 currently"). The PR was opened 16 minutes later to fix exactly that.
- **The base is the tip of `main`.** PR #159's base is `main-9d563c9`, and `9d563c9` (the merge of dependabot PR #158) is still the newest commit on `main`. Nothing newer could have replaced the fix.
- **`main` still has the bug.** In `deploy/aws/caddy/conf.d/minion-town.caddy`, the only account routes are `handle /account/guest-recovery`, the exact-path `handle /account`, and the `@guestSelf` matcher (`/account/guest-formula-id`, `/account/guest-locator`). Nothing matches `/account/claude`, so the request falls through to the static file server, as the PR says.
- **The app side the PR depends on has landed.** `/account/claude` is implemented in `src/auth/claude-account-endpoint.ts`, `src/http.ts` and `src/endo/claude/*`. The HTML connect pages arrived in PR #157, merged at 05:02Z today. So the page exists in the app and only the proxy route is missing.
- **No other PR covers it.** Searching the repo's PRs for "account/claude" turns up nothing else that touches this Caddy route.

No clean, panel, fix, CI-wait or un-draft budget was spent.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-minion-town-claude-account-caddy-route-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (160842 cached reads)
- Output: 1403 tokens
- Cost: $0.39104440000000007
- Wall-clock: 19s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
