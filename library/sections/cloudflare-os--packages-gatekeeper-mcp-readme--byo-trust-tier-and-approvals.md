---
title: The byo trust tier, approvals, and tool scoping
source: packages/gatekeeper-mcp/README.md
source_repo: cloudflare/cloudflare-os
source_commit: bd0aa2dcde02008bb6170341fe2c574fd3ace275
source_date: 2026-08-18
source_authors: [Dan Carter, Maximo Guk]
ingested: 2026-08-24
ingested_by: scholar
topics: [capability-mediated-integrations, capability-security]
status: current
---

Because a user-supplied MCP endpoint is untrusted, the connector runs at the `byo` trust tier: a tool the server annotates `readOnlyHint: true` returns straight away as an observation, but no claim the server makes can auto-apply a write.

Every non-read call is queued via `submitAction()` and reaches the server only when the Overseer calls `applyAction()`; annotations are optional in MCP and most servers publish none, so every hint is tested with `=== true` or `=== false` and an unannotated tool is an action that needs approval and can never auto-apply. MCP's own guidance is that a client must treat tool annotations as untrusted unless they come from a trusted server; the trust tier encodes that distinction and it is the deployment's to make, not the server's. Endpoints here are user-supplied rather than administrator-vetted, so they get `byo`. Honouring `readOnlyHint` on `byo` is a knowing departure from the strict rule and the limit of what the connector can promise — a server that labels a destructive tool `readOnlyHint: true` gets it run without a prompt — but refusing the hint would mean an approval prompt for every `search` and `list`, and would buy little since a dishonest server can act on any approved call anyway. What the tier guarantees is that no BYO server gets a write auto-applied, and that every call records which side classified it (`McpToolInfo.classifiedBy`) so an audit can find each one taken on the server's word. Auto-approval requires a `vetted` endpoint, which only the MCP Server Portals connector can produce.

The configurator asks the grant breadth outright rather than inferring it from whether every box is ticked — "all 14 ticked" and "these 14 by name" look identical and diverge as soon as the server publishes a fifteenth — and tools named `portal_*` are never grantable on an endpoint that identifies itself as a portal, since they let a session change which upstream servers it can reach. A Gadget bound to an MCP server can only be opened by its owner: `addObserver` refuses unconditionally, because being able to authenticate to a server is not evidence of being allowed to see what the owner read from it, and the Gadget runs on the owner's credentials throughout. To share the work rather than the binding, the owner publishes the Gadget as a blueprint and each person connects their own server.

Source: [packages/gatekeeper-mcp/README.md](https://github.com/cloudflare/cloudflare-os/blob/bd0aa2dcde02008bb6170341fe2c574fd3ace275/packages/gatekeeper-mcp/README.md) at commit `bd0aa2dc`.
