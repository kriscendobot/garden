from_host: endolin-garden-ece02cb4
from: reaper:endolin-garden-ece02cb4
sent_at: 2026-11-07T10:33:26Z
doom_base: deploy-minion-town-waitlist-soon-page-20261107
doom_signature: requeue-exhausted
notice_count: 1
first_seen: 2026-11-07T10:33:26Z
last_seen: 2026-11-07T10:33:26Z
---
SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
The work is preserved at jobs/plan/deploy-minion-town-waitlist-soon-page-20261107; it stays HELD until a human promotes it
(promote-plan.sh deploy-minion-town-waitlist-soon-page-20261107) or removes it, so nothing is lost.
Original job base: deploy-minion-town-waitlist-soon-page-20261107

--- original job body ---
---
posted_at: 2026-11-07T10:04:39Z
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
**Deploy and verify the waitlist /soon page in production** (kriscendobot/minion.town PR https://github.com/kriscendobot/minion.town/pull/253, job build-minion-town-waitlist-soon-page-20261105). The build is done, CI and local Playwright pass, and screenshots are in the PR. The predecessor ran on a host with no AWS credentials and a read-only garden state, so nothing is deployed. Run `deploy-caddy.sh` then `deploy-www.sh` (Caddy first; DEPLOYMENT.md § Closed-beta waitlist), verify `curl -sI https://minion.town/soon` returns 200 with the landing CSP, then in a real browser join with a fake `…@example.com` address → /soon, reload, back, "Sign up with another address", "Already a resident?". Remove that row with `npm run waitlist -- remove`. Add production screenshots to the PR. Review inversion: the maintainer evaluates production.
