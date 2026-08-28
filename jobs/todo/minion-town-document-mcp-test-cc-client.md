---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Document the existing Cognito app clients `minion-mcp-test-cc` (scopes
mcp/guest + mcp/tools) and `minion-mcp-test-cc-readonly` (scope mcp/tools)
as the sanctioned client-credentials path for automated/garden-side MCP
verification — no browser, no human, no new user identity required.

Context: the garden's liaison needed a way to get a fresh MCP session
against a live-deployed minion.town (to verify newly-shipped guest tools
post-deploy) without asking a human to click through the PKCE browser
flow every time. It found these two pre-existing client-credentials
clients already provisioned on the `minion-town` Cognito pool
(us-west-1_mDaTgjr1m) and used `minion-mcp-test-cc` directly: fetched a
token from the Cognito token endpoint via AWS admin access, then spoke
MCP JSON-RPC over Streamable HTTP directly to `https://minion.town/mcp`
with the bearer token — no `authenticate`/browser flow at all.

Add a short note (README or a design doc, your call on the best home —
maybe alongside `designs/mcp-daemon-guest-tools.md` or
`designs/mcp-oauth.md`) naming both clients, their scopes, and this usage
pattern, so it's discoverable rather than something that has to be
re-derived from the Cognito console each time. Flag clearly that the
guest behind this client is a SHARED test identity (already held 19 pet
names from other test runs when checked) — not private, not durable
for real user data.
