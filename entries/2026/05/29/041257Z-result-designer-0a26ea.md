---
ts: 2026-05-29T04:12:57Z
kind: result
role: designer
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: "*"
short_id: 0a26ea
refs:
  - entries/2026/05/29/040555Z-dispatch-designer-0a26ea.md
  - https://github.com/endojs/endo-but-for-bots/pull/376
---

# result: designer — endo-but-for-bots#376 draft, endo-gateway-mcp

## Deliverable

- **PR**: <https://github.com/endojs/endo-but-for-bots/pull/376> (DRAFT)
- **Title**: `design(endo-gateway-mcp): MCP JSON-RPC termination on the Endo Gateway`
- **Base**: `llm`
- **Head**: `design/endo-gateway-mcp`
- **Design file**: `designs/endo-gateway-mcp.md`

## Refactor-vs-export decision

The designer recommends **option (a): refactor Lal to extract a
reusable `@endo/agent-tools` package**. Rationale recorded in
`§ The MCP Adapter (Refactor vs. Export Recommendation)` and
restated as item 1 of `§ Design Decisions`. Three forces named:

1. Lal's architecture already treats the tool catalog as separable.
2. The Gateway has no LLM and binds tools per bearer, so an
   `@endo/lal` import is the wrong dependency edge.
3. Fae also wants the harness.

A one-line "Considered and rejected: option (b). Reason: …" steer
follows.

## Open questions surfaced (block builder dispatch until resolved)

1. Where the per-agent "expose to MCP" opt-in toggle lives (Lal
   manager form vs. Chat MCP tab).
2. Timing and conflict-resolution between built-in and
   capability-scoped tools as `daemon-agent-tools` lands.
3. Whether `initialize` advertises `resources` / `prompts`
   capabilities.
4. Per-bearer session state if MCP grows server-initiated tool
   calls.
5. `notifications/message` level mapping for tool diagnostics.

## Auxiliary Chat-UI surface

Kept within the same design (not split): a single "+ Add agent"
button on the spaces gutter routes to the existing
`lal-fae-form-provisioning` form; a per-agent "MCP" tab exposes a
paste-ready JSON block with the bearer and the endpoint URL.

## Pre-push gates

Em-dash style (clean), relative paths within `designs/`,
sentence-per-line markdown, all cross-links verified
(`designs/*.md`, `packages/lal/LAL-ARCHITECTURE.md`,
`packages/lal/CLAUDE.md`).

`designs/README.md` summary table updated with the new row.

## Liaison disposition

- Dispatch root `dispatches/designer--0a26ea/` to be torn down by
  the liaison after this entry.
- Next stage in the design panel chain is **solicitor** (the
  design-panel judge). Per the maintainer's session, the liaison
  leaves the post-draft chain to the steward's per-cycle PR-creation-
  flow scan rather than running the gamut in-session.
- The five open questions are the maintainer's to adjudicate. Once
  resolved on the PR thread, a fixer applies the resolutions to the
  design file; a builder dispatch can follow once the design is
  Implementation-ready.

Self-improvement: nothing this engagement (per the dispatched
designer's own report).
