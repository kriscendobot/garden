---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Connect the **worker fleet on host `endolin-garden2-5bcdff64`** (monks = `claude -p`, clerics = `codex exec`) to the **minion.town MCP server** at `https://minion.town/mcp`, so every job those workers run has the minion.town tools available. Land the garden-side changes direct to `main2` in `kriscendobot/garden`.

Maintainer ask (kriskowal, liaison session 2026-09-29): "I would like to connect this host's workers to the minion.town MCP."

Known facts (verify; don't trust blindly):
- Streamable-HTTP MCP, OAuth via Cognito pool `us-west-1_mDaTgjr1m` (us-west-1), AS `https://minion-town.auth.us-west-1.amazoncognito.com`, resource `https://minion.town/mcp`.
- A non-interactive path exists: the client-credentials client `minion-mcp-test-cc` (`52ivub038n2dnvnk134s6vkqp1`), secret in Secrets Manager `minion/test-cc-client` and readable with this host's `garden-fleet` AWS creds. The grant is `client_credentials` with scope `mcp/tools mcp/guest` at `/oauth2/token`. The interactive PKCE path is `skills/minion-town-mcp-playwright-login/SKILL.md`, which isn't usable unattended.
- Cognito access tokens are short-lived, so workers need **automatic refresh**, not a pasted token. Claude Code's MCP config supports a dynamic-headers helper. Codex supports `bearer_token_env_var`. Pick mechanisms that refresh without the worker ever seeing the client secret, and cache the token host-locally with 0600 permissions under `$GARDEN_STATE`, never in the repo or journal.

Deliverables:
1. The MCP server wired into the monk and cleric handler launch paths (`scripts/jobs/monk-claude.sh`, `scripts/jobs/cleric-codex.sh`, and whatever builds their `--mcp-config` / codex config). Make it **host-gated and opt-in**: enabled per host by a host-local switch (or a journal per-host config, if that fits existing patterns better) and turned on only for `endolin-garden2-5bcdff64`. Other hosts see no change.
2. A token helper script under `scripts/jobs/` that does the fetch, cache and refresh. It fails soft: if minion.town or Cognito is down, the worker starts without the server and logs one warning. It must never block claiming.
3. Proof: on this host, a real monk and a real cleric job each list the minion.town tools and make one read-only call (for example `guest_status`). Record identity, scopes and tool names only, never a token.
4. A short `context/operations/` page covering how to enable it on another host and how to turn it off.

Surface to the maintainer rather than deciding alone:
- Workers will act as the **test CC client's principal on production minion.town**, which can mutate real daemon guest state. Would the maintainer prefer a dedicated garden client/principal, or a read-only scope? Propose one, and don't create Cognito clients or change scopes without approval.
- Token/tool-context cost per job, if the tool list is large.
