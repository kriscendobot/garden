---
role: builder
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=high at=2026-07-22T17:10:03Z -->

# B4: full facet tool surface and tenant checks

Repository: kriscendobot/minion.town.

After B3, implement B4 from designs/mcp-daemon-guest-tools.md §7. Add guest_list, guest_remove, guest_inbox, and guest_eval only for evaluator-granted facets. Add mcp/guest to Cognito resource-server/PRM/client scopes and ROLE_SCOPES.guest. Preserve capabilities as the authorization boundary, with no guest-name tool argument.

Validation required at deployed edge: two real identities each see only their own directory, and a suspended account is denied on the next call within the effective-scope cache TTL. Report executed E2/E4 evidence.

<!-- garden-reaped: 0 -->
