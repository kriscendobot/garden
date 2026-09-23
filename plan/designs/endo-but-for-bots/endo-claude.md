---
slug: endo-claude
repository: endo-but-for-bots
status: In Progress
size: L
milestone: M3
roadmap_relevance: 100
depends_on: [endo-agent-tools]
pr: endo-but-for-bots#1015
created: 2026-08-16
updated: 2026-09-03
source: carved into M3 by groom-carve-mcp-bridge-milestone (2026-09-03)
---

# endo-claude — confined in-guest Claude inference (client-side bridge, M3 top priority)

One of the **two client-side-bridge capabilities** carved to the head of M3 on
2026-09-03 (the first unfinished milestone). It is the "confined in-guest agent"
half of the bottleneck class *get code/state across the MCP-daemon boundary
without an external LLM hand-marshaling bytes*: instead of an external agent
marshaling everything across the bridge by value, an agent runs **inside** a
guest and acts with normal tools directly on the daemon side.

`@endo/claude` is a confined `claude -p` that *is* an Endo guest's inference
engine, reaching only that one guest's facet as its whole tool surface.
Confinement is a **combination** of Claude Code flags (`--bare` +
`--strict-mcp-config` + `--setting-sources ""` + `--tools ""` +
`--disable-slash-commands`), a membership-validated facet-derived
`mcp__<server>__<tool>` allow-list, never `--resume`, inside a required
`@endo/claude-sandbox` OS slice.

- **Design:** `designs/endo-claude.md` on `endojs/endo-but-for-bots@llm` (added
  2026-08-16; design PR #995). Authoritative milestone placement: M3 (moved from
  M6 by the 2026-09-03 client-side-bridge carve — its true prerequisite, the
  `@endo/agent-tools` MCP-adapter projection `endo-agent-tools`, lives in M3).
- **Confinement core impl:** PR endo-but-for-bots#1015 (open draft) — `@endo/claude`
  + `@endo/claude-sandbox`, 56 passing tests.
- **Companion:** [[endo-claude-agents-capability]] (child-guest provisioning, #1102).
- **Ledger PR:** endo-but-for-bots#1127 (the groom that carved this into M3, spec only).
