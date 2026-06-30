---
title: "LangChain tools: dynamic selection, headless, and prebuilt tools"
source_kind: web
source_url: https://docs.langchain.com/oss/python/langchain/tools
source_content_sha256: a40a0dad0d7db34773b41d18074eec8e6f33c66305ab16b346e6df3679c10174
source_authors: [LangChain Inc.]
source_date: 2026-06-30
retrieved: 2026-06-30
ingested: 2026-06-30
ingested_by: scholar
topics: [llm-agent-frameworks, agent-conventions]
status: current
notes: "Living vendor docs (docs.langchain.com, Mintlify). Idempotency anchor is source_content_sha256 over the page's `.md` rendering, not a git SHA. Re-fetch the `.md` form to re-check freshness."
---

Abstract: Three ways the available toolset is shaped beyond a static list. **Dynamic tool selection** modifies the agent's available tools at runtime rather than fixing them all upfront — because too many tools overload context and increase errors while too few limit capability, you adapt the set by authentication state, permissions, feature flags, or conversation stage; the two approaches differ on whether tools are known at startup (filter a known set) or discovered at runtime (from an MCP server, generated from user data, or an external registry). **Headless tools** run *where the user's app runs* (typically the browser), not in the server process: a schema-only tool (name, description, args) is registered on the server so the model can call it normally, but invoking it **interrupts** the run with a `{"type": "tool", "tool_call": {...}}` payload, the client implementation performs the action (browser APIs, on-device/private data, low-latency local effects), and the graph **resumes** with the result — distinct from server-side provider tools. **Prebuilt tools** are LangChain's ready-to-use tools and toolkits (web search, code interpretation, database access) usable without custom code.

## Dynamic tool selection

With dynamic tools, the set available to the agent is modified at runtime rather than defined all upfront. Not every tool is appropriate for every situation: too many tools may overwhelm the model (overload context) and increase errors; too few limit capabilities. Dynamic selection adapts the toolset based on authentication state, user permissions, feature flags, or conversation stage. Two approaches, depending on whether tools are known ahead of time:

- **Known at compile/startup time** — all possible tools are known; filter based on permissions, feature flags, or conversation state. Tools are static but their availability is dynamic.
- **Discovered at runtime** — tools come from an MCP server, are generated from user data or configuration, or come from an external tool registry.

## Headless tools

Some tools should run **where the user's app runs** (typically the browser), not inside the process. **Headless tools** are tool definitions — name, description, and argument schema — registered on the **server** with the agent; the **implementation** is registered only on the **client** and executed after a short interrupt/resume handshake. This differs from ordinary tools whose body runs on the server, and from server-side tool use where the provider executes built-in tools remotely.

Use headless tools when the work depends on the **environment, device, or UI** that only exists on the client: browser APIs (geolocation, IndexedDB, clipboard, canvas, file pickers), privacy/locality (data stays on device), latency (no extra server round trip), and structured/safe effects (many small typed tools rather than sending arbitrary code to `eval`).

How the pattern works:

1. **Define** a headless tool with `tool(name=..., description=..., args_schema=...)` — schema-only, no in-process implementation.
2. **Register** it with `create_agent` or your graph so the model can call it normally.
3. **Handle** the interrupt payload when the tool is invoked: instead of running locally, the graph pauses with a payload shaped like `{"type": "tool", "tool_call": {"id", "name", "args"}}`.
4. **Resume** the graph after the app, another service, or a human step performs the action. For browser flows, mirror the schema in the frontend and attach `.implement(...)` there.

When the model issues a tool call for such a tool, the run **interrupts** instead of executing locally; the app inspects the payload, performs the action in the right environment, then resumes the graph with the result. The supported JS SDK hooks can detect headless-tool interrupts, run the matching client implementation, and submit the resume command automatically; an optional `onTool` callback observes lifecycle events (`start`, `success`, `error`) for UI feedback.

## Prebuilt tools and server-side tool use

LangChain provides a large collection of prebuilt tools and toolkits for common tasks (web search, code interpretation, database access) usable directly without custom code. Separately, some chat models feature built-in tools executed server-side by the provider (web search, code interpreters) that need no tool logic defined or hosted.

Source: [LangChain tools](https://docs.langchain.com/oss/python/langchain/tools) retrieved 2026-06-30, content hash `a40a0dad`.
