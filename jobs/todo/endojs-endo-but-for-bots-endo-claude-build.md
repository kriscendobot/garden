---
tier: mentor
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-08-17T05:25:03Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Builder: implement @endo/claude per merged design

Repo: endojs/endo-but-for-bots  (bot repo)
Design source (merged into llm by the preceding orchestration steps):
  designs/endo-claude.md
Companion / prerequisite context named in the design:
  - @endo/claude-sandbox (already in repo; ClaudeCredentials caplet to EXTEND
    with a subscription credential kind)
  - the planned @endo/agent-tools MCP adapter (facet-to-MCP projection)
  - endo-gateway-mcp bearer-is-formula-id auth (loopback-HTTP transport)

The maintainer (kriskowal) directed "Post a builder" in the PR #995 approval.
Build the @endo/claude package described by designs/endo-claude.md: a confined
`claude -p` giving an Endo guest inference from a Claude subscription, whose only
capability surface is one granted guest facet projected as MCP tools.

Key invariants from the design (honor them):
  - Confinement is a COMBINATION of flags: --bare + --strict-mcp-config +
    --setting-sources "" + --tools "" (fail-closed baseline) + --disable-slash-commands;
    never --resume/--continue. Per-guest allow-list generated & membership-validated
    from the facet's method set (mcp__* is silently ignored as an allow rule).
  - Requires the @endo/claude-sandbox OS slice; the boundary rests on it, not an env scrub.
  - Primary export: a maker make(powers) yielding a per-guest passable `infer` exo
    closing over one resolved facet at grant time; type-tagged hardened record return.
  - Catalog lookups keyed through a hardened null-prototype record, never a bare Map.
  - Fresh process per call by default; the optional threaded/follow-up session is a
    capability-gated, facet-exposed opt-in (per the merged refinement).

The design lists genuine OPEN QUESTIONS (inference trigger guest-request vs
operator-driven; whether --setting-sources "" suppresses managed settings; pool
allocator quota-accounting source; exact payload fields of rarer failure cases).
Where an open question blocks a correct implementation, prefer the safest
confinement-preserving choice and note the assumption in the PR body rather than
guessing silently; if a whole sub-area is unresolvable, a gap-revealing DRAFT is
acceptable over a wrong committal.

Definition of done: a builder-standard draft PR against llm implementing
@endo/claude with tests (including the version-specific negative-confinement
test the design calls for), which then auto-runs the gauntlet per the standard
build flow.
