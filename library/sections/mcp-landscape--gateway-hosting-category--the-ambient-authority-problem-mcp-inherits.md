---
title: The ambient-authority problem MCP inherits
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

The MCP security best-practices specification names a structural problem the protocol inherits from how OAuth bearer tokens are typically scoped: current MCP integrations tend to be **ambient-authority grants**. The spec's Scope Minimization section describes the failure mode:

> "An attacker obtains (via log leakage, memory scraping, or local interception) an access token carrying broad scopes (`files:*`, `db:*`, `admin:*`) that were granted up front because the MCP server exposed every scope in `scopes_supported` and the client requested them all."

The spec lists these as the common mistakes that produce ambient authority:
- Publishing all possible scopes in `scopes_supported`
- Using wildcard or omnibus scopes (`*`, `all`, `full-access`)
- Bundling unrelated privileges to preempt future prompts

The spec recommends incremental elevation via least-privilege initial scope sets. However, the spec is advisory; most shipping MCP integrations as of early 2026 still use broad bearer-token grants (a GitHub MCP server that holds your entire GitHub OAuth token, a Notion MCP server that holds your full Notion API key). This is the "ambient-authority grants" problem the Endo brief names as Endo's primary differentiator.

The same spec section identifies a confused-deputy vulnerability specific to MCP proxy servers: when an MCP proxy uses a static OAuth client_id to a third-party API and allows dynamic client registration, an attacker can exploit cached consent cookies to obtain authorization codes without fresh user consent.

Additionally, the April 2025 MCP Safety Audit paper (Radosevich/Halloran, arXiv:2504.03767) demonstrated that "industry-leading LLMs may be coerced into using MCP tools to compromise an AI developer's system" through malicious code execution, remote access control, and credential theft. The paper introduced MCPSafetyScanner as a public auditing tool.

Source: [modelcontextprotocol.io](https://modelcontextprotocol.io/) and named sources in `notes:` frontmatter. Retrieval date: 2026-06-11.
