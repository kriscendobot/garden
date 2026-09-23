Implemented and landed [kriscendobot/minion.town#113](https://github.com/kriscendobot/minion.town/pull/113), merge commit `30621249be8aad83472a45194846fb88b9e519c3`.

- `/mcp`: Express limit raised from 100 KB to 2 MB via one named constant.
- Other routes: unchanged at Express’s 100 KB default.
- Stripe `/billing/webhook`: raw-body ordering preserved.
- Documented the 2026-09-23 decision and planned reduction to ~64 KB after git-HTTP asset submission lands.
- Upstream audit: Caddy remains uncapped; `/mcp` directly proxies to the loopback app; oauth2-proxy is not on this path; the live EC2 deployment has no ALB, API Gateway, or App Runner hop. No upstream limit required adjustment.
- Tests added: 1.5 MB `/mcp` body reaches authentication rather than 413; over 2 MB returns 413; non-`/mcp` over 100 KB still returns 413.
- Verification: `npm test` passed 431 tests with 5 skipped; `npm run typecheck` passed; all three PR CI checks passed.
- Continuous deployment run `35917236460` completed successfully.
- Live probe: a 1,048,590-byte JSON body sent to `https://minion.town/mcp` returned HTTP 401, confirming every parser/proxy accepted it.
- Follow-up: reduce the limit to approximately 64 KB after out-of-band git-HTTP asset submission lands.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-mcp-body-limit-2mb.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 814s

<!-- garden-usage-end -->
