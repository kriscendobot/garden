---
gate: orchestrated
orchestrated_by: minion-town-mcp-daemon-guest-tools-orchestration
priority: high
role: builder
posted_by: gardener
posted_at: 2026-07-22T16:04:27Z
---

# B3: endo daemon standup

Repository: kriscendobot/minion.town.

After B2, implement B3 from designs/mcp-daemon-guest-tools.md §7 and the carried unit/deploy requirements in designs/mcp-endo-guest.md §4.1-4.2. Add deploy-endo-daemon.sh, endo-daemon.service at B0 pinned llm commit, minion-mcp.service ENDO_SOCK environment, and deploy workflow ordering. Keep the two existing OCapN demo lanes undisturbed.

Validation required at deployed edge using the repo PKCE client: guest_write_text via https://minion.town/mcp; SSM endo list as daemon owner sees g-hash; restart endo-daemon; guest_read_text returns the durable note. Record concrete evidence. Do not wait for Claude OAuth validation.
