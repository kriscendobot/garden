---
gate: go-ahead
priority: normal
poisoned: true
poison_signature: requeue-exhausted
poison_count: 1
requeue_cycles: 5
deadline_overruns: 0
poisoned_at: 2026-07-23T00:43:06Z
poisoned_on: endolin-garden2-5bcdff64
posted_by: reaper:endolin-garden2-5bcdff64
posted_at: 2026-07-23T00:43:06Z
---

---
role: builder
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=high at=2026-07-22T22:31:03Z -->

# B5: retire toy tools

Repository: kriscendobot/minion.town.

After B4, implement B5 from designs/mcp-daemon-guest-tools.md §7. Delete minion_status, list_minions, summon_minion, their in-memory Map, and their scope rows. Stop advertising mcp/minions:*; rewrite the server.ts toy header for facet-backed guest tools; update README and DEPLOYMENT.md phase rows; clean Cognito scope configuration. Guest tools now mount unconditionally, returning clean daemon-unavailable errors when the socket is absent.

Validation required at deployed edge: a fresh tools/list has only guest_* tools, then rerun full E1-E4 sweep green. Report concrete command/run evidence.
