---
source_kind: comment-fragment
source_repo: cloudflare/cloudflare-os
source_path: packages/mcp-shared/src/account.ts
source_line_range: "1-338"
source_commit: 50ac3efa2ddf98edf44393916b3f3688667b2813
comment_subject: endpoint immutability, credential-confusion avoidance, and connect-time provenance versus live trust in the MCP account Durable Object
source_authors: [Dan Carter, Phillip Jones]
ingested: 2026-08-24
ingested_by: scholar
section_count: 2
status: current
---

`account.ts` is the Durable Object that owns one connection to one MCP endpoint and every credential for it, and its comments explain two intertwined design decisions. First, the connected endpoint is immutable after the first connect: a gatekeeper facet freezes the endpoint into its props while authorization answers for wherever the account currently points, so moving the account would send a token minted for one server to another. Second, connection facts split into those settled once (provenance, endpoint) and those read live from deployment configuration (trust, preissued token), because withdrawing trust or rotating a token must take effect without a reconnect. Filed under the `mcp-server-connector` concept.

| Section | Topics | Status |
|---------|--------|--------|
| [Endpoint immutability and the credential-confusion hazard](../sections/cloudflare-os--packages-mcp-shared-src-account--endpoint-immutability.md) | capability-mediated-integrations, capability-security | current |
| [Connect-time provenance versus live trust configuration](../sections/cloudflare-os--packages-mcp-shared-src-account--provenance-vs-live-trust.md) | capability-mediated-integrations, capability-security | current |
