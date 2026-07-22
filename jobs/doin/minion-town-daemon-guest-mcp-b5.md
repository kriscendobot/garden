---
role: builder
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=high at=2026-07-22T17:49:04Z -->

Implement B5 from the merged design https://github.com/kriscendobot/minion.town/pull/13 in https://github.com/kriscendobot/minion.town, after B4 is complete. Work in an isolated project worktree keyed to this job. Remove minion_status, list_minions, summon_minion, their in-memory state and mcp/minions scope wiring; make guest tools the required surface; update server documentation, deployment documentation, Cognito scope configuration, and the PKCE client. Deploy only with green prior-stage evidence. Record a fresh tools/list plus the full E1-E4 evidence, or state precisely what remains unverified.

<!-- garden-reaped: 1 -->

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 15
  worker_kind: cleric
  claimed_at: 2026-07-22T17:53:18Z
