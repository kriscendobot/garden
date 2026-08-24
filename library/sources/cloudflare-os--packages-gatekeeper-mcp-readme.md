---
source: packages/gatekeeper-mcp/README.md
source_repo: cloudflare/cloudflare-os
source_commit: bd0aa2dcde02008bb6170341fe2c574fd3ace275
source_date: 2026-08-18
source_authors: [Dan Carter, Maximo Guk]
ingested: 2026-08-24
ingested_by: scholar
section_count: 4
status: current
---

The MCP Gatekeeper README covers connecting any user-supplied Model Context Protocol server as a capability: one Worker per every server, generated typed tool methods, the standards-based OAuth discovery connect flow, the untrusted `byo` trust tier that never auto-applies a write, and the connector's protocol-imposed limitations with DNS-resolved SSRF enforcement.

| Section | Topics | Status |
|---|---|---|
| [Bring-your-own MCP server connector](../sections/cloudflare-os--packages-gatekeeper-mcp-readme--bring-your-own-server-connector.md) | capability-mediated-integrations, cloudflare-workers-agent-hosting | current |
| [OAuth discovery connect flow and token handling](../sections/cloudflare-os--packages-gatekeeper-mcp-readme--oauth-discovery-connect-flow.md) | capability-mediated-integrations, oauth-credentials, cloudflare-workers-agent-hosting | current |
| [The byo trust tier, approvals, and tool scoping](../sections/cloudflare-os--packages-gatekeeper-mcp-readme--byo-trust-tier-and-approvals.md) | capability-mediated-integrations, capability-security | current |
| [MCP connector limitations and SSRF enforcement](../sections/cloudflare-os--packages-gatekeeper-mcp-readme--connector-limitations-and-ssrf.md) | capability-mediated-integrations, cloudflare-workers-agent-hosting | current |
