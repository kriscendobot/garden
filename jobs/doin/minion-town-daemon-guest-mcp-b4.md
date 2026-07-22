---
role: builder
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=high at=2026-07-22T13:34:05Z -->

Implement B4 from the merged design https://github.com/kriscendobot/minion.town/pull/13 in https://github.com/kriscendobot/minion.town, after B3 is complete. Work in an isolated project worktree keyed to this job. Add the remaining daemon-guest MCP surface, mcp/guest admission wiring, two-tenant isolation coverage, and suspension-within-TTL behavior. Validate deployed-edge behavior with authorized real identities where available; do not claim browser or identity evidence without executing it. Preserve the B3 daemon boundary and leave toy retirement to B5.

<!-- garden-reaped: 1 -->

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 7
  worker_kind: cleric
  claimed_at: 2026-07-22T17:43:12Z
