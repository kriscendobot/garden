---
posted_at: 2026-11-04T03:16:12Z
tier: mentor
fallback-tier: minion
dispatch: automatic
---
repo: https://github.com/kriscendobot/minion.town
continues: build-minion-town-https-locators-proof-20261104 (draft PR https://github.com/kriscendobot/minion.town/pull/240, branch feat/https-capability-urls; stacked on #239)
task: Add the real-daemon Playwright proof to PR #240 on the SAME branch. Items 1-3 and 5 of the predecessor are done. The predecessor finished /adopt, locator= handling, link errors, toEndoLocator on the accept route, and the threat notes. The evaluate fix is owned by #239.
1. Write a Playwright test against a real daemon, gated on ENDO_CHECKOUT like test/web/guest-web-daemon.test.ts and reusing its setup. Mint an invitation through MCP evaluate with E(E(agent).invite(n)).locate(). Open https://<origin>/accept#v=1&locator=<encoded> in a fresh browser context, click accept on the card (it creates a guest), and send mail both ways (evaluate send, then /api/guest/mail and evaluate read). Also cover a replay that shows the spent-invitation error, and a malformed fragment that shows the malformed-link error. Neither error may contain fragment text.
2. Run a local Caddy using the repo's deploy/aws/caddy conf.d. Adapt the site address and TLS for local use, but keep the @landing route as it is. Give it an access log and front the test with it. Assert that neither the Caddy access log nor the server log contains the locator or any fragment text, only GET /accept. Caddy is not installed on endolin-garden-ece02cb4. Fetch a pinned release binary into a scratch dir, or do this on a host that has Caddy.
3. Wire the test into CI next to the guest-web-daemon run if that is feasible. Otherwise record the local run in the PR body.
Constraints: keep the PR a draft. No deploy. No secrets in output. Update PR #240's "Still open" section into a production-outcome result.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-11-04T03:31:04Z
