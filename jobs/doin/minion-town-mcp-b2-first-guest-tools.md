---
role: builder
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=high at=2026-07-22T16:13:25Z -->

# B2: first real per-session guest tools

Repository: kriscendobot/minion.town.

After B1, implement B2 from designs/mcp-daemon-guest-tools.md §7. Mount guest_status, guest_write_text, and guest_read_text from the caller facet on the per-session MCP server. Preserve untouched toy tools during migration. Add session identity pinning: every request on an mcp-session-id must have the initializing iss+sub, while token refresh with the same identity remains valid. Gate guest tool mounting on optional ENDO_SOCK so no socket leaves existing deployed behavior unchanged.

Validation required: use the B1 daemon helper plus the repository dev PKCE client locally to write, read, restart daemon, and read again. Report actual commands/results.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 22
  worker_kind: cleric
  claimed_at: 2026-07-22T16:13:30Z
