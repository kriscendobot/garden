## Rung 0a of the shell CapTP session: kriscendobot/minion.town PR #231

Rung 0a is deployed and checked against production, with one gap: I could not watch a real signed-in shell tab in a browser, because that needs a human GitHub login. The PR ledger now says `deliverable` with Rung 0a and Acceptance both `satisfied`. The PR is still a draft until the gauntlet's next panel passes.

**1. Open question (j), per-tab vs per-browser.** Design #230 already answers (j) as per-tab sessions, with revoke per locator and revoke of everything on sign-out. That matches #231. A different gap remained. #230 §3.1, §3.2 and the §3.6 tests still said the door checks that the locator's subject matches the logged-in user. #231 dropped that check after the locksmith review, so the locator alone decides which owner facet opens. I changed the design to match the code and pushed it as `b72458c0` on `design/clip-governor-column`.

**2. Deployment.** Production already ran app `33e5d30d` (deployment receipt says `promoted`). The PR head `5fbf2cf9` differs from it by one test line only, so I did not redeploy. The live Caddy config has the same md5 as the head's file. The served `shell-session.js`, `shell-captp.js`, `home.js` and `shell.js` are byte-identical to the head.

**3. What I observed in production.** I ran a probe on the production host against the deployed app, sending the identity headers Caddy and oauth2-proxy add. It used two test client identities, never a maintainer's.
- **Owner facet:** mint answered 201 with `no-store` and a 12-hour grant. `open(locator)` returned a facet whose `info()` returns only `expiresAt`.
- **Reconnect:** after the socket dropped, a new socket opened the same locator and `info()` answered again.
- **Revoke one locator:** the open socket closed with 1008 `shell-session-revoked`. The revoked locator and an unknown locator were then refused.
- **Sign-out:** both of the first identity's open tabs closed with `shell-session-sign-out`. The second identity's facet kept answering.
- **Gates at the app:** the WebSocket upgrade was refused (403) for a clip origin, a `null` origin, no origin, and no cookie, even with valid identity headers. Mint was refused for cross-site (403), no cookie (401) and a bad gate token (401).
- **Gates at the public edge:** an upgrade, mint or revoke with no login, and a forged identity header, all got 403.
- **Hostile clip:** I published a clip titled "Settings" to production and ran it in Chromium. Its WebSocket to the session route failed, its credentialed mint was blocked, and the edge answers 403 to that clip's exact origin. I've unpublished it. Firefox and WebKit would not start on this host (missing system libraries); CI's browser gate covers both.
- **Public scripts:** `/shell-session.js` and `/shell-captp.js` return 200 and match the head.

**4. PR body and gauntlet.** The body now records the (j) answer, a production-evidence section, and the ledger change. All 7 CI checks pass on `5fbf2cf9`. I did not post a new gauntlet because the existing one is still running: it is at fix-4 of 6, and fix-4's push is the green head. Its next round, panel-5, will review the updated body, and a pass un-drafts the PR, since the ledger no longer says to keep it draft. If panels 5 and 6 both fail, that gauntlet gives up and someone will need to run it again.

**Follow-ups**
- A maintainer-signed-in check of the real shell tab is still open. It needs an interactive login, which the fleet cannot do.
- My first probe run printed one test-identity locator in plain text. The next run revoked every locator for that identity before minting, so it is dead.
- Pushing `b72458c0` to design PR #230 may set off review machinery there. It is a wording change to match code that already passed review.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-shell-captp-session-rung0a-deploy.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s) (1 unmetered)
- Input: 104 tokens (4454663 cached reads)
- Output: 27543 tokens
- Cost: $2.3049846000000005 (1 engagement(s) unpriced)
- Wall-clock: 2762s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
