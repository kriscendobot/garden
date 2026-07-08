---
id: codex-app-server
aliases: ["Codex App Server", "codex app-server", "app server mode", "app-server mode", "coding-agent app-server", "headless Codex", "codex JSON-RPC", "thread/start", "turn/start", "linear_graphql tool"]
topics: [agent-fleet-orchestration]
status: current
---

# codex-app-server

**Codex App Server** is Codex's built-in headless mode: it runs a coding-agent process you talk to programmatically over a **JSON-RPC-like, line-delimited stdio protocol** (start a thread, start turns, react to streamed events), instead of driving Codex through a CLI or a live tmux session. It is the execution substrate Symphony builds on — launched via `bash -lc <command>` with the per-issue workspace as cwd, framed as one JSON message per stdout line. The startup handshake is `initialize` → `initialized` → `thread/start` → `turn/start`; a session id is `<thread_id>-<turn_id>`, and the same `thread_id` is reused for continuation turns. Turns stream until `turn/completed` (success) or `turn/failed`/`turn/cancelled`/timeout/exit (failure). Approval, sandbox, and user-input policy are pass-through and implementation-defined; unsupported dynamic tool calls return a failure and continue the session. An optional **`linear_graphql`** client-side dynamic tool lets the agent run raw GraphQL against Linear through the service's configured auth, so the raw token is never exposed to subagents or containers — a least-authority alternative to an MCP integration.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [SPEC §10 Codex App Server agent-runner protocol](../sections/web--openai-symphony-codex-orchestration--spec-agent-runner-protocol.md) | The JSON-RPC-over-stdio handshake, streaming turns, approval policy, and the linear_graphql dynamic tool. |
| [spec-driven dogfooding](../sections/web--openai-symphony-codex-orchestration--spec-driven-dogfooding.md) | Why the team used Codex App Server (headless, programmatic) over CLI/tmux, and dynamic tool calls to hide the Linear token. |

## See also

- [[symphony-orchestrator]] — the orchestrator that drives Codex App Server.
- [[workflow-md-policy]] — supplies the rendered prompt sent in `turn/start`.
