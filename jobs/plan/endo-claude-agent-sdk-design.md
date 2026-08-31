---
gate: go-ahead
priority: normal
posted_by: liaison
posted_at: 2026-08-31T22:26:26Z
---

---
role: designer
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Design: the Claude Agent SDK as an alternative confinement substrate for `@endo/claude`

Repo: `endojs/endo-but-for-bots`. Base: `llm`.

Child 1 of 3 in the `endo-claude-agent-sdk-track` orchestration. This track runs
**alongside** the CLI track (design `designs/endo-claude.md`, build
[#1015](https://github.com/endojs/endo-but-for-bots/pull/1015), deployment companion
[kriscendobot/minion.town#64](https://github.com/kriscendobot/minion.town/pull/64));
it does not block or supersede them.

## Why this exists

`designs/endo-claude.md` confines `claude -p` with a five-flag stack whose
load-bearing claims it lists as *undocumented* and defers to a live test. The
Claude Agent SDK (`@anthropic-ai/claude-agent-sdk` / `claude-agent-sdk`) is the
same Claude Code harness exposed as a library, and it exposes several of those
same controls as **documented options**. It is therefore a candidate substrate for
the confinement half of the design — but **not** for its credential half.

Findings already established (do not re-derive; verify and cite):

- The SDK does **not** remove the Claude Code harness. Per
  https://code.claude.com/docs/en/agent-sdk/overview it "gives you the same tools,
  agent loop, and context management that power Claude Code", and both SDKs bundle
  a native Claude Code binary. It removes the CLI/TUI, not the harness.
- **The subscription premise does not survive.** The overview and the quickstart
  both carry: *"Unless previously approved, Anthropic does not allow third party
  developers to offer claude.ai login or rate limits for their products, including
  agents built on the Claude Agent SDK. Use the API key authentication methods
  described in the Quickstart instead."* Documented auth is `ANTHROPIC_API_KEY`,
  Bedrock, Claude Platform on AWS, Vertex, Foundry — all metered. This is a direct
  conflict with `endo-claude.md`'s opening premise ("a Max or Pro plan … **not a
  metered API key**").
- Confinement controls are **documented** where the CLI's are not:
  `settingSources: []` drops user/project/local settings, `CLAUDE.md`, and
  `.claude/` skills/commands/subagents; omitting it is documented as equivalent to
  `["user","project","local"]`. `strictMcpConfig` exists as an option.
- The SDK docs enumerate the residual surfaces `settingSources` does **not** cover
  (https://code.claude.com/docs/en/agent-sdk/claude-code-features): managed policy
  settings, `~/.claude.json` (always read; relocate via `CLAUDE_CONFIG_DIR`),
  auto-memory at `~/.claude/projects/<project>/memory/`
  (`autoMemoryEnabled: false` / `CLAUDE_CODE_DISABLE_AUTO_MEMORY=1`), and claude.ai
  MCP connectors. There is an explicit multi-tenant isolation warning naming
  `settingSources: []` + `CLAUDE_CODE_DISABLE_AUTO_MEMORY=1` + per-tenant
  filesystems, and noting server-managed settings survive filesystem isolation.
- One item is **new to the design and on-point**: *"claude.ai MCP connectors …
  Loaded when the session authenticates with your claude.ai login. Not loaded when
  `CLAUDE_CODE_OAUTH_TOKEN` holds a token from `claude setup-token`, which can only
  make model requests. Passing `mcpServers: {}` does not suppress the connectors."*
  That is documented evidence that **subscription-flavored auth itself opens an MCP
  discovery surface** — which argues `--strict-mcp-config` is load-bearing on the
  CLI path for a reason the design does not currently record, and names a
  model-requests-only token kind sitting between the two DD5 considers.

## What to produce

A design landed on `llm`. Decide bare-vs-PR by the standing rule (open questions →
review PR; none → land bare direct to `llm`).

- State plainly, up front, that the SDK **cannot** serve the subscription premise
  without prior Anthropic approval, and that this track is therefore about the
  **`paid` tier** of the `local | subscription | paid` ring `endo-claude.md`
  already gestures at (~line 1478) — not a replacement for the CLI path.
- Map each of the design's five CLI flags to its SDK equivalent (or to "no
  equivalent"), and mark which of the design's *undocumented* claims become
  *documented* under the SDK. Be strict about the design's own
  documented ≠ observed distinction: a documented SDK option is still not an
  observed one until child 2 measures it.
- Carry the residual-surface list across, reconciling it against what
  `endo-claude.md` already covers (it already handles `CLAUDE_CONFIG_DIR` at
  ~line 1530 and treats managed settings as an open question — do **not** report
  those as new gaps).
- Say how a `paid`-tier SDK backend would sit behind the existing DI seams in
  `packages/claude/harness.js` (the spawn seam) without disturbing the CLI path.
- Note the entitlement question is *settled negative* for the SDK, unlike the
  subscription path where it remains open.

## Out of scope

Do not modify `designs/endo-claude.md`, PR #1015, or minion.town#64. Do not
implement anything — children 2 and 3 own measurement and code.
