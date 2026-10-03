---
created: 2026-09-29
updated: 2026-09-29
author: gardener
---

# minion.town MCP — the standing connection

**Standing order (kriskowal, liaison session 2026-09-29):** keep **every inference
source in the garden automatically connected to the minion.town MCP server**
(`https://minion.town/mcp`), on **every host**, and **reconnect automatically**
whenever a connection is lost. Job `build-minion-town-mcp-garden2-workers` built
it. Later sessions keep it armed. The liaison lists it among its standing behaviors
([`roles/liaison/AGENT.md`](../../roles/liaison/AGENT.md)).

**Current rollout scope: `endolin-garden2-5bcdff64` only.** Every job acts as the
test client-credentials principal (`minion-mcp-test-cc`) on **production**
minion.town, and that principal can mutate real daemon guest state. So the fleet
stays scoped to the proving host until the maintainer approves a dedicated garden
principal or a read-only scope (§ Open decisions). Widening is one command:
`scripts/jobs/set-minion-mcp.sh hosts '*'`.

## How it works

| Piece | File | Role |
| --- | --- | --- |
| Token cache | `scripts/jobs/minion-mcp-token.sh` | OAuth `client_credentials` grant at the Cognito token endpoint, scope `mcp/tools mcp/guest`. It caches the token host-locally in `$GARDEN_STATE/minion-mcp/token.json` (0600, dir 0700) and refreshes 600s before expiry under a flock. The client secret comes from Secrets Manager `minion/test-cc-client` (us-west-1) at refresh time. It is never written to disk and never put in argv. |
| Stdio bridge | `scripts/jobs/minion-mcp-bridge.py` | The MCP server every harness spawns. It relays JSON-RPC to the streamable-HTTP endpoint and asks the token cache for a bearer **per request**. On a 401 it refreshes the token and retries. On a 404 for a lost session it replays `initialize` and retries. On a transport failure it returns a JSON-RPC error, so the pending call fails instead of hanging. `--probe` is the health check. |
| Attach lib | `scripts/jobs/minion-mcp-lib.sh` | Sourced by every handler. It holds the gate, a token preflight, and the per-harness config shapes. It is **fail-open**: a closed gate or a failed preflight logs one line and the job starts without the server. It never blocks a claim. |
| Watchdog | `scripts/jobs/minion-mcp-watchdog.sh` + `garden-minion-mcp-watchdog.{service,timer}` | Runs on **every host** every 10 minutes (`*:04/10`, not leader-gated) and uses no LLM. See § The watchdog. |
| Switch | `scripts/jobs/set-minion-mcp.sh` | Edits the fleet-wide journal config and reports this host's verdict and heartbeat. |

**Why a bridge, not each harness's native remote-MCP auth.** Cognito access tokens
live **3600s**, and handler budgets reach **14339s**. Codex's
`bearer_token_env_var` is read once at startup. A Claude Code `headersHelper` runs
when the harness connects. Kimi Code has no dynamic-auth hook at all. So a
fetch-at-connect token can die mid-job. A per-request bridge gives every harness the
same transparent refresh, and the harness process never holds the client secret.

## Coverage by inference source

