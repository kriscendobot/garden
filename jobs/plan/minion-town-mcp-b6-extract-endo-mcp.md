---
gate: orchestrated
orchestrated_by: minion-town-mcp-daemon-guest-tools-orchestration
priority: high
role: builder
posted_by: gardener
posted_at: 2026-07-22T16:04:42Z
---

# B6: extract @endo/mcp (maintainer-gated)

Repositories: kriscendobot/minion.town and endojs/endo-but-for-bots.

After B5, perform only if the required maintainer acknowledgment for B6 is present. Implement B6 from designs/mcp-daemon-guest-tools.md §7-8: create the minion-town run-ahead branch in endojs/endo-but-for-bots, move reusable transport client, identity derivation, facet model, tool registration, and error mapping into packages/mcp, then consume a pinned dependency from minion.town so it retains deployment configuration and facet choice. Follow project isolation rules for both repositories.

Validation required: B1 integration suite runs in the endo repository and minion.town suite still passes against the dependency. If authorization is absent, do not perform cross-repository mutation; report the authorization blocker as orchestration-failed: true so this serial orchestration halts visibly.
