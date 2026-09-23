---
ts: 2026-05-29T04:12:01Z
kind: result
role: designer
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
prs:
  - endojs/endo-but-for-bots#376
refs:
  - dispatch-root: dispatches/designer--0a26ea
---

Drafted `designs/endo-gateway-mcp.md` on branch `design/endo-gateway-mcp`, base `llm`, opened as draft PR endojs/endo-but-for-bots#376.

The design proposes a second termination point on the Endo Gateway alongside the existing OCapN surface: a `POST /mcp` + `GET /mcp` (SSE) endpoint that terminates the streamable-HTTP variant of the Model Context Protocol. Bearer is the 64-char hex formula identifier from `gateway-bearer-token-auth.md` verbatim, reusing the per-IP rate limiter. The Gateway speaks plaintext on the MCP path; TLS is the reverse proxy's job, same assumption as the rest of the Gateway.

**Refactor-vs-export recommendation:** option (a), extract `@endo/agent-tools` from `packages/lal/agent.js`. Three forces in §"The MCP Adapter (Refactor vs. Export Recommendation)": the Lal-Architecture doc already names the tool catalog as separable; the Gateway has no LLM and binds tools to a `EndoGuest` per bearer, so an `@endo/lal` import is the wrong dependency edge for the Gateway; and Fae already wants the same harness for dynamic tool discovery per `daemon-agent-tools.md`. One-line considered-and-rejected for option (b) included.

Chat-side UI sketched as two sections in the same design (one button on spaces gutter, one MCP tab per agent), not a sibling design, because each is small and load-bearing.

Open questions that block a builder dispatch:
1. Where the per-agent "expose to MCP" opt-in toggle lives.
2. Timing and ordering of capability-scoped tools from `daemon-agent-tools.md` in the MCP catalog.
3. Whether `initialize` advertises `resources` and `prompts` capabilities.
4. Per-bearer session state shape if MCP grows server-initiated tool calls.
5. `notifications/message` level mapping for tool diagnostics.

Pre-push gates: em-dash style (no em-dashes; verified by grep), relative-paths (all design cross-links are relative within `designs/`; the one journal-side reference that would have crossed worktrees was removed), sentence-per-line markdown (each sentence on its own line in prose paragraphs), no broken cross-links (every `[name](path.md)` target exists in the project worktree; verified the LAL-ARCHITECTURE.md and CLAUDE.md paths point at real files).

`designs/README.md` summary table updated with a row for the new design.

Self-improvement: nothing this time.
