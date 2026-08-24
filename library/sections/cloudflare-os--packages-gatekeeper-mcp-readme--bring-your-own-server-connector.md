---
title: Bring-your-own MCP server connector
source: packages/gatekeeper-mcp/README.md
source_repo: cloudflare/cloudflare-os
source_commit: bd0aa2dcde02008bb6170341fe2c574fd3ace275
source_date: 2026-08-18
source_authors: [Dan Carter, Maximo Guk]
ingested: 2026-08-24
ingested_by: scholar
topics: [capability-mediated-integrations, cloudflare-workers-agent-hosting]
status: current
---

The MCP Gatekeeper connects any user-supplied Model Context Protocol server as a Gadgets capability: one Worker covers every server, and each of the server's tools becomes a typed method on the session, so a server needs no Gadgets-specific work to be usable.

The user pastes an endpoint URL, the gatekeeper runs the OAuth discovery chain against it, and the backend auto-discovers the connector from its `GATEKEEPER_MCP` binding. There is one resource type, **Any MCP server**, at two grant breadths: **Server** (`<endpoint>`) grants every tool the endpoint offers including ones it adds later; **Named tools** (`<endpoint>#tool=a&tool=b`) grants only the listed tools and refuses anything else. A `#server=` fragment is refused here — scoping to one server behind a portal is the MCP Server Portals connector's grammar; `@gadgets/mcp-shared/scope` owns the grammar and the enforcement.

The session type is `Mcp<Name><tag>Session`, where `<Name>` comes from the endpoint's host (for reading, not identity — `acme.com` and `acme.io` both give `Acme`) and `<tag>` is four hex characters derived from the resource URL, so two grants that differ in what they may call get different type names. The session carries a named method per tool generated from the server's own `inputSchema`; each generated method is a one-line delegate to `callTool`, keeping the scope check, approval queue, and observation record in one place. Tools whose names the RPC layer cannot deliver (`then`, `map`, `dup`), names that collide with session methods (`listTools`, `callTool`, `getActionResult`), non-identifier names (`2fa`), and both sides of a case collision get no method and remain callable through `callTool`. The agent normally discovers tools statically through `describeGatekeeper()`; a server that publishes more than the bounded catalog holds is reachable through `listTools({ search })` (up to 20 compact summaries within a 5,000-tool / 4 MiB scan) and `listTools({ name })` (one exact granted definition).

Source: [packages/gatekeeper-mcp/README.md](https://github.com/cloudflare/cloudflare-os/blob/bd0aa2dcde02008bb6170341fe2c574fd3ace275/packages/gatekeeper-mcp/README.md) at commit `bd0aa2dc`.
