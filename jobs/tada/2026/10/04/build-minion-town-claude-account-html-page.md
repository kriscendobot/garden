## Completion report: build-minion-town-claude-account-html-page

I opened draft PR **https://github.com/kriscendobot/minion.town/pull/157** (head `claude-account-html-page`, commit `7c00339`). Browsers now get real HTML pages for the Claude connect flow instead of a downloaded file, and someone can finish connecting from a phone with no JavaScript. I posted the PR link on garden#89: https://github.com/kriscendobot/garden/issues/89#issuecomment-5985387911

**What changed** (`src/auth/claude-account-endpoint.ts`):
- **`GET /account/claude`:** when the browser asks for HTML, it gets a small self-contained page showing the connection and reconnect status. When a connect link is live, the page also shows the "run `claude setup-token`" step, a password-type token field posting to `connect.path`, and the link's expiry time.
  - Headers: `text/html; charset=utf-8`, `no-store`, a mobile viewport tag, `Referrer-Policy: no-referrer`, and a strict CSP of its own (inline styles only, no script, no external assets).
  - Clients asking for JSON, or stating no preference (`*/*`), still get JSON.
- **`GET /account/claude/:nonce`:** an HTML form instead of plain text. The form posts back to its own URL, so the nonce isn't repeated in the page. Other clients still get the plain text.
- **`POST /account/claude/:nonce`:** also accepts `application/x-www-form-urlencoded`. The parser is mounted on this route only, with a 16 KB limit. Form submissions get an HTML result page: connected, expired link (with a link back to `/account/claude`), probe failed, unavailable, or missing token. Status codes match the JSON path, and JSON bodies still get JSON.
- **Unchanged:** the gate, subject admission, and the identity-mismatch response (403). The token is never echoed, logged, or put in a URL.

**Tests:** I added 5 cases to `test/claude-account-endpoint.test.ts`, covering:
- HTML vs JSON (or text) negotiation on both GETs.
- A form POST that connects, then a resubmission that gets the expired-link page.
- The token missing from every response body: success, identity mismatch, missing gate, and failed probe.

**Verification:** typecheck is clean, and those test files plus `test/claude-reauth.test.ts` pass. The full `npm test` run had one failure, in `test/git-remote/capability.test.ts` ("propagates a git failure"). This change doesn't touch that file, and I didn't investigate it further.

**Follow-ups:**
- `ensure-pr.sh` requires a frozen base, so I created `main-880278b` and pointed the PR at it.
- Neither the gauntlet nor a deploy has run, so the live site is unchanged until the PR is merged and deployed.
- The Caddy route for `/account/claude` isn't in the repo's Caddy config. The live site sends only `frame-ancestors 'none'` on this route, which works alongside the app's own CSP.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-minion-town-claude-account-html-page.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 44 tokens (1463781 cached reads)
- Output: 14370 tokens
- Cost: $1.1465642
- Wall-clock: 199s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
