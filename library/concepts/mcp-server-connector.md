---
id: mcp-server-connector
aliases: [MCP Gatekeeper, MCP gatekeeper, MCP Server Portals gatekeeper, gatekeeper-mcp, gatekeeper-mcp-portal, mcp-shared, byo trust tier, vetted trust tier, portal_list_servers, McpAccount]
topics: [capability-mediated-integrations, capability-security]
---

# MCP server connector

A Cloudflare OS Gatekeeper family that connects Model Context Protocol servers as Gadgets capabilities, turning each server tool into a typed session method. The bring-your-own connector takes a user-pasted endpoint at the untrusted `byo` trust tier (a `readOnlyHint` read returns immediately but no server claim can auto-apply a write); the MCP Server Portals connector takes one administrator-configured portal URL, grants one upstream server at a time, and can reach the `vetted` tier through an explicit annotation-trust flag.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [Bring-your-own MCP server connector](../sections/cloudflare-os--packages-gatekeeper-mcp-readme--bring-your-own-server-connector.md) | One Worker connects any user-supplied MCP server; each tool becomes a typed session method. |
| [OAuth discovery connect flow and token handling](../sections/cloudflare-os--packages-gatekeeper-mcp-readme--oauth-discovery-connect-flow.md) | A 401 runs the standards-based MCP OAuth discovery chain; tokens live in a per-account Durable Object. |
| [The byo trust tier, approvals, and tool scoping](../sections/cloudflare-os--packages-gatekeeper-mcp-readme--byo-trust-tier-and-approvals.md) | A user-supplied endpoint is byo, so no server annotation can auto-apply a write. |
| [MCP connector limitations and SSRF enforcement](../sections/cloudflare-os--packages-gatekeeper-mcp-readme--connector-limitations-and-ssrf.md) | Protocol limits (no simulation/revert/hooks) and DNS-resolved SSRF via a workerd flag. |
| [MCP portal connector and per-server grants](../sections/cloudflare-os--packages-gatekeeper-mcp-portal-readme--portal-server-connector.md) | An admin-configured portal grants one upstream server per grant, never the whole portal. |
| [Portal configuration and fail-closed repoint](../sections/cloudflare-os--packages-gatekeeper-mcp-portal-readme--configuration-and-repoint.md) | Changing the portal URL fails every existing binding closed and forces reconnection. |
| [Recovering upstream servers from tool-name prefixes](../sections/cloudflare-os--packages-gatekeeper-mcp-portal-readme--recovering-upstream-servers.md) | Server membership is a pure string test on the `{server_id}_` prefix, so a scope cannot fail open. |
| [Portal trust tier and the annotation-trust flag](../sections/cloudflare-os--packages-gatekeeper-mcp-portal-readme--portal-trust-tier-and-annotations.md) | Aggregated annotations stay byo unless MCP_PORTAL_TRUST_ANNOTATIONS asserts trust in the upstreams. |
| [Shared MCP connector security kernel](../sections/cloudflare-os--packages-mcp-shared-readme--shared-connector-security-kernel.md) | Centralizes the protocol, policy, and state used by both MCP Gatekeepers. |
| [MCP trust-tier annotation policy](../sections/cloudflare-os--packages-mcp-shared-readme--trust-tier-annotation-policy.md) | Defines how byo and vetted deployments may trust tool annotations. |
| [At-most-once approved MCP calls](../sections/cloudflare-os--packages-mcp-shared-readme--at-most-once-approved-calls.md) | Claims approvals before dispatch and never retries uncertain outcomes. |
| [Bounded MCP transport and state](../sections/cloudflare-os--packages-mcp-shared-readme--bounded-transport-and-state.md) | Fixes limits across discovery, transport, prompts, and retained actions. |
| [Endpoint immutability and the credential-confusion hazard](../sections/cloudflare-os--packages-mcp-shared-src-account--endpoint-immutability.md) | The connected endpoint is pinned after first connect so a token minted for one server never reaches another. |
| [Connect-time provenance versus live trust configuration](../sections/cloudflare-os--packages-mcp-shared-src-account--provenance-vs-live-trust.md) | Provenance and endpoint are frozen at connect; ServerTrust and static tokens are read live from configuration. |
| [Tool-annotation trust boundary and ServerTrust tiers](../sections/cloudflare-os--packages-mcp-shared-src-tools--annotation-trust-boundary.md) | The sole file reading tool annotations; a deployment-decided vetted/byo tier bounds how far they are trusted. |
| [Classifying a tool into read or action and deciding auto-approval](../sections/cloudflare-os--packages-mcp-shared-src-tools--tool-classification-policy.md) | classifyTool fails closed: a write auto-applies only on a vetted endpoint with strict destructive/idempotent claims. |
| [Approval, simulation, rejection, and revert](../sections/cloudflare-os--packages-workshop-shared-src-gatekeeper--approval-and-revert-contract.md) | The generic Gatekeeper action contract that MCP tool calls enter for deferred approval. |

## See also

- [[cloudflare-os-gatekeeper]]
- [[principle-of-least-authority]]
