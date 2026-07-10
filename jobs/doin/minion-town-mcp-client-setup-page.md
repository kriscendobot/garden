---
role: web-builder
---

web-builder job (minion.town — `kriscendobot/minion.town`). Create an
authenticated-only page on minion.town, linked from the authenticated landing
page, that helps signed-in users **discover how to configure various MCP clients**
to connect to the minion.town MCP (`https://minion.town/mcp`). Deploy → validate
in production → post a PR (per the 2026-07-10 minion.town PR convention).

## What to build

A styled page matching the existing authenticated landing / login aesthetic
(`deploy/aws/www/`, served by Caddy), reachable via a clear link on the
authenticated landing page (e.g. "Connect an MCP client"), with per-client setup
for `https://minion.town/mcp`. Cover at least:

- **Claude Code (CLI):**
  `claude mcp add --transport http --client-id 1uesun672b9a0lidth983v0vc9
  --callback-port 8080 minion-town https://minion.town/mcp`, then
  `claude mcp login minion-town`. Call out the two gotchas: `--client-id` is
  REQUIRED (Cognito has no dynamic client registration — omitting it fails with
  *"does not support dynamic client registration"*), and `--callback-port 8080`
  must match the registered redirect `http://localhost:8080/callback`. Add the
  remote/container note: `claude mcp login --no-browser` paste-back, or an SSH
  port-forward of 8080, when the browser is on a different host than the CLI.
- **Claude.ai remote-MCP connector and other OAuth-capable MCP clients:** server
  URL `https://minion.town/mcp`; OAuth is Cognito-brokered (RFC 9728
  protected-resource metadata at `/.well-known/oauth-protected-resource/mcp`);
  public PKCE client `1uesun672b9a0lidth983v0vc9`; scopes
  `mcp/tools mcp/minions:read mcp/minions:write`; sign-in via Google / GitHub /
  SIWE at the Cognito hosted UI.
- Brief orientation: the tools exposed today (`minion_status`, `list_minions`,
  `summon_minion`) and that a freshly provisioned identity starts at baseline
  authority until granted more.

Ground every fact against the LIVE stack (the Cognito app-client config, the
resource-metadata document, the Caddy `/mcp` routing, and the known-working
setup) rather than inventing — verify before publishing.

## Requirements

- Gate the page behind the same login gate as the landing page (authenticated
  users only).
- Deploy and validate live via the www path (`deploy/aws/scripts/deploy-www.sh` /
  the Caddy static config), confirming post-login that the link appears and the
  page renders correctly.
- Deliver via a PR against `main`.

## Definition of done

An authenticated MCP-client setup page live behind the gate, linked from the
landing page, its instructions verified against the live client/metadata,
validated in production, and delivered as a PR against
`kriscendobot/minion.town` `main`.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 7
  claimed_at: 2026-07-10T06:56:11Z
