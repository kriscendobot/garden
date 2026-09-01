---
created: 2026-09-01
author: liaison
---

# Skill: minion-town-mcp-playwright-login

Authenticate a Playwright-controlled browser to the minion.town streamable HTTP
MCP endpoint through Cognito’s GitHub federation when a headless MCP client
cannot use the registered callback.

## Purpose

Use this skill when a local MCP client needs an authenticated session at
`https://minion.town/mcp` and its OAuth callback does not match the Cognito
client’s registered redirects. The flow authenticates to minion.town, not to
GitHub’s API, and must never extract or print a GitHub password, cookie, PAT, or
client secret.

## Known deployment facts

- Cognito user pool: `us-west-1_mDaTgjr1m` in `us-west-1`.
- Public PKCE client: `1uesun672b9a0lidth983v0vc9`.
- Authorization server: `https://minion-town.auth.us-west-1.amazoncognito.com`.
- MCP resource and OAuth resource: `https://minion.town/mcp`.
- The public client’s registered callbacks must be inspected before use. The
  documented deployment has `http://localhost:8080/callback` and
  `https://minion.town/callback`; arbitrary `127.0.0.1` ports are not valid.

## Procedure

1. Confirm the endpoint’s protected-resource metadata and the client’s actual
   callback URLs with read-only requests. Do not guess a redirect URI.
2. Launch Playwright with a disposable persistent profile and the locally cached
   Chromium binary when available. Do not reuse a personal browser profile.
3. Generate a fresh PKCE verifier/challenge and a random state. Build the
   Cognito `/oauth2/authorize` URL with `response_type=code`, the public client
   ID, the exact registered callback, the MCP scope requested by the deployment,
   and `resource=https://minion.town/mcp`. The current public client accepts
   `mcp/tools` and `mcp/guest`; adding `openid profile email` can produce
   Cognito `invalid_scope` unless those OIDC scopes are explicitly enabled.
4. Start a local callback listener on the selected registered callback (normally
   `localhost:8080/callback`) before navigating. Verify `state` exactly and
   capture only the one-time authorization code. Never log the complete URL.
5. Navigate the disposable browser context through Cognito and select GitHub.
   This reaches GitHub’s web login, which may ask for credentials or MFA. Stop
   and request the user to complete that interaction; an existing `gh`
   credential is an API token, not a browser session, and cannot be silently
   converted into one.
6. Exchange the code at the Cognito `/oauth2/token` endpoint with the same PKCE
   verifier, client ID, redirect URI, and `grant_type=authorization_code`.
   Keep the access token in process memory or a protected, user-approved secret
   store. Do not put it in source, the journal, shell history, or tool output.
7. Configure the MCP client with the resulting Cognito access token using its
   environment-variable token hook (for Codex, `--bearer-token-env-var`), then
   verify `tools/list` against the authenticated endpoint. Record only the
   identity/scopes and tool names, never the token.

## Boundaries

- This is a user-account login. It does not authorize production deployment,
  Cognito configuration changes, scope cleanup, or use of the break-glass
  administrator.
- Do not create a Cognito user or mint an admin token unless the user separately
  authorizes that exact action and supplies the intended test-user scope.
- Do not claim success until the callback, token exchange, and authenticated
  `tools/list` request all succeed.

## Failure handling

- `invalid_request` at Cognito usually means the callback is not registered or
  the resource/scope parameters do not match the deployment. Re-inspect the
  client instead of retrying with a random callback.
- A GitHub login page with no session is an expected human checkpoint, not a
  reason to scrape credentials or query the GitHub API for a substitute token.
- A token may be valid for MCP while being unusable as a GitHub API credential;
  keep those credential domains separate.
