---
title: Bounded MCP transport and state
source: packages/mcp-shared/README.md
source_repo: cloudflare/cloudflare-os
source_commit: bd0aa2dcde02008bb6170341fe2c574fd3ace275
source_date: 2026-08-18
source_authors: [Dan Carter, Maximo Guk, Nathan Disidore, Phillip Jones]
ingested: 2026-08-24
ingested_by: scholar
topics: [capability-mediated-integrations, capability-security, cloudflare-workers-agent-hosting]
status: current
---

The shared MCP library fixes hard limits across discovery, schemas, prompts, transport, stored actions, and connection setup so untrusted servers and agent inputs cannot create unbounded Worker work or Durable Object state.

Representative bounds include 200 described or individually granted tools, a 96 KiB cached catalog, a filtered scan of 5,000 tools or 4 MiB, 50 listing pages, a 1 MiB response body, a 30-second outbound-operation deadline, three redirect hops, and 200 hydrated definitions or 1 MiB per facet. Retained results are limited to 128 KB; the store retains 100 actions and no more than 50 awaiting decisions. Prompt-facing server descriptions, arguments, and names are separately bounded and sanitized. Connect links are single-use for ten minutes, while unfinished accounts delete themselves after one hour.

These are fixed policy values rather than deployment configuration.

Source: [packages/mcp-shared/README.md](https://github.com/cloudflare/cloudflare-os/blob/bd0aa2dcde02008bb6170341fe2c574fd3ace275/packages/mcp-shared/README.md) at commit `bd0aa2dc`.
