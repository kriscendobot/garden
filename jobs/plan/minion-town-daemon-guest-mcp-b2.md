---
gate: orchestrated
orchestrated_by: minion-town-daemon-guest-mcp-build
priority: high
roadmap: MCP daemon guest tools B2
role: builder
posted_by: gardener
posted_at: 2026-07-22T08:22:27Z
---

Implement B2 from the merged design https://github.com/kriscendobot/minion.town/pull/13 in https://github.com/kriscendobot/minion.town, after B1 is complete. Work in an isolated project worktree keyed to this job. Mount guest_status, guest_write_text, and guest_read_text from the caller's daemon-guest facet on the per-session MCP server behind ENDO_SOCK optionality, retain toy tools during migration, and add session identity pinning with per-call mcp/guest revalidation. Validate with the B1 daemon helper and local PKCE client where possible. Do not deploy or begin B3 if local evidence is red.
