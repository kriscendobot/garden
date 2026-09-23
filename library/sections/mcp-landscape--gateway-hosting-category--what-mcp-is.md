---
title: What MCP is
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

MCP uses a client-server architecture. An MCP host (Claude Desktop, Cursor, VS Code with Copilot, and others) creates one MCP client per server. Local servers use the STDIO transport; remote servers use Streamable HTTP transport (OAuth-authenticated bearer tokens, API keys, or custom headers). The protocol's three server-side primitives are **tools** (executable functions), **resources** (data sources), and **prompts** (interaction templates).

The protocol specification is maintained by Anthropic at https://modelcontextprotocol.io. The TypeScript SDK (`@modelcontextprotocol/sdk`, v1.29.0 as of early 2026) is the reference implementation. The spec and SDK are MIT-licensed.

Source: [modelcontextprotocol.io](https://modelcontextprotocol.io/) and named sources in `notes:` frontmatter. Retrieval date: 2026-06-11.
