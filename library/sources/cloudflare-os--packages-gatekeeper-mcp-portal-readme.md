---
source: packages/gatekeeper-mcp-portal/README.md
source_repo: cloudflare/cloudflare-os
source_commit: 4fd43ffe37435637e818357035a50054bacba297
source_date: 2026-08-18
source_authors: [Dan Carter, Maximo Guk]
ingested: 2026-08-24
ingested_by: scholar
section_count: 4
status: current
---

The MCP Server Portals Gatekeeper README covers connecting a deployment's administrator-configured MCP portal as a capability: per-server grants only, fail-closed repoint semantics when the portal URL changes, recovery of the per-server seam from tool-name prefixes and the `portal_list_servers` probe, and the aggregator trust tier gated behind an annotation-trust flag.

| Section | Topics | Status |
|---|---|---|
| [MCP portal connector and per-server grants](../sections/cloudflare-os--packages-gatekeeper-mcp-portal-readme--portal-server-connector.md) | capability-mediated-integrations, cloudflare-workers-agent-hosting | current |
| [Portal configuration and fail-closed repoint](../sections/cloudflare-os--packages-gatekeeper-mcp-portal-readme--configuration-and-repoint.md) | capability-mediated-integrations, cloudflare-workers-agent-hosting | current |
| [Recovering upstream servers from tool-name prefixes](../sections/cloudflare-os--packages-gatekeeper-mcp-portal-readme--recovering-upstream-servers.md) | capability-mediated-integrations | current |
| [Portal trust tier and the annotation-trust flag](../sections/cloudflare-os--packages-gatekeeper-mcp-portal-readme--portal-trust-tier-and-annotations.md) | capability-mediated-integrations, capability-security | current |
