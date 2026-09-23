---
title: MCP portal connector and per-server grants
source: packages/gatekeeper-mcp-portal/README.md
source_repo: cloudflare/cloudflare-os
source_commit: 4fd43ffe37435637e818357035a50054bacba297
source_date: 2026-08-18
source_authors: [Dan Carter, Maximo Guk]
ingested: 2026-08-24
ingested_by: scholar
topics: [capability-mediated-integrations, cloudflare-workers-agent-hosting]
status: current
---

The MCP Server Portals Gatekeeper connects the deployment's own MCP portal as a capability: an administrator configures one URL, and a grant always names exactly one upstream server behind the portal, so no user ever types an endpoint and no grant spans the whole portal.

The intended deployment is a Cloudflare MCP server portal, where Access decides who may connect and Cloudflare Gateway logs and inspects what crosses; this connector turns what is behind it into typed capabilities that Gadgets can grant one server at a time. The backend auto-discovers it from its `GATEKEEPER_MCP_PORTAL` binding. There is one resource type, **MCP portal server**, at two grant breadths: **Server** (`<endpoint>#server=github`) grants every tool of one upstream server including later additions, and **Named tools** (`<endpoint>#server=github&tool=a&tool=b`) grants only the listed tools of that server. "Everything the portal offers" is deliberately not a breadth, since it would hand a Gadget every tool of every system the organization has connected in one click. The `<tag>` — four hex characters derived from the resource URL — matters most here, because two grants pinning different tools of one upstream server share both the name and the endpoint, so the scope is the only thing distinguishing them.

The session API is the same as the bring-your-own MCP connector: a typed method per described tool, plus `callTool`, `getActionResult`, and `listTools` with progressive search and name options. A server-wide grant can cover more tools than one catalog describes, so `listTools({ search })` searches beyond the bounded preview (up to 20 compact matches within the shared 5,000-tool / 4 MiB scan), `listTools({ name })` loads one exact bounded definition, and `callTool` resolves the name under the same bound before dispatch. Every path rejects names outside the binding's scope before loading the catalog or contacting the endpoint. Scoping to one server also shrinks what the agent reads: only that server's tools are rendered as signatures, and exceeding a scan limit fails rather than pretending a tool is absent. For endpoints a user supplies themselves, the bring-your-own MCP connector is used instead.

Source: [packages/gatekeeper-mcp-portal/README.md](https://github.com/cloudflare/cloudflare-os/blob/4fd43ffe37435637e818357035a50054bacba297/packages/gatekeeper-mcp-portal/README.md) at commit `4fd43ffe`.
