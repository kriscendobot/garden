---
role: builder
tier: mentor
---
<!-- garden-promoted-from-plan: gate=blocked priority=normal at=2026-09-24T04:21:06Z cleared=none -->

---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Build the endo-guest-stdio-mcp design (endojs/endo-but-for-bots)

Maintainer kriskowal approved design PR #1226 with the directive "Conduct and pass to a builder":
https://github.com/endojs/endo-but-for-bots/pull/1226#pullrequestreview-5299606833

Once #1226 is merged to `llm`, implement `designs/endo-guest-stdio-mcp.md`: a stdio MCP server that exposes exactly one Endo guest's tool-call surface, identified by a 64-hex formula identifier, to a confined `claude -p`. This is arc kriscendobot/garden#89 item 5, the counterpart to the `endo-claude` caplet design. Follow the design's phasing and scope. Open a DRAFT PR against `llm` with ensure-pr.sh, and stop there. Under the manual-gauntlet regime, no gauntlet is staged.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-24T04:21:25Z
