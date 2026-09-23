---
source: docs/ai-gateway-billing.md
source_repo: cloudflare/cloudflare-os
source_commit: 8b9fd811d016b58ac5cbe1c28761f1d13dfe7138
source_date: 2026-08-18
source_authors: [Dan Carter, Kenton Varda, Maximo Guk, "Yo'av Moshe"]
ingested: 2026-08-24
ingested_by: scholar
section_count: 4
status: current
---

The AI Gateway billing design combines a daily platform allowance with user-funded Cloudflare credits, Gatekeeper-held OAuth authority, and binding-or-token Gateway transport.

| Section | Topics | Status |
|---------|--------|--------|
| [daily allowance and credit routing](../sections/cloudflare-os--docs-ai-gateway-billing--daily-allowance-and-credit-routing.md) | ai-usage-billing, agent-workspaces, capability-mediated-integrations | current |
| [Cloudflare Gatekeeper billing connection](../sections/cloudflare-os--docs-ai-gateway-billing--cloudflare-gatekeeper-billing-connection.md) | ai-usage-billing, authentication-gatekeepers, capability-mediated-integrations | current |
| [AI Gateway transport configuration](../sections/cloudflare-os--docs-ai-gateway-billing--gateway-transport-configuration.md) | ai-usage-billing, cloudflare-workers-agent-hosting | current |
| [billing state and code layout](../sections/cloudflare-os--docs-ai-gateway-billing--billing-state-and-code-layout.md) | ai-usage-billing, cloudflare-workers-agent-hosting | current |
