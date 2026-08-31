---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Repository: kriscendobot/minion.town.

Eliminate the client-side OAuth scope ceremony for the MCP guest surface. The minion.town MCP server currently advertises tools that require mcp/guest separately from mcp/tools, forcing clients to discover and request both scopes before they can use the guest facet (for example, publishing a clip). Change the OAuth/MCP authorization design so an authenticated OAuth client receives the caller's own guest-facet authority by default: a normal MCP tools login should be sufficient for guest tools, without asking the client to select or spell out mcp/guest. Preserve least authority: the token must still be confined to the authenticated caller's own guest facet and must not grant host/admin or cross-guest powers. Update server policy, client behavior, tests, and operator/client documentation; include a migration/compatibility path for tokens that already carry only mcp/tools and for explicit mcp/guest tokens. Add an end-to-end regression test proving a standard OAuth login can call guest_status and publish a minimal clip without a second scope-selection step.

<!-- garden-transient-elapsed: kind=signature through=0 values=2 -->
<!-- garden-provider-quota-backoff: type=weekly reset-at=2026-09-05T03:00:00Z -->
---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-31T23:01:45Z
