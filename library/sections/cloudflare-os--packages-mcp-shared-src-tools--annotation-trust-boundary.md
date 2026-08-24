---
title: Tool-annotation trust boundary and ServerTrust tiers
source: packages/mcp-shared/src/tools.ts
source_kind: comment-fragment
source_repo: cloudflare/cloudflare-os
source_path: packages/mcp-shared/src/tools.ts
source_line_range: "1-34"
source_commit: bd0aa2dcde02008bb6170341fe2c574fd3ace275
comment_subject: this file is the sole trust boundary where an MCP server's self-description becomes what a Gadget may do, mediated by a deployment-decided trust tier
source_authors: [Dan Carter, Phillip Jones]
ingested: 2026-08-24
ingested_by: scholar
topics: [capability-mediated-integrations, capability-security]
status: current
---

`tools.ts` is the single trust boundary in the MCP connector: what a server says about its own tools (its `annotations`) becomes what a Gadget may do, and nothing outside this file reads a tool's `annotations`. How far that self-description is trusted is a `ServerTrust` tier decided by the deployment, not by the server describing itself: `vetted` endpoints (an administrator vouched for them) may let annotations drive auto-approval, while `byo` endpoints (a user pasted the URL) get only a narrow, argued exception for `readOnlyHint`.

## ServerTrust: vetted versus byo

MCP's own guidance is that a client must treat tool annotations as untrusted unless they come from a trusted server. `ServerTrust` makes that distinction explicit and moves the decision to the deployment:

- **vetted**: an administrator asserted this endpoint's annotations are reliable; they may drive auto-approval.
- **byo** (bring-your-own): a user typed the URL in. `readOnlyHint` still classifies reads, but nothing the server says can auto-apply a write.

Honouring `readOnlyHint` on `byo` is a knowing departure from treating annotations as wholly untrusted; it is argued in `classifyTool` and stated on the connect form the user types the URL into. Every other annotation is inert until a deployment vouches for the endpoint.

`ServerTrust` governs trust in annotations only. Neither tier can be shared (that is a separate sharing-policy concern). It is deployment configuration rather than account state, so it is read afresh wherever used, and withdrawing it takes effect without a reconnect (the same live-configuration discipline the account module applies to its own trust facts).

Source: [packages/mcp-shared/src/tools.ts](https://github.com/cloudflare/cloudflare-os/blob/bd0aa2dcde02008bb6170341fe2c574fd3ace275/packages/mcp-shared/src/tools.ts) at commit `bd0aa2dcde` (lines 1-34).
