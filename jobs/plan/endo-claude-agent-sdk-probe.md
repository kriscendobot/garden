---
gate: go-ahead
priority: normal
posted_by: liaison
posted_at: 2026-08-31T22:26:37Z
---

---
role: builder
tier: mentor
fallback-tier: minion
handler-timeout: 10800
dispatch: automatic
---

# Probe: measure the Agent SDK's confinement claims against a live run

Repo: `endojs/endo-but-for-bots`. Base: `llm`. Child 2 of 3 in
`endo-claude-agent-sdk-track`. Follows the design child.

Run under [gap-revealing-build](skills/gap-revealing-build/SKILL.md): a DRAFT PR
that **stays draft** and delivers a structured measurement report. The deliverable
is evidence, not a feature.

`designs/endo-claude.md` insists on the distinction between a **documented** claim
(readable off `--help`) and an **observed** one (confirmed by a live spawn), and
keeps a live negative-and-positive confinement test on its checklist. The Agent
SDK's confinement options are documented; this job promotes them to observed, or
finds where they don't hold.

## Measure, with a real SDK run

For each item, record the actual observed behavior and how you observed it:

**Negative (the surface is closed):**
- Does `settingSources: []` actually prevent a `CLAUDE.md` in `cwd` and a parent
  directory from entering the system prompt?
- Does it actually prevent `.claude/skills/*/SKILL.md` from being discovered, and
  is the `Skill` tool absent? Cross-check the `skills` option (`[]` vs omitted).
- Does it prevent `.claude/settings.json` hooks from firing?
- Does `strictMcpConfig: true` prevent a `.mcp.json` server from being added?
- Confirm the documented residuals really are residual: `~/.claude.json`,
  auto-memory under `~/.claude/projects/<project>/memory/`, and (if reachable)
  claude.ai MCP connectors. Confirm `CLAUDE_CONFIG_DIR` and
  `CLAUDE_CODE_DISABLE_AUTO_MEMORY=1` close the two that are closeable.
- Does an inherited `ANTHROPIC_API_KEY` in the parent environment get picked up?
  (`packages/claude/child-env.js` exists because the CLI does — check the SDK.)

**Positive (the surface the design needs SURVIVES):**
- With built-ins denied, do `mcp__<server>__<tool>` tools from a programmatically
  configured `mcpServers` entry remain callable? This is the half that makes
  confinement useful rather than merely tight; the CLI design flags the equivalent
  (`--tools ""` vs MCP survival) as an undocumented load-bearing gap.
- Does the SDK honour an allow-list of literal `mcp__…` names, and does an
  unanchored `mcp__*` wildcard grant or not? The CLI's silent-ignore of `mcp__*`
  is the design's *"wildcard trap"* — determine whether the SDK repeats it.

**Auth (confirm the blocker):**
- Confirm empirically what the docs state: that no subscription/claude.ai-login
  path is available. Do **not** attempt to circumvent it, work around the
  restriction, or test undocumented credential paths — record the documented
  position and stop. If an approved-partner path exists, note that it is a
  business question for the maintainer, not something to probe.

## Deliverable

A draft PR against `llm` whose body is the measurement table: claim, documented
or not, observed result, how measured, SDK version and platform. Where a claim
fails, say so plainly — a negative result is the point of a probe. Pin the exact
SDK and bundled-Claude-Code versions; the CLI design pins `2.1.232` and version
drift is the known hazard.

No production code. Test fixtures and a throwaway harness are fine.
