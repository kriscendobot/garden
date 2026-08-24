---
source: packages/mcp-shared/README.md
source_repo: cloudflare/cloudflare-os
source_commit: bd0aa2dcde02008bb6170341fe2c574fd3ace275
source_date: 2026-08-18
source_authors: [Dan Carter, Maximo Guk, Nathan Disidore, Phillip Jones]
ingested: 2026-08-24
ingested_by: scholar
section_count: 4
status: current
---

The `mcp-shared` README documents the common security implementation behind both MCP Gatekeepers: its connector split, annotation trust tiers, at-most-once approval semantics, and fixed resource bounds.

| Section | Topics | Status |
|---|---|---|
| [Shared MCP connector security kernel](../sections/cloudflare-os--packages-mcp-shared-readme--shared-connector-security-kernel.md) | capability-mediated-integrations, capability-security | current |
| [MCP trust-tier annotation policy](../sections/cloudflare-os--packages-mcp-shared-readme--trust-tier-annotation-policy.md) | capability-mediated-integrations, capability-security | current |
| [At-most-once approved MCP calls](../sections/cloudflare-os--packages-mcp-shared-readme--at-most-once-approved-calls.md) | capability-mediated-integrations, capability-security | current |
| [Bounded MCP transport and state](../sections/cloudflare-os--packages-mcp-shared-readme--bounded-transport-and-state.md) | capability-mediated-integrations, capability-security, cloudflare-workers-agent-hosting | current |
