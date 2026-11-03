---
posted_at: 2026-11-03T21:27:20Z
tier: mentor
fallback-tier: minion
dispatch: automatic
---
repo: https://github.com/kriscendobot/minion.town
design: https://github.com/kriscendobot/minion.town/pull/147 (designs/mcp-resources-getting-started.md, draft, 2026-10-04)
tracker: https://github.com/kriscendobot/minion.town/issues/227
task: Maintainer direction (2026-11-03): keep the MCP TOOL surface minimal, if anything smaller than today, and do the work through the `evaluate` tool. Do NOT add invite/accept MCP tools (they stay reserved/unimplemented). The guest and host agent facets already have invite/accept methods; an agent reaches them through evaluate. Instead, (a) augment the PRIMER (the roles and skills an agent is endowed with; see the memory/vision: a VFS snapshot of roles, skills and app code to graft) and (b) make the MCP server document, via MCP Resources plus the initialize `instructions` string, where an agent finds hints on using the Endo API surface.

Do:
1. Rebase/continue the #147 design into an implementation (draft PR): the resources and the getting-started guide, per that design's sections. Reconcile its stale advice: `powers: "sites"` and `"@agent"` are unsafe; recommend an inert pet name (see skills/minion-town-clip-publishing).
2. The guide must teach `evaluate` well, including its real behavior: `values` entries are NAMES of existing pet names, not literals (skills/minion-town-clip-publishing "evaluate gotchas"). Give worked, VERIFIED recipes using evaluate on the guest and host facets for: listing names, invite, accept, send/receive mail, and publish with an inert power. Verify each recipe against production with the existing MCP principal before documenting it, creating at most one throwaway invitation and no persistent guests.
3. Document, as resources, the places an agent should look for API hints: the facet interfaces (method names and shapes for guest/host: invite, accept, send, list, has, resolve, ...), where the Endo docs/designs live, and the pet-name conventions. Prefer pointing at stable sources and generating from the code over hand-copied prose so it cannot drift (the design's sync section).
4. Start the primer: a concrete first-cut file tree (roles + skills) for a new agent, written as plain files in the repo, with a short README saying how it is grafted into a guest's VFS. Seed it with what steps 2-3 learned.
5. Tool-surface audit: list every current MCP tool and mark which are replaceable by evaluate plus the guide. Propose removals in the PR description only; do not remove any tool.

Constraints: draft PR only; no deploy; no secrets in output. Report PASS/FAIL for each verified recipe and list anything evaluate cannot do that blocks the invite/accept flow, since each such finding is an Endo-interface or primer bug to log.

<!-- garden-productive-cycle -->
<!-- garden-deadline-overrun: 1 -->
<!-- garden-reap-now -->
---
claim:
  host: oros-studio-garden-ce242c49
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-11-03T21:29:22Z
