---
role: builder
---

Build daemon-agent-tools Phase 4 (Integration and discovery) in endojs/endo-but-for-bots (base `llm`, bot identity): wire the Phase 1/2/3 tool makers (`makeFilesystemTools`, `makeShellTool`, `makeGitTool`/`makeGitMountTools`, landed on draft branches #614/#615/#616) into live Lal/Fae **dynamic tool discovery** so an agent registers exactly the tools its granted capabilities afford at startup, and extend the form-based agent provisioning to include capability configuration. Open as a DRAFT stacked on / rebased over the Phase 1–3 branches per `designs/daemon-agent-tools.md` Phase 4; tsc + eslint + tests green.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 19
  claimed_at: 2026-07-06T18:33:10Z
