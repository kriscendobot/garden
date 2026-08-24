---
title: Shared MCP connector security kernel
source: packages/mcp-shared/README.md
source_repo: cloudflare/cloudflare-os
source_commit: bd0aa2dcde02008bb6170341fe2c574fd3ace275
source_date: 2026-08-18
source_authors: [Dan Carter, Maximo Guk, Nathan Disidore, Phillip Jones]
ingested: 2026-08-24
ingested_by: scholar
topics: [capability-mediated-integrations, capability-security]
status: current
---

`mcp-shared` is the non-Worker implementation library behind both MCP Gatekeepers, centralizing protocol transport, policy, and state whose divergence between connectors could become a security bug.

The bring-your-own connector gets an endpoint from the user and grants a whole server or named tools. The portal connector gets its deployment endpoint from `MCP_PORTAL_URL` and grants one upstream server or named tools. Shared code owns bounded Streamable HTTP, OAuth adaptation, tool classification, schema-to-TypeScript conversion, catalog search, portal mapping, scope grammar, endpoint and redirect checks, account state, facets, action storage, session routing, owner-only sharing, and common HTTP and UI surfaces. Worker entrypoints, migrations, bindings, forms, and connector-specific Durable Objects remain outside. Variation enters through named hooks such as `staticToken` and `mintAccount`, not copied policy.

Nothing outside `tools.ts` reads a tool's annotations, making that module the annotation trust boundary.

Source: [packages/mcp-shared/README.md](https://github.com/cloudflare/cloudflare-os/blob/bd0aa2dcde02008bb6170341fe2c574fd3ace275/packages/mcp-shared/README.md) at commit `bd0aa2dc`.
