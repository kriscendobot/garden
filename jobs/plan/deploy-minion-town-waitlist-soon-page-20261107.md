---
gate: go-ahead
priority: normal
role: builder
tier: mentor
token-budget: 250000
doomed: true
doom_signature: requeue-exhausted
doom_count: 1
split_eligible: true
split_reason: repeated-plain-exit
failure_classification: transient
requeue_cycles: 2
deadline_overruns: 0
elapsed_constancy_confirmations: 0
doomed_at: 2026-11-07T10:33:06Z
doomed_on: endolin-garden-ece02cb4
posted_by: reaper:endolin-garden-ece02cb4
posted_at: 2026-11-07T10:33:06Z
---

---
posted_at: 2026-11-07T10:04:39Z
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
**Deploy and verify the waitlist /soon page in production** (kriscendobot/minion.town PR https://github.com/kriscendobot/minion.town/pull/253, job build-minion-town-waitlist-soon-page-20261105). The build is done, CI and local Playwright pass, and screenshots are in the PR. The predecessor ran on a host with no AWS credentials and a read-only garden state, so nothing is deployed. Run `deploy-caddy.sh` then `deploy-www.sh` (Caddy first; DEPLOYMENT.md § Closed-beta waitlist), verify `curl -sI https://minion.town/soon` returns 200 with the landing CSP, then in a real browser join with a fake `…@example.com` address → /soon, reload, back, "Sign up with another address", "Already a resident?". Remove that row with `npm run waitlist -- remove`. Add production screenshots to the PR. Review inversion: the maintainer evaluates production.
