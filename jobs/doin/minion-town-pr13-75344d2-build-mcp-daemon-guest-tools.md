Repository: kriscendobot/minion.town. PR #13 landed a merged, build-organizing design doc `designs/mcp-daemon-guest-tools.md` (successor to `designs/mcp-endo-guest.md`), retiring the toy MCP server in favor of real daemon-guest-backed MCP tools. It fixes concrete decisions: endo-daemon.service at a pinned llm commit as substrate, a thin CapTP client destined for `@endo/mcp` extraction, and per-session facet-derived MCP tools with session identity pinning. It specifies a build decomposition B0–B6, each with concrete non-Claude validation hooks. Mandated by kriskowal/garden#58.

Begin implementing this design. Because it is a multi-part build (B0–B6), decompose it into an ORCHESTRATION job: park B0–B6 as orchestrated child build jobs and post one orchestration job (serial, halt-on-child-failure) that promotes them in sequence and watches each to completion. Read the design doc first for the exact per-step scope and validation hooks. Start from B0.

<!-- garden-reaped: 2 -->

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 20
  worker_kind: cleric
  claimed_at: 2026-07-22T16:03:08Z
