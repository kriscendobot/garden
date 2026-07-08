---
title: Symphony Service Specification — the Codex App Server agent-runner protocol
source_kind: web
source_url: https://openai.com/index/open-source-codex-orchestration-symphony/
source_snapshot: http://web.archive.org/web/2id_/https://openai.com/index/open-source-codex-orchestration-symphony/
source_content_sha256: b7c17d55f4faf42eb09282c0670a14dce360f83a5fe205834b5bbe09a7695c09
source_authors: [Alex Kotliarskyi, Victor Zhu, Zach Brock]
source_date: 2026-04-27
retrieved: 2026-07-08
ingested: 2026-07-08
ingested_by: scholar
topics: [agent-fleet-orchestration]
status: current
---

Abstract: The agent-runner protocol (§10) — the language-neutral contract for integrating a coding-agent **app-server** (Codex App Server) over a JSON-RPC-like, line-delimited stdio protocol. The normative contract is message ordering, required behaviors, and the logical fields to extract (session IDs, completion state, approval handling, token/rate-limit telemetry); exact JSON field names may vary across compatible versions. The subprocess is launched via `bash -lc <codex.command>` with the workspace as cwd; the startup handshake is `initialize` → `initialized` → `thread/start` → `turn/start`, with `session_id = <thread_id>-<turn_id>` and the same thread reused for continuation turns. Turns stream until `turn/completed` (success) or `turn/failed`/`turn/cancelled`/timeout/subprocess-exit (failure). Approval, sandbox, and user-input policy are implementation-defined but must never leave a run stalled indefinitely; an optional `linear_graphql` **dynamic client-side tool** lets the agent query Linear through Symphony's configured auth without ever seeing the raw token.

## Compatibility profile and launch contract (§10.1)

The normative contract is message ordering, required behaviors, and the logical fields that must be extracted (session IDs, completion state, approval handling, usage/rate-limit telemetry). Exact JSON field names may vary slightly across compatible app-server versions; implementations should tolerate equivalent payload shapes carrying the same meaning.

Launch: command `codex.command`, invoked as `bash -lc <codex.command>`, working directory = the workspace path, stdout/stderr as separate streams, framing = line-delimited protocol messages on stdout (JSON-RPC-like JSON per line). Default command `codex app-server`. Recommended max line size 10 MB for safe buffering.

## Session startup handshake (§10.2)

The client sends, in order: (1) an `initialize` request (`clientInfo`, `capabilities`; wait for response within `read_timeout_ms`); (2) an `initialized` notification; (3) a `thread/start` request (`approvalPolicy`, `sandbox`, `cwd` = absolute workspace path; advertise any optional client-side tools here); (4) a `turn/start` request (`threadId`; `input` = a single text item with the rendered prompt for the first turn or continuation guidance for later turns; `cwd`; `title` = `<issue.identifier>: <issue.title>`; `approvalPolicy`; `sandboxPolicy` object when required).

Session identifiers: read `thread_id` from `thread/start` result `result.thread.id`; read `turn_id` from each `turn/start` result `result.turn.id`; emit `session_id = "<thread_id>-<turn_id>"`; **reuse the same `thread_id` for all continuation turns** inside one worker run.

## Streaming, events, and policy (§10.3–§10.5)

Read line-delimited messages until the turn terminates. Completion: `turn/completed` → success; `turn/failed` / `turn/cancelled` / turn timeout / subprocess exit → failure. Continuation: to continue after a successful turn, issue another `turn/start` on the same live `threadId`; the subprocess stays alive across continuation turns and is stopped only when the run ends. Read protocol messages from stdout only, buffer partial lines until newline, JSON-parse complete lines; **stderr is not part of the protocol stream** (log/ignore it, never JSON-parse it).

Emitted runtime events (upstream to the orchestrator) each include `event`, `timestamp`, `codex_app_server_pid`, an optional `usage` token map, and payload fields; notable events: `session_started`, `startup_failed`, `turn_completed`, `turn_failed`, `turn_cancelled`, `turn_ended_with_error`, `turn_input_required`, `approval_auto_approved`, `unsupported_tool_call`, `notification`, `other_message`, `malformed`.

**Approval / tool / user-input policy is implementation-defined**, but each implementation must document its posture and must not let a run stall indefinitely on an approval or a user-input-required event (satisfy it, surface it, auto-resolve it, or fail the run per documented policy). Example high-trust behavior: auto-approve command-execution and file-change approvals for the session, and treat user-input-required turns as a hard failure. Unsupported dynamic tool calls (`item/tool/call`) return a tool failure and continue the session (preventing a stall). If the agent requests user input (`item/tool/requestUserInput`, or turn flags indicating input required), fail the run attempt immediately.

**Optional `linear_graphql` client-side tool.** An implementation may expose a limited set of client-side tools; the current standardized one is `linear_graphql` — execute a raw GraphQL query or mutation against Linear using Symphony's configured tracker auth for the current session (meaningful only when `tracker.kind == "linear"`). Preferred input is `{query, variables?}`; `query` must be a non-empty string containing exactly one operation; execute one operation per call and reject multi-operation documents. It reuses the configured Linear endpoint and auth so the agent never reads raw tokens from disk. Result semantics: transport success with no top-level GraphQL `errors` → `success=true`; GraphQL `errors` present → `success=false` (preserve the body); invalid input / missing auth / transport failure → `success=false` with an error payload.

## Timeouts, error mapping, and the runner contract (§10.6–§10.7)

Timeouts: `codex.read_timeout_ms` (startup/sync request-response), `codex.turn_timeout_ms` (total turn stream), `codex.stall_timeout_ms` (event-inactivity, enforced by the orchestrator). Recommended normalized error categories: `codex_not_found`, `invalid_workspace_cwd`, `response_timeout`, `turn_timeout`, `port_exit`, `response_error`, `turn_failed`, `turn_cancelled`, `turn_input_required`. The `Agent Runner` wraps workspace + prompt + app-server client: create/reuse the workspace, build the prompt, start the session, forward events to the orchestrator, and on any error fail the worker attempt (the orchestrator retries). Workspaces are intentionally preserved after successful runs.

> The `linear_graphql`-not-MCP move — expose a narrow raw-GraphQL capability wired to the service's own auth rather than handing subagents the token — is a least-authority pattern the garden already practises: its `gh` wrapper pins every call to the bot identity and refuses to widen without an explicit per-call override, so a gardener never holds raw upstream credentials. Both keep the powerful credential at the orchestrator and pass the agent only a scoped capability.

Source: [An open-source spec for Codex orchestration: Symphony](https://openai.com/index/open-source-codex-orchestration-symphony/) — OpenAI, 2026-04-27. Captured via the Internet Archive (`source_fetched_via=wayback`); content SHA-256 `b7c17d55`.
