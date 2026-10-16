**Clean stage report: kriscendobot/minion.town PR #194** (`feat/clip-embed-headers`, head `cc666e6`, draft, open)

The PR was already the right shape, so this stage made no changes and pushed nothing.

- **Coverage:** The change is header policy in the Caddy config, plus the `CLIP_FRAME_ANCESTOR` constant in `src/endo/gateway/isolation-headers.ts` and the matching probe expectation.
  - The new file `test/caddy-framing-floor.test.ts` has 16 tests. Per the PR body, they were checked against deliberate breakage: widening the ancestor, append changed to set, `defer` dropped, a route left off the admission list, `'self'` added to `child-src`.
  - The updated tests in `caddy-account-routes` and `shell-clip` cover the rest.
  - The existing gateway `ISOLATION_HEADERS` equality tests cover the new value on 200, 304 and 404 responses.
  - I found no untested branch to add.
- **Dead code:** None left behind. The old X-Frame-Options check in `deploy-caddy.sh` was replaced in place with a `frame-src` CSP check, and its test assertion was updated to match. The old `minion.town, www.minion.town` site header was replaced throughout, including the parser in `caddy-account-routes.test.ts`.
- **CI:** `ci-wait-merge.sh kriscendobot/minion.town 194 --no-merge` returned rc 0 (GREEN). The bot token can't read the PR's combined check status, so the script fell back to GitHub Actions runs: one run, "test (typecheck + vitest)", passed at `cc666e6`. Commit statuses and checks from outside Actions aren't visible that way.

No follow-ups.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr194-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 12 tokens (254405 cached reads)
- Output: 2060 tokens
- Cost: $0.423913
- Wall-clock: 35s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
