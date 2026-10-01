---
role: designer
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Design: expose MCP Resources on minion.town's MCP server, and a getting-started skill for any connected agent

Maintainer directive (kriskowal, 2026-10-01, liaison session): "we seem to be
much more successful posting to ocap.site than an agent standing alone.
Perhaps we need to expose resources on our MCP server to assist any
connected agent. We would need to validate the resources and possibly
produce a skill that anyone can use to get started with the MCP and discover
the resources they need to succeed. For validation, we presumably need to
use a bare claude, just like the system we are setting up for running claude
under a subscription, confined to a guest, on minion.town."

## Why this is a real gap (observed firsthand)

The liaison session this request came from is itself attached to minion-town's
MCP server (`https://minion.town/mcp`, per `context/operations/minion-town-mcp.md`
§ Coverage, "interactive liaison sessions ... to attach by hand") with the same
16-tool surface a dispatched gardener job gets, and has been reliably publishing
clips to ocap.site this session. The difference is accumulated session context
and prior reads of `skills/minion-town-clip-publishing/SKILL.md` (CSP
constraints, the `powers` argument gotcha, the `Invalid pet name "@main"` fix
history, immutability). A standalone dispatched agent with only the bare MCP
tool surface (`tools/list`'s 16 tools, no resources) and no pre-loaded garden
skill has none of that — it has to rediscover the same gotchas from scratch or
fail outright. This generalizes beyond the garden fleet: it is also exactly the
problem a third-party agent connecting to minion.town's MCP server would face,
including whoever eventually uses the confined-Claude-on-minion.town system
being built right now (see below) under their own subscription.

## Ground this in real sources

- `context/operations/minion-town-mcp.md` — the standing connection
  architecture, the 16-tool surface, and the explicit "known gap" that
  interactive sessions aren't auto-attached.
- `skills/minion-town-clip-publishing/SKILL.md` and
  `skills/minion-town-mcp-playwright-login/SKILL.md` — the existing tribal
  knowledge this design should make independently discoverable.
- The confined-agent/"endo-claude" effort already in flight — this is "the
  system we are setting up for running claude under a subscription, confined
  to a guest, on minion.town" the directive refers to: `endojs/endo-but-for-bots`
  designs and PRs around confinement (`#1015` confinement core,
  `#1340`/`#1348` agent-tools and open questions, `#1403` `@endo/inference`,
  `#1407` guest-scoped daemon bootstrap, `#1408` claude-sandbox bwrap slice).
  Read whichever of these have landed or are closest to landing to understand
  what a "bare claude, confined to a guest" actually looks like today —
  this design's validation step should use that system if it's ready enough,
  or specify a simpler stand-in bare-Claude-plus-MCP-only harness if not.
- The MCP specification's **Resources** primitive (`resources/list`,
  `resources/read`, and resource templates) — distinct from Tools. This is
  the mechanism the directive is asking about: static/semi-static readable
  content a client can discover and fetch through the protocol itself,
  without any pre-loaded garden-specific skill file.

## What the design must specify

1. **Which resources to expose**, concretely — likely candidates: a
   getting-started guide, the clip-publishing gotchas (CSP, `powers`,
   immutability), a worked example (publish-a-clip end to end), and whatever
   else a cold agent would need to succeed at the tasks this MCP server's
   tools actually enable. Don't just dump the garden skill files verbatim —
   this content is read by agents with zero garden context, so it needs to
   stand alone (no references to garden-specific paths, roles, or jobs).
2. **Where this lives and how it's served.** Identify the actual
   minion.town MCP server implementation (which package/repo) and specify
   how it adds a `resources/list` + `resources/read` handler, and how
   resource content is authored/updated (a markdown file the server reads at
   request time, ideally, so updating the guidance doesn't require a server
   redeploy for content changes alone).
3. **A validation methodology using a cold, context-free agent** — per the
   directive, a bare Claude instance (the confined-guest-on-minion.town
   system if it's ready, or a minimal stand-in otherwise) with **no**
   garden skill files loaded and **no** prior session context, connected
   only to the MCP server, attempting a real task (e.g., "publish a clip to
   ocap.site") using *only* what it can discover via `tools/list` and the
   new `resources/list`/`resources/read` calls. Success criterion: it
   completes the task without hitting the known gotchas blind, or at least
   without needing anything beyond what the resources taught it.
4. **A getting-started skill.** Decide whether this is (a) a garden skill
   (`skills/<name>/SKILL.md`) for the fleet's own benefit, (b) content
   published as one of the MCP resources themselves for any external agent's
   benefit, or (c) both — and if both, how they stay in sync rather than
   drifting into two competing tellings of the same material.

## Non-goals

This is not a redesign of the MCP server's tool surface, the OAuth/token
bridge architecture, or the client-credentials-principal/security question
already parked separately (`context/operations/minion-town-mcp.md` §
Open decisions — the shared `minion-mcp-test-cc` principal question the
maintainer already addressed by leaving as-is for now). This design is
scoped to discoverability for a connected agent, not access control.

---
claim:
  host: oros-studio-garden-ce242c49
  gardener: 3
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-01T21:04:48Z
