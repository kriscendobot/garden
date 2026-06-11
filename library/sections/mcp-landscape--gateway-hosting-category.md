---
title: MCP Gateway and Remote-Hosting Category Landscape (2024–2025)
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
---

## Abstract

The Model Context Protocol (MCP), introduced by Anthropic in November 2024, defines a JSON-RPC 2.0-based standard for connecting AI applications (hosts) to tools and data sources (servers). Within months of launch the protocol acquired broad ecosystem support and a named category of infrastructure: MCP gateways and remote-MCP hosting. This section records the structural facts and named products as of mid-2026, with provenance for each claim.

## What MCP is

MCP uses a client-server architecture. An MCP host (Claude Desktop, Cursor, VS Code with Copilot, and others) creates one MCP client per server. Local servers use the STDIO transport; remote servers use Streamable HTTP transport (OAuth-authenticated bearer tokens, API keys, or custom headers). The protocol's three server-side primitives are **tools** (executable functions), **resources** (data sources), and **prompts** (interaction templates).

The protocol specification is maintained by Anthropic at https://modelcontextprotocol.io. The TypeScript SDK (`@modelcontextprotocol/sdk`, v1.29.0 as of early 2026) is the reference implementation. The spec and SDK are MIT-licensed.

## The ambient-authority problem MCP inherits

The MCP security best-practices specification names a structural problem the protocol inherits from how OAuth bearer tokens are typically scoped: current MCP integrations tend to be **ambient-authority grants**. The spec's Scope Minimization section describes the failure mode:

> "An attacker obtains (via log leakage, memory scraping, or local interception) an access token carrying broad scopes (`files:*`, `db:*`, `admin:*`) that were granted up front because the MCP server exposed every scope in `scopes_supported` and the client requested them all."

The spec lists these as the common mistakes that produce ambient authority:
- Publishing all possible scopes in `scopes_supported`
- Using wildcard or omnibus scopes (`*`, `all`, `full-access`)
- Bundling unrelated privileges to preempt future prompts

The spec recommends incremental elevation via least-privilege initial scope sets. However, the spec is advisory; most shipping MCP integrations as of early 2026 still use broad bearer-token grants (a GitHub MCP server that holds your entire GitHub OAuth token, a Notion MCP server that holds your full Notion API key). This is the "ambient-authority grants" problem the Endo brief names as Endo's primary differentiator.

The same spec section identifies a confused-deputy vulnerability specific to MCP proxy servers: when an MCP proxy uses a static OAuth client_id to a third-party API and allows dynamic client registration, an attacker can exploit cached consent cookies to obtain authorization codes without fresh user consent.

Additionally, the April 2025 MCP Safety Audit paper (Radosevich/Halloran, arXiv:2504.03767) demonstrated that "industry-leading LLMs may be coerced into using MCP tools to compromise an AI developer's system" through malicious code execution, remote access control, and credential theft. The paper introduced MCPSafetyScanner as a public auditing tool.

## Ecosystem scale

The official `modelcontextprotocol/servers` repository showed:
- 87,000+ GitHub stars (as of January 2026)
- 11,000+ forks
- Seven actively-maintained reference implementations (Filesystem, Git, Memory, Fetch, Sequential Thinking, Time, Everything)
- Thirteen previously-maintained servers archived and superseded by vendor-maintained versions (AWS, GitHub, GitLab, Google Drive, PostgreSQL, and others)

The MCP Registry (https://registry.npmjs.org/@modelcontextprotocol) provides discovery for community-published servers; the ecosystem extends well beyond the reference repository.

MCP clients with declared support include Claude Desktop, Claude Code, Cursor, VS Code (Copilot Chat), MCPJam, and many others. OpenAI declared MCP adoption for ChatGPT in 2025.

## Named MCP gateway and remote-hosting products

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

## The commoditization dynamic

The MCP architecture documentation describes local and remote servers as equivalent from the protocol layer's perspective: "MCP server refers to the program that serves context data, regardless of where it runs." This transport-layer neutrality means the hosting function — running an MCP server that any compliant client can reach — is structurally commodity infrastructure.

The Anthropic November 2024 launch announcement named Block, Apollo, Zed, Replit, Sourcegraph as early adopters and promised "developer toolkits for deploying remote production MCP servers serving entire Claude for Work organizations." By early 2026, multiple cloud platforms (Cloudflare, and others) had launched general-purpose MCP server hosting.

**The brief's positioning claim is supported:** The hosting-of-MCP-servers category is commoditizing. The differentiator space is not "I can host an MCP server" but rather what authority model governs the server's tool grants. Current production deployments are ambient-authority grants (bearer tokens to your whole GitHub, your entire Notion). An Endo gateway node offers attenuated, per-agent, revocable, auditable grants — a structurally different authorization model applied to the same protocol.

Source: [modelcontextprotocol.io](https://modelcontextprotocol.io/) and named sources in `notes:` frontmatter. Retrieval date: 2026-06-11.
