---
gate: orchestrated
orchestrated_by: orchestrate-endo-exo-agent-factory-remaining
priority: normal
posted_by: producer
posted_at: 2026-10-26T02:09:51Z
---

---
role: builder
arc: minion-town-mcp-ocapn
dispatch: automatic
tier: mentor
fallback-tier: minion
---
# Build: child-agent factory, daemon wiring (implementation-plan step 3, daemon side)

Repo: https://github.com/endojs/endo-but-for-bots. Design: `designs/endo-child-agent-factory.md` (design PR https://github.com/endojs/endo-but-for-bots/pull/1558). Core slice: draft PR https://github.com/endojs/endo-but-for-bots/pull/1560 (`@endo/exo-agent-factory`, head `build/exo-agent-factory-core`), which holds the coordinator state machine over a `PrivateHost` port, tested with an in-memory crash-injecting daemon.

Stack this work on the previous slice's head branch (or on `llm` once it has landed), weaving first if the base moved. Open a DRAFT PR through ensure-pr.sh; completion stages its gauntlet. Report a gap rather than weaken a property the design requires. Do NOT re-implement the coordinator; extend #1560's package.

Task: implement the daemon side of step 3.
- A `PrivateHost` over a real `agent-factory` child host (`provideHost`). Add `formulaType`/`powersOf` support from the daemon's locator/formula surface, or report the gap if the daemon exposes no way to read an unconfined caplet's powers.
- The coordinator as one `makeUnconfined('@main', specifier, { powersName: 'agent-factory' })` formula, pinned in the root host's `@pins`.
- Durable `evaluate` facet formulas (`boundFacet(nsId)`, `lifecycleFor(opKey)`), so held facets and a revived runner's lifecycle work after restart without being re-issued. This replaces #1560's in-memory exos.
- Daemon-backed recovery tests for the design's § Recovery matrix items that need a real daemon: restart revival with no holder call or mail, a child that clears its own `@pins`, facets surviving restart, and a revoked facet that rejects after restart.

