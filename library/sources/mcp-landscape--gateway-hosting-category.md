---
source_kind: web-survey
source_url: https://modelcontextprotocol.io/
source_date: 2026-06-11
ingested: 2026-06-11
ingested_by: scholar
section_count: 1
status: current
notes: |
  Multi-source survey of the MCP gateway/remote-hosting category landscape.
  Primary sources: MCP spec docs, MCP security best-practices spec, Cloudflare
  remote MCP developer docs, MCP servers GitHub repository, MCP SDK npm package,
  MCP Safety Audit paper (arXiv:2504.03767). Full provenance in section frontmatter.
---

## Abstract

Survey of the Model Context Protocol (MCP) ecosystem as it relates to remote MCP hosting, gateway infrastructure, and the ambient-authority problem the protocol currently exhibits. MCP was introduced by Anthropic in November 2024 as an open standard for AI-application-to-tool connectivity. Within months, multiple platforms offered MCP server hosting (Cloudflare Workers being the most documented), and the protocol acquired a named security problem: ambient-authority bearer-token grants that hand an entire SaaS account to every connected agent. The library section records named products with URLs, ecosystem scale metrics, and the structural claim (from the MCP spec itself and the MCP Safety Audit paper) that current MCP deployments are ambient-authority grants — which is the factual grounding for Endo's differentiation claim.

| Section | Topics | Status |
|---------|--------|--------|
| [gateway-hosting-category](../sections/mcp-landscape--gateway-hosting-category.md) | capability-security, agent-conventions | current |
