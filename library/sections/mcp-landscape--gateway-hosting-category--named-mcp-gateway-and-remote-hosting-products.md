---
title: Named MCP gateway and remote-hosting products
source_kind: web-survey
source_url: https://modelcontextprotocol.io/
source_date: 2026-06-11
ingested: 2026-06-11
ingested_by: scholar
topics: [capability-security, agent-conventions]
status: current
notes: |
  Synthesized from: MCP spec architecture docs (modelcontextprotocol.io/docs/concepts/architecture),
  MCP security best-practices spec (modelcontextprotocol.io/specification/draft/basic/security_best_practices),
  Anthropic MCP announcement (anthropic.com/news/model-context-protocol, 2024-11-25),
  Cloudflare remote MCP guide (developers.cloudflare.com/agents/guides/remote-mcp-server/),
  MCP SDK npm package (registry.npmjs.org/@modelcontextprotocol/sdk, version 1.29.0),
  MCP servers repository (github.com/modelcontextprotocol/servers, 87k+ stars as of Jan 2026),
  MCP safety audit paper (arxiv.org/abs/2504.03767, Radosevich/Halloran, April 2025).
  No single authoritative "MCP gateway market size" source exists; this section records
  named products with URLs and structural claims with sourced evidence. No invented metrics.
parent: mcp-landscape--gateway-hosting-category
---

### Cloudflare Workers (remote MCP hosting)

Cloudflare enables hosting MCP servers on its Workers platform using Streamable HTTP transport. Two access models:

- **Public**: no authentication required; anyone can connect.
- **Authenticated**: users sign in via Cloudflare Access or third-party OAuth (GitHub, Google, Slack); per-user permission scoping controls which tools a given agent can call.

Three implementation paths: `createMcpHandler()` (stateless tools), `McpAgent` (stateful per-session tools using Durable Objects), or raw `WebStandardStreamableHTTPServerTransport`. Deployment via dashboard one-click or CLI. Source: https://developers.cloudflare.com/agents/guides/remote-mcp-server/

Cloudflare positions this as infrastructure for its global agent-hosting platform ("deploy once and Cloudflare runs your agents across its global network, scaling to tens of millions of instances"). MCP tools are one of several available capabilities alongside browser automation, sandboxed code execution, AI search, and payment processing.

### Sentry (official remote MCP server)

The official Sentry MCP server (https://docs.sentry.io/product/sentry-mcp/) runs on the Sentry platform using Streamable HTTP transport. It is cited in the MCP architecture documentation as the canonical example of a remote MCP server. Sentry's server is vendor-operated infrastructure exposing Sentry's error-tracking tools to MCP clients.

### AWS Marketplace (anticipated)

The MCP ecosystem includes packaged AMI / container products targeting cloud marketplace listing. The Workstream A scout dispatch (journal/entries/2026/06/11/023407Z-result-liaison-52675e.md) notes that AWS Marketplace listing is an explicit gap in the endo-gateway roadmap; no named Endo-specific offering exists yet, but the category is anticipated.

Source: [modelcontextprotocol.io](https://modelcontextprotocol.io/) and named sources in `notes:` frontmatter. Retrieval date: 2026-06-11.
