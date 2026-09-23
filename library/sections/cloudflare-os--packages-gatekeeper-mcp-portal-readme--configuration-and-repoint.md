---
title: Portal configuration and fail-closed repoint
source: packages/gatekeeper-mcp-portal/README.md
source_repo: cloudflare/cloudflare-os
source_commit: 4fd43ffe37435637e818357035a50054bacba297
source_date: 2026-08-18
source_authors: [Dan Carter, Maximo Guk]
ingested: 2026-08-24
ingested_by: scholar
topics: [capability-mediated-integrations, cloudflare-workers-agent-hosting]
status: current
---

The portal endpoint is a deployment setting rather than a form field, and changing `MCP_PORTAL_URL` on a deployment that already has connected accounts is a repoint that fails every existing binding closed at once, forcing a clean re-authorization against the new host.

Configuration is a small variable set: `MCP_PORTAL_URL` (unset means the connector hides itself), `MCP_PORTAL_NAME`, `MCP_PORTAL_AUTH` (`oauth` default, `none`, or `token`), `MCP_PORTAL_TOKEN`, `MCP_PORTAL_TRUST_ANNOTATIONS`, and `MCP_ALLOW_INSECURE`. Only `MCP_ALLOW_INSECURE` is set in the repo's `wrangler.jsonc`, pinned to `"false"` so the default is explicit; a portal URL committed there would become the default for every deployment and send their users' OAuth flows to whichever host it named, so it belongs in the deployment's own configuration. Unconfigured, `getSupportedResources()` returns nothing and the Workshop drops the vendor; a `MCP_PORTAL_URL` that cannot be used (a non-`https` typo, or a URL containing `username:password`) is treated the same way, hiding the connector rather than producing one that fails on first use or copies URL credentials into account state. The portal must expose upstream tools directly, so a portal running enforced Code Mode is unsupported — use one where Code Mode is off or opt-in, or append `?codemode=off`.

A repoint fails existing bindings closed: the minting path checks facet props against current configuration, and an already-minted facet must name its endpoint when asking the account for credentials, which the account refuses after it has moved. The user recovers by reconnecting — the one endpoint change an account accepts, and only because the new endpoint comes from this Worker's configuration rather than a form. Nothing held for the old portal survives the move (tokens, transport session, in-progress authorization are dropped), the account advances a persisted generation before probing so stale refreshes and notifications from the old generation are ignored, and always-approve action kinds include the exact endpoint so old consent does not carry over. `MCP_PORTAL_TRUST_ANNOTATIONS` is read at each point of use (`portalTrust(env)`) and never persisted, so clearing it de-escalates every existing connection on the next call, and setting it retroactively auto-applies nothing.

Source: [packages/gatekeeper-mcp-portal/README.md](https://github.com/cloudflare/cloudflare-os/blob/4fd43ffe37435637e818357035a50054bacba297/packages/gatekeeper-mcp-portal/README.md) at commit `4fd43ffe`.
