---
role: builder
---
<!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-08-01T09:02:08Z cleared=none -->

---
role: builder
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=high at=2026-07-22T22:31:03Z -->

# B5: retire toy tools

Repository: kriscendobot/minion.town.

After B4, implement B5 from designs/mcp-daemon-guest-tools.md §7. Delete minion_status, list_minions, summon_minion, their in-memory Map, and their scope rows. Stop advertising mcp/minions:*; rewrite the server.ts toy header for facet-backed guest tools; update README and DEPLOYMENT.md phase rows; clean Cognito scope configuration. Guest tools now mount unconditionally, returning clean daemon-unavailable errors when the socket is absent.

Validation required at deployed edge: a fresh tools/list has only guest_* tools, then rerun full E1-E4 sweep green. Report concrete command/run evidence.

<!-- garden-reaped: 1 -->