| Worker kind(s) | Harness | How it attaches | Status (2026-09-29) |
| --- | --- | --- | --- |
| monk, friar | `claude -p` (`handlers/monk-claude.sh`) | `--mcp-config <json>` stdio server. It covers the headless path, the completion nudges, and the opt-in pty lane. | **Proven** on garden2: listed all 16 tools and called `status`. |
| cleric, fireworker, openrouter, openrouter-promo, (hermit, retired) | `codex exec` (`handlers/cleric-codex.sh`) | One complete inline-table override, `-c mcp_servers.minion-town={command,args,env,…}`; nothing is persisted to `~/.codex`. codex (verified 0.156.0) deep-merges `-c` into a persisted table even when the override is a whole table, so if the host's codex config (or the worktree's `.codex/config.toml`) already declares `minion-town` (for example a `url` entry from an interactive `codex mcp add`), the handler disables that entry and attaches the bridge as `minion-town-garden`. Without this, the merged url+command table fails config load and every cleric job dies at startup, as happened on 2026-10-03. | **Proven** on garden2 (cleric): `mcp_tool_call` for `status`. The other codex kinds share the code path but were not run live: no fireworker, openrouter or hermit units run on garden2. |
| mystic | Kimi Code (`handlers/mystic-kimi.sh`) | Writes `mcp.json` into the job's private `KIMI_CODE_HOME`, because Kimi has no CLI flag for MCP. | **Harness proven, model turn not.** Kimi spawned the bridge and completed `initialize` and `tools/list`. The Moonshot account returned *429 suspended: insufficient balance*, so no model turn ran. |
| opencode-anthropic | OpenCode (`handlers/opencode.sh`) | Merges a `local` MCP server into `OPENCODE_CONFIG_CONTENT`. | **Unverified.** OpenCode is not installed on garden2. |
| manual mentat (`post-manual-job.sh`) | the claimed kind's handler | Inherits the handler attach. | Covered by construction. |
| interactive liaison sessions | Claude Code, interactive | **Known gap: not automatic.** The container seeds no user MCP config (the bind mount masks `$HOME`), and adding one would give the liaison production write tools by default. To attach by hand, start the session with `claude --mcp-config "$(bash -c 'source scripts/jobs/common.sh; source scripts/jobs/minion-mcp-lib.sh; minion_mcp_claude_config')"`. | Documented, not armed. |
| panel juror seats and other nested `claude -p` | the nested CLI | **Not attached.** They are launched by `panel.sh` and friends, not by a worker handler. | Deliberate for now (§ Open decisions: narrower tool sets). |

## The gate and the fleet-wide config

The first matching rule wins (`minion_mcp_enabled_here`):

1. Env `GARDEN_MINION_MCP=off` opts the host out. `=on` forces the connection on
   and skips the journal check (manual proofs).
2. `GARDEN_TEST=1` with the env unset turns it off, so tests never reach production.
3. A job header `minion-mcp: off` opts out that one job.
4. The journal file `config/minion-mcp` decides:
   ```
   enabled: true            # fleet-wide switch
   hosts: endolin-garden2-5bcdff64   # or * (the default)
   optout-hosts:            # excluded even when hosts matches
   ```
5. **If the file is absent, the connection is ON.** The standing order is
   default-on, so a newly stood-up host inherits it without a hand edit.

The handlers read the config from the worker's synced journal clone
(`GARDEN_WORKER_CLONE`). The watchdog reads it from the host's journal worktree.
To change it:

```sh
scripts/jobs/set-minion-mcp.sh status            # committed config + this host's verdict + heartbeat
scripts/jobs/set-minion-mcp.sh hosts '*'         # roll out fleet-wide
scripts/jobs/set-minion-mcp.sh optout <GARDEN>   # exclude a host
scripts/jobs/set-minion-mcp.sh off               # fleet-wide kill switch
```

## Reconnection, layer by layer

1. **Per job.** Every handler launch runs the gate and then a token preflight
   (`minion-mcp-token.sh token`, 60s cap). If the preflight succeeds, the harness
   gets the server. If it fails, the log gets one `WARN minion-mcp:` line and the
   job runs without the server.
2. **Mid-session.** The bridge keeps a token in memory until 120s before its JWT
   `exp` and then asks the cache again. The cache refreshes 600s before expiry. A
   401 forces a fresh grant and a retry. A server restart that forgets the session
   (404) makes the bridge replay `initialize` and retry. The harness sees none of
   this.
3. **Host watchdog.** See the next section.
4. **Durable default.** The fleet-wide journal config plus default-on-when-absent.
   `install-units.sh` discovers the timer the same way it discovers the other
   `garden-*.timer` units, so a deploy arms it on every host.

## The watchdog

Each tick of `minion-mcp-watchdog.sh`:

1. Applies the same gate. If the gate is closed, the tick writes a `disabled`
   heartbeat, closes any open alert, and stops.
2. Repairs drift: it re-asserts 0700 on the cache directory and 0600 on the token
   file, and discards a corrupt cache.
3. Probes token acquisition plus MCP `initialize` and `tools/list` through the same
   bridge the workers spawn.
4. On failure, forces a fresh token grant and probes again.
5. Alerts through `watchdog-notice.sh` with key `minion-mcp-connection-<GARDEN>`,
   **edge-latched**: one LOST notice on the first failed tick, silence while the
   connection stays down, and one `--recovered` close-out on the first passing
   tick.
6. Writes a heartbeat to `$GARDEN_STATE/minion-mcp/heartbeat.json` with `at`,
   `state` (`ok`, `down` or `disabled`), `tools`, `detail` and `down_since`. A stale
   `at` means the timer itself stopped.

