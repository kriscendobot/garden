---
posted_at: 2026-11-04T02:09:16Z
tier: mentor
fallback-tier: minion
dispatch: automatic
---
repo: https://github.com/kriscendobot/minion.town
continues: build-minion-town-https-locators-20261104 (first slice, branch feat/https-capability-urls, draft PR linked from tracker https://github.com/kriscendobot/minion.town/issues/227)
related: https://github.com/kriscendobot/minion.town/pull/170, https://github.com/kriscendobot/minion.town/pull/236, job build-minion-town-tool-minimalism-20261104
task: Finish the https capability-URL work on the SAME branch/PR (feat/https-capability-urls; find the PR by the marker `<!-- garden-job: build-minion-town-https-locators-20261104 -->` or by head branch). The first slice landed the grammar (src/web/capability-url.ts: /accept and /adopt, fragment `v=1` + `invitation` | `locator`, endo:// round-trip via toEndoLocator), moved MCP/browser invitation minting to https://<origin>/accept#v=1&invitation=<id>, served /accept from Caddy (@landing), and made home.js scrub any secret-bearing fragment on read. Remaining:
1. /adopt fall-through: Caddy route + home.js handling `locator=` (adopt through the guest session; sign in or create a guest then continue). Accept `#v=1&locator=` on /accept for daemon invitation locators. Visible errors for a malformed fragment and a spent invitation (no fragment content echoed).
2. evaluate-minted invitations emit the https form, and the web page can accept them. Coordinate with build-minion-town-tool-minimalism-20261104 (message its inbox first) so the evaluate fix is not done twice; say in the PR which job owns it.
3. Use toEndoLocator wherever a user pastes a locator (settings remote-invitation hints, PR 236), so both forms keep working during the transition.
4. Proof: a real-daemon Playwright test. Mint an invitation through evaluate, open it as an https /accept URL in a fresh browser context, accept it, and send mail both ways. Assert that the server log and a Caddy access log (local Caddy with the repo's conf.d) contain no fragment.
5. Add the threat notes to the PR body: referrer (Referrer-Policy no-referrer is already on the landing route), link-preview crawlers (fragments are not sent), browser history (replaceState scrub, reload drops the link), the PR 173 crawler/leak signal.
Constraints: keep the PR a draft. No deploy. No secrets in output. Write the PR description as a production-outcome report.
