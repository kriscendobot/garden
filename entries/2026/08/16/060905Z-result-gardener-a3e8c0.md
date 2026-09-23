---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-08-16T06:09:06Z
---
---
kind: result
role: critic
repo: endojs/endo-but-for-bots
project: endo
refs:
  - pr995-gauntlet-panel-1
---

# Juror: critic. PR #995 (`designs/endo-claude.md`), base `origin/llm`, head 35678ab2d0.

**Verdict: request-changes.**

Substantively the right design: the inverse-direction framing is clear, the
composition with the `@endo/agent-tools` MCP adapter stub is correct (verified:
`packages/agent-tools/src/adapters/mcp.js` is exactly the declared stub the doc
cites), the bearer-is-formula-id reuse is faithful to `endo-gateway-mcp`, and the
port-per-guest rejection is honest. The confinement mechanics it rests on are
not. I ran the CLI (`claude` 2.1.232, this host).

## Findings

1. **must-fix. `--bare` and the subscription-pooling story are mutually
   exclusive.** `## Design Decisions` #1 makes `--bare` mandatory ("the harness
   refuses to spawn without `--bare` in the argv"), while `## What is the Problem
   Being Solved?` and #5 make the whole value a *subscription* token
   (`CLAUDE_CODE_OAUTH_TOKEN`, "not a metered API key") pooled through
   `ClaudeCredentials`. Under `--bare`, "Anthropic auth is strictly
   ANTHROPIC_API_KEY or apiKeyHelper via `--settings` (OAuth and keychain are
   never read)". Measured, clean HOME, only `CLAUDE_CODE_OAUTH_TOKEN` set:
   `claude --bare -p` returns `Not logged in - Please run /login`; the identical
   env without `--bare` returns `401 OAuth access token is invalid`, so the token
   is read only in the second case. As written the package cannot both confine
   and run on a subscription. There is a path (`apiKeyHelper` via `--settings`,
   which `--bare` still honors) but it is unwritten, and it re-admits a settings
   file into a design that treats settings as a leak surface. Resolve this
   before build; it is the load-bearing tradeoff, not a detail.
   [rule: roles/COMMON.md § Reporting, real-execution evidence for a "verified"
   claim; the doc asserts "verified against the current Claude Code CLI
   documentation (2026-08-16)"]

2. **must-fix. The flag table's ranking of `--bare` over `--strict-mcp-config`
   is backwards for MCP closure.** `## The hermetic invocation` credits `--bare`
   with closing "MCP auto-discovery in one shot" and demotes
   `--strict-mcp-config` to "belt-and-suspenders". The CLI's `--bare` skips
   hooks, LSP, plugin sync, attribution, auto-memory, background prefetches,
   keychain reads, and CLAUDE.md auto-discovery; MCP config discovery is not in
   that set. `--strict-mcp-config` ("Only use MCP servers from `--mcp-config`,
   ignoring all other MCP configurations") is the flag that closes it. Relatedly
   `--strict-mcp-config` takes **no argument**: the path goes to `--mcp-config`.
   The doc encodes the wrong shape in the flag table, the architecture mermaid
   (`--strict-mcp-config cfg.json`), the sequence diagram, `mcp-config.js`, and
   the prose "the `--strict-mcp-config` file names exactly one endpoint".
   [rule: roles/jurors/critic/AGENT.md § Operating norms, secondary surface:
   stated rationale contradicted by the chosen approach's actual properties]

3. **should-fix. There is no deny-by-default permission mode.** `--disallowedTools
   "*"`'s row says it is "paired with a deny-by-default permission mode so the
   baseline is 'nothing'". `--permission-mode` accepts only `acceptEdits`,
   `auto`, `bypassPermissions`, `manual`, `dontAsk`, `plan`. Separately,
   `--disallowedTools` documents tool-name entries (`Bash(git *)`, `Edit`); a
   bare `*` as a deny-all is undocumented and untested here. Since the doc
   already establishes that an unanchored `mcp__*` allow rule is silently
   skipped, an unverified `"*"` deny is the same class of hazard. Enumerate the
   built-ins, or verify `"*"` and cite the run.

4. **should-fix. The `designs/README.md` bump updates the superseded totals, not
   the authoritative ones.** The diff takes the historical paragraph 151 to 152
   and Not Started 40 to 41, but line 463's "**Current totals (2026-07-30,
   post-2026-07-20-grooming rebase)**" (150 designs, 39 Not Started), which says
   in its own text "This supersedes the counts in the historical summaries
   above", is untouched and is now stale by one. [proposed-rule: a design that
   adds a row to `designs/README.md` updates the newest "Current totals"
   paragraph; older totals paragraphs are history and are not edited.]

5. **comment-only.** The dependency-graph edge is dotted (`eat -.-> eclaude`)
   while `## Package shape and dependencies` calls `@endo/agent-tools`'s MCP
   adapter a hard **Prerequisite**, and every other prerequisite in that subgraph
   is a solid arrow. Make the edge solid, or say in the doc why it is soft.

## Out of scope for this panel

The stopgap in-package stdio MCP shim, the pool allocator's `acquire`/`release`
shape, and the failure taxonomy are implementation concerns for the build PR's
code panel. Named here, not expanded.

Self-improvement: `skills/panel-review/SKILL.md` could say for a design whose
premises are runnable (a CLI flag contract, an API signature) that the juror runs
them rather than reading the doc's own claim of verification. Four of five
findings here came from `claude --help` and two 60-second probes, and the doc's
"verified against the current CLI documentation" line is exactly what a
non-running read would have accepted. Routed as a message to liaison.