The tick exits 0 even when the connection is down. The notice is the alert, so the
unit never trips self-heal.

### When the watchdog alerts

- `credential read failed`: this host's AWS credentials cannot read
  `minion/test-cc-client`. Check `aws sts get-caller-identity` and the IAM grant.
  (endolin hosts use `garden-fleet`. Access from oros is **unverified**, see below.)
- `token request failed: invalid_client` / `invalid_scope`: the Cognito client or
  its scopes changed.
- `HTTP 5xx` / `POST … failed`: minion.town is down. See the minion.town repo's
  `DEPLOYMENT.md` for the service topology.
  Jobs keep running without the tools. The watchdog posts the recovery notice by
  itself.
- To force an immediate re-probe:
  `systemctl --user start garden-minion-mcp-watchdog.service`.

## Proof record (endolin-garden2-5bcdff64, 2026-09-29)

These runs record identity, scopes and tool names only, never a token.

- **Principal.** `client_id`/`sub` `52ivub038n2dnvnk134s6vkqp1`
  (`minion-mcp-test-cc`), scope `mcp/guest mcp/tools`, `expires_in` 3600. Server:
  `minion-town` 0.1.0, protocol `2025-06-18`. Tools (16): `status`, `list`,
  `has`, `writeText`, `readText`, `remove`, `listMessages`, `send`, `dismiss`,
  `resolve`, `adopt`, `evaluate`, `publish`, `upgrade`, `listSites`,
  `unpublish`. None carries `readOnlyHint`.
- **Real handler runs.** A synthetic job went through the real handler scripts,
  with the gate reading the journal config (not forced on):
  - `monk-claude.sh` (claude -p) and `cleric-codex.sh` (codex exec) each listed
    all 16 tools, called `status` (34 pet names), and wrote the completion
    sentinel.
  - `mystic-kimi.sh` attached the server, but the Moonshot model call failed on
    the account balance.
  - A direct `codex exec` run showed `mcp_tool_call` events for `status`.
  - The fleet itself could not run the new code during the build: the deploy was
    deferred behind the in-flight build job.
- **Live mid-session refresh.** A bridge session was fed a bogus bearer first. It
  got a 401 from production, refreshed the token, and the `status` call succeeded.
- **Live watchdog.** The run went through five steps:
  1. A healthy tick recorded `ok`/16.
  2. A corrupted token cache was repaired (0600 re-asserted) and the tick stayed
     `ok`.
  3. The blocked endpoint produced heartbeat `down` and ONE maintainer notice,
     `watchdog-minion-mcp-connection-endolin-garden2-5bcdff64`.
  4. A second blocked tick posted no notice.
  5. The restored endpoint produced `ok`/16 and amended the notice as recovered.

## Guard test

`scripts/jobs/test/minion-mcp-test.sh` is hermetic. A fake Cognito endpoint and a
fake MCP server stand in for production (`test/minion-mcp-fake-server.py`). The
test covers:

- cache hits, forced and near-expiry refreshes, and file modes;
- that no token appears in `status` output;
- the bridge's 401 refresh, 404 re-initialize and server-down error paths;
- every gate rule;
- the fail-open preflight;
- the per-harness config shapes;
- the watchdog's drift repair, edge-latched LOST and RECOVERED notices, and
  `disabled` heartbeat.

## Open decisions (surfaced to the maintainer 2026-09-29)

1. **The principal.** All jobs share `minion-mcp-test-cc`, a production principal
   whose guest carries real state and whose tools include `writeText`, `remove`,
   `send`, `publish` and `evaluate`. The proposal is a dedicated garden
   client/principal (its own guest), or a read-only scope, if minion.town's
   resource server grows one. No Cognito client or scope was created or changed.
2. **Context cost.** `tools/list` is about 10.8 KB of JSON, roughly 2.5–3k tokens,
   and it is loaded into each attached session. The question is whether juror seats
   and cheap `myrmidon`-tier roles should get no tools or a narrower set. A
   per-role narrowing would hook into `minion_mcp_enabled_here` (by role) or into
   Codex `enabled_tools` and Claude `--allowedTools`.
3. **Other hosts' AWS access.** `oros-studio-garden-ce242c49` and
   `endolin-garden-ece02cb4` have not been checked for read access to the secret.
   Once the rollout widens, the watchdog reports any host that lacks it.
