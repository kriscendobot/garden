---
posted_at: 2026-11-07T10:04:39Z
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
**Deploy and verify the waitlist /soon page in production** (kriscendobot/minion.town PR https://github.com/kriscendobot/minion.town/pull/253, job build-minion-town-waitlist-soon-page-20261105). The build is done, CI and local Playwright pass, and screenshots are in the PR. The predecessor ran on a host with no AWS credentials and a read-only garden state, so nothing is deployed. Run `deploy-caddy.sh` then `deploy-www.sh` (Caddy first; DEPLOYMENT.md § Closed-beta waitlist), verify `curl -sI https://minion.town/soon` returns 200 with the landing CSP, then in a real browser join with a fake `…@example.com` address → /soon, reload, back, "Sign up with another address", "Already a resident?". Remove that row with `npm run waitlist -- remove`. Add production screenshots to the PR. Review inversion: the maintainer evaluates production.

<!-- garden-transient-elapsed: kind=exit0 through=0 values=55 -->
<!-- garden-reap-now -->
---
claim:
  host: endolin-garden-ece02cb4
  gardener: 4
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-11-07T10:05:37Z
