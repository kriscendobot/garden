---
role: builder
repo: kriscendobot/minion.town
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# build: make https://minion.town/account/claude a real HTML connect page (mobile downloads it as a file)

Maintainer report (kriscendobot/garden#89, https://github.com/kriscendobot/garden/issues/89#issuecomment-5985332306):
opening https://minion.town/account/claude "downloads a text file at least on mobile, which won't do".

Root cause (verified at minion.town main 880278b, `src/auth/claude-account-endpoint.ts`):
- `GET /account/claude` responds with `.json(...)` (application/json) — mobile Safari/Chrome download it.
- `GET /account/claude/:nonce` responds `text/plain` saying "submit the resulting token below", but there is no form; and
  `POST /account/claude/:nonce` only accepts a JSON body `{token}`, so a human cannot complete the connect in a browser at all.

Task: on minion.town `main`, open a DRAFT PR that
1. Content-negotiates `GET /account/claude`: browsers (Accept prefers text/html) get a small self-contained HTML page
   (Content-Type text/html; charset=utf-8, Cache-Control no-store, mobile viewport meta) showing status/reauth state and,
   when `connect` is present, the one-step instructions ("run `claude setup-token` on your own machine") plus a password-type
   token input and submit button posting to `connect.path`. Keep JSON for `Accept: application/json` (existing tests/automation).
2. Same for `GET /account/claude/:nonce` (HTML form instead of text/plain).
3. Lets `POST /account/claude/:nonce` also accept `application/x-www-form-urlencoded` (mount urlencoded parsing for this route only)
   and, for form submissions, answer with an HTML result page (connected / expired link → link back to /account/claude / failed) rather than JSON.
   No JS required; the token must never be echoed, logged, or placed in a URL/query string. Preserve the gate, subject admission,
   and identity-mismatch behavior exactly; keep CSP compatible (inline styles only if CSP permits, else none; no external assets).
4. Tests: HTML vs JSON negotiation on both GETs, urlencoded POST success, and that the token never appears in any response body.

Then reply on https://github.com/kriscendobot/garden/issues/89 with the PR link once it is up.

----- ISSUE NOTE (copy this block VERBATIM into every follow-on job) -----
issue_spine: issue-kriscendobot-garden-89
issue_url: https://github.com/kriscendobot/garden/issues/89#issuecomment-5985332306
submitter: kriscendobot
----- END ISSUE NOTE -----
