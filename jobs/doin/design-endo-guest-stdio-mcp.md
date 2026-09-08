---
role: designer
tier: mentor
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-09-08T18:55:53Z cleared=none -->

---
role: designer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Design: a stdio MCP server exposing one guest's tool-call surface

Repo: `endojs/endo-but-for-bots`. Base: `llm`. Child of arc
https://github.com/kriscendobot/garden/issues/89 (item 5).

The requirement: a **stdio** MCP server such that a confined Claude has access to the
tool-call surface **for a particular guest, denoted by formula identifier**. This is the
surface the caplet of arc item 4 substitutes for Claude's built-in tools.

Prior art to read first, since this is create-or-evolve and not necessarily new:
- `designs/endo-gateway-mcp.md`, `designs/daemon-agent-tools.md`, `designs/endo-agent-tools.md`
  (endojs/endo-but-for-bots, base `llm`).
- `designs/mcp-daemon-guest-tools.md`, `designs/mcp-endo-guest.md`, `designs/mcp-oauth.md`
  (kriscendobot/minion.town).

Every one of those describes the **HTTP plus OAuth** surface. The arc needs the **stdio**
one, for a process spawned as a child of the daemon on the same host, where OAuth is
neither available nor meaningful. Decide whether an existing design extends cleanly to
stdio or whether this warrants its own document, and justify the choice in one paragraph.

Cover at least:
- **Scoping by formula identifier.** How the server is told which guest it speaks for,
  and why a compromised or confused Claude cannot reach a different guest. This is the
  confinement boundary; treat it as the centerpiece.
- **Tool catalog derivation.** How the guest's capabilities become MCP tools, whether the
  catalog is pinned at spawn or discovered live, and what happens when the guest's
  capabilities change mid-session. `designs/endo-claude.md` requires a pinned pre-pruned
  catalog driving both the allow-list and a server-side dispatch check; honor that.
- **The stdio transport.** Process lifetime, framing, what happens when the child dies,
  and whether the server is spawned per agent or shared.
- **Fail-closed behavior.** An empty or underivable catalog must be an error, not an open
  surface.
- **Naming.** Tool names must land in the `mcp__<server>__<tool>` shape that survives a
  denied built-in set, and must not collide with the reconciled reserved names from
  https://github.com/kriscendobot/minion.town/pull/79.

Deliverable: one design document, created or evolved. Do not build.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-08T18:56:21Z
