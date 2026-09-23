---
title: MCP connector limitations and SSRF enforcement
source: packages/gatekeeper-mcp/README.md
source_repo: cloudflare/cloudflare-os
source_commit: bd0aa2dcde02008bb6170341fe2c574fd3ace275
source_date: 2026-08-18
source_authors: [Dan Carter, Maximo Guk]
ingested: 2026-08-24
ingested_by: scholar
topics: [capability-mediated-integrations, cloudflare-workers-agent-hosting]
status: current
---

The MCP connector inherits limits from what the protocol can express — no simulation, no revert, no hooks, no scoping below tool names, and `tools/*` only — and enforces SSRF after DNS resolution through a workerd compatibility flag rather than the connect-time hostname blocklist.

Because MCP describes no way to predict a tool's effect, a queued call is not reflected in later reads and the agent's turn suspends until the user decides (`awaitDecision`); MCP describes no inverse for a call, so `implementsRevert` is false; and `notifications/tools/list_changed` is session-scoped while a Gadget hook must be durable, so there are no hooks. MCP tools take arguments rather than capabilities, so "this repo only" cannot be expressed and a list of allowed tool names is the narrowest grant available. Prompts, resources, sampling, and elicitation are not implemented — sampling and elicitation would let a server drive the agent. A changed tool list is adopted and logged (`catalog.changed`) rather than pinned, since refusing to see new tools would break working Gadgets; a binding scoped to specific tools cannot widen this way, which is the reason to prefer **Choose tools** for anything that writes.

The hostname patterns in `endpoint.ts` are a legible refusal at connect time but cannot see through a public hostname that resolves — or rebinds — to a private address. The actual boundary is the `global_fetch_strictly_public` compatibility flag in `wrangler.jsonc`, which makes workerd reject reserved IP ranges after resolution on every request and redirect hop; it does not apply under `wrangler dev`, which is what keeps `MCP_ALLOW_INSECURE` usable locally. One known rough edge: `GadgetMetadata.sharingProhibited` derives only from `prohibitAllSharing`, so creating a share key appears to succeed and fails when the recipient opens it, and fixing this needs a kernel change.

Source: [packages/gatekeeper-mcp/README.md](https://github.com/cloudflare/cloudflare-os/blob/bd0aa2dcde02008bb6170341fe2c574fd3ace275/packages/gatekeeper-mcp/README.md) at commit `bd0aa2dc`.
