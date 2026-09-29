## Completion report: build-minion-town-mcp-garden2-workers

Every worker harness now attaches the minion.town MCP server on its own, and reconnects when the connection drops. It is live-proven on endolin-garden2 for claude and codex. The rollout is held to garden2 until you approve a principal, as the job asked. Commits `1f0cc8400b5`, `5cb95af0371` and `a253f3b736d` are on `main2`. **The new handlers and the watchdog timer are not yet running anywhere in the fleet**, garden2 included. garden2's deploy is waiting for in-flight jobs to finish, and this job is one of them; the next rolling deploy picks them up.

**How it works**
- **One shared connector for every harness** (`scripts/jobs/minion-mcp-bridge.py`). Each harness starts it as a local MCP server, and it forwards to `https://minion.town/mcp`. It fetches a fresh token for every request, because tokens last 1 hour and jobs can run almost 4. If the server rejects the token (401), it gets a new one and retries. If the server forgets the session (404), it reconnects and retries. If the server can't be reached, the pending tool call fails with an error instead of hanging.
- **Token cache** (`scripts/jobs/minion-mcp-token.sh`). Each host caches the token privately (0600 file under `$GARDEN_STATE/minion-mcp`). The client secret is read from Secrets Manager only when the token is refreshed; it is never written to disk or put on a command line. Concurrent workers share one refresh.
- **Attach step in every handler** (`scripts/jobs/minion-mcp-lib.sh`). It checks whether this host and job should attach, then fetches a token. If either fails, it logs one warning and the job runs without the tools; it never blocks a claim. It's wired into all harnesses:
  - monk and friar (`claude -p`, including the retry nudges and the pty lane);
  - cleric, fireworker, openrouter, openrouter-promo and the retired hermit (`codex exec`, settings passed on the command line, nothing written to `~/.codex`);
  - mystic (Kimi reads an `mcp.json` in the job's private home);
  - opencode (merged into its per-job config).
- **Per-host watchdog** (`minion-mcp-watchdog.sh`, `garden-minion-mcp-watchdog` timer every 10 minutes on every host, no LLM):
  - It fixes file permissions and discards a corrupt token cache.
  - It checks that it can get a token and list the server's tools through the same connector the workers use.
  - If that fails, it forces a new token and checks again.
  - It sends one notice when the connection is lost and one when it recovers, and writes a heartbeat file so a stopped timer is visible.
- **Fleet-wide switch.** The journal file `config/minion-mcp` holds `enabled`, `hosts` and `optout-hosts`. If the file is missing, every host attaches, so new hosts inherit it. It's edited with `scripts/jobs/set-minion-mcp.sh`. A host can opt out with `GARDEN_MINION_MCP=off`, and a job with the header `minion-mcp: off`. The file now says `hosts: endolin-garden2-5bcdff64`.
- **Docs.** The standing order is written up in `context/operations/minion-town-mcp.md`. It's linked from the operations README and `systemd-units.md`, and listed as a standing behavior in `roles/liaison/AGENT.md`.

**What was proven on garden2** (recording client id, scopes and tool names only, never a token)
- **Principal:** client `52ivub038n2dnvnk134s6vkqp1` (`minion-mcp-test-cc`), scope `mcp/guest mcp/tools`, token life 3600s.
- **Tools (16):** status, list, has, writeText, readText, remove, listMessages, send, dismiss, resolve, adopt, evaluate, publish, upgrade, listSites, unpublish.
- **Real handler runs:** I fed a small test job through `monk-claude.sh` and `cleric-codex.sh` from this commit. Each read the journal config, attached, listed all 16 tools, called `status` (34 pet names), and signalled completion. A direct `codex exec` run showed actual MCP tool-call events.
- **Token expiry mid-session:** a session that started with a bad token got a 401 from production, refreshed, and the call succeeded.
- **Watchdog, live against production:** healthy check, then a deliberately corrupted cache was repaired, then a blocked endpoint produced exactly one notice (`watchdog-minion-mcp-connection-endolin-garden2-5bcdff64`), a second failed check stayed silent, and unblocking produced the recovery update on that same notice.

**Tests**
- The new offline test `scripts/jobs/test/minion-mcp-test.sh` passes all 46 checks, using a fake login server and fake MCP server.
- `systemd-unit-doc-completeness-test` passes.
- These pass: `worker-spine-kinds`, `mystic-kimi-harness`, `fireworker-harness`, `openrouter-harness`, `opencode-anthropic-harness`, `codex-policy-refusal-resume`, `worker-local-bin-path`, `gardener-claude-tier-serving`, `provider-cooldown`, `enable-services`.
- Six handler tests fail: `gardener-worktree`, `monk-claude-tree-reap`, `kimi-opus-fallback`, `completion-signal`, `auction-reputation`, `flat-provider-censor`. They fail with the same counts on a clean origin/main2 checkout, so the failures predate this change.

**Known gaps**
- **mystic (kimi):** the harness starts the connector and lists the tools, but the Moonshot account returns "429 suspended: insufficient balance", so no model turn ran.
- **opencode:** wired up but unverified, because opencode isn't installed on garden2.
- **Other codex kinds** (fireworker, openrouter, hermit): same code path as cleric, but not run live because none run on garden2.
- **Interactive liaison sessions:** not attached automatically. The doc has the one-line command to attach by hand.
- **Panel juror seats and other nested `claude -p` calls:** not attached, since no worker handler launches them.
- **Codex quirk:** one early `codex exec` run answered "no MCP tools" even though the server had started. Reruns were fine; it looks like codex sometimes begins before the tools are listed.

**Decisions for you** (sent to your inbox)
1. **Principal:** every attached job acts as `minion-mcp-test-cc` on **production**, where it can change real guest state (writeText, remove, send, publish, evaluate). I propose a dedicated garden client, or a read-only scope. I created no Cognito clients and changed no scopes. Once approved, `set-minion-mcp.sh hosts '*'` rolls it out everywhere.
2. **Context cost:** the tool list is about 10.8 KB, roughly 2.5–3k tokens per session. Should jurors and myrmidon-tier roles get no tools, or a narrower set?
3. **AWS access on other hosts:** whether oros and endolin-garden can read `minion/test-cc-client` is unchecked. After the rollout widens, the watchdog will report any host that can't.

**Follow-ups:** wait for the rolling deploy to arm the timer and new handlers; widen the rollout once the principal is approved; top up the Moonshot balance, then re-check mystic.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-minion-town-mcp-garden2-workers.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 226 tokens (17453858 cached reads)
- Output: 92153 tokens
- Cost: $7.197183600000002
- Wall-clock: 2362s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
