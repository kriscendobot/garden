---
role: builder
tier: mentor
---
**STANDING ORDER (expanded scope — supersedes the original single-host ask).** Keep **every inference source in the garden automatically connected to the minion.town MCP server** (`https://minion.town/mcp`), on **every host**, and **automatically reconnect** whenever a connection is lost. Land garden-side changes direct to `main2` in `kriscendobot/garden`.

Maintainer asks (kriskowal, liaison session 2026-09-29): first "I would like to connect this host's workers to the minion.town MCP," then "Let's expand that to a standing order to keep all inference sources automatically connected to minion.town, to automatically reconnect if we lose a connection."

**Scope: all inference sources.** Every worker kind's handler: monks (`claude -p`), clerics (`codex exec`), and the mystic, kimi, fireworker, hermit and openrouter kinds (see `set-*.sh` / the handler scripts). That includes local-model workers where the harness supports MCP. Also cover the manual mentat path and interactive liaison sessions if feasible. Where a harness can't speak MCP, record that explicitly as a known gap in the docs and completion report; don't drop it silently. Start with `endolin-garden2-5bcdff64` as the proving host, then roll out to all hosts.

Known facts (verify; don't trust blindly):
- Streamable-HTTP MCP, OAuth via Cognito pool `us-west-1_mDaTgjr1m` (us-west-1), AS `https://minion-town.auth.us-west-1.amazoncognito.com`, resource `https://minion.town/mcp`.
- Non-interactive path: the client-credentials client `minion-mcp-test-cc` (`52ivub038n2dnvnk134s6vkqp1`), secret in Secrets Manager `minion/test-cc-client` (readable with `garden-fleet` AWS creds on endolin hosts; check whether other hosts, for example oros, have access, and surface it if not). The grant is `client_credentials` with scope `mcp/tools mcp/guest` at `/oauth2/token`. The interactive PKCE path is `skills/minion-town-mcp-playwright-login/SKILL.md`, which isn't usable unattended.
- Cognito access tokens are short-lived. Use harness-native dynamic-auth hooks (Claude Code MCP headers helper; Codex `bearer_token_env_var`; equivalents for other harnesses) so the worker never sees the client secret. Cache tokens host-locally with 0600 permissions under `$GARDEN_STATE`, never in the repo or journal.

**Automatic reconnection (the standing part):**
1. **Per job:** each handler launch obtains a fresh or valid token and attaches the server. If attaching fails, the job still starts, one warning is logged, and claiming is never blocked.
2. **Mid-session:** a token that expires during a long job must refresh transparently (a helper-per-request, or a refresh margin longer than the handler budget; handler budgets reach 14339s).
3. **Host watchdog:** a deterministic, no-LLM per-host check (a systemd timer, or fold it into an existing per-host tick; don't add a leader-only singleton, because this is per-host) probes token acquisition plus an MCP `initialize` / `tools/list`. It refreshes the cache and repairs config drift on failure. It alerts through `watchdog-notice.sh`, edge-latched (one notice on loss, one on recovery), and records a heartbeat so staleness is visible.
4. **Durable default:** the connection is enabled by default fleet-wide (journal config, not per-host hand edits) with an explicit opt-out, so a newly stood-up host inherits it. Document it as a standing order in `context/operations/` (and reference it from `roles/liaison/AGENT.md` standing behaviors) so later sessions keep it armed.

**Proof:** on `endolin-garden2`, a real job from each available worker kind lists the minion.town tools and makes one read-only call (for example `guest_status`). Then simulate a lost connection (invalidate the cached token, or block the endpoint briefly) and show the watchdog alerting and recovering. Record identity, scopes and tool names only, never a token. Add a guard test for the helper and watchdog logic.

**Surface to the maintainer rather than deciding alone:**
- Every job in the fleet would act as the test CC client's principal on **production** minion.town, which can mutate real daemon guest state. Propose a dedicated garden client/principal or a read-only scope. Don't create Cognito clients or change scopes without approval; until approved, prove it on garden2 only.
- The per-job token/context cost of the tool list, and whether some roles (jurors, cheap myrmidon-tier jobs) should get a narrower tool set.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-29T00:40:12Z
