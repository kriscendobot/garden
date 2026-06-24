---
title: Ecosystem scale
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

The official `modelcontextprotocol/servers` repository showed:
- 87,000+ GitHub stars (as of January 2026)
- 11,000+ forks
- Seven actively-maintained reference implementations (Filesystem, Git, Memory, Fetch, Sequential Thinking, Time, Everything)
- Thirteen previously-maintained servers archived and superseded by vendor-maintained versions (AWS, GitHub, GitLab, Google Drive, PostgreSQL, and others)

The MCP Registry (https://registry.npmjs.org/@modelcontextprotocol) provides discovery for community-published servers; the ecosystem extends well beyond the reference repository.

MCP clients with declared support include Claude Desktop, Claude Code, Cursor, VS Code (Copilot Chat), MCPJam, and many others. OpenAI declared MCP adoption for ChatGPT in 2025.

Source: [modelcontextprotocol.io](https://modelcontextprotocol.io/) and named sources in `notes:` frontmatter. Retrieval date: 2026-06-11.
