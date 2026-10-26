---
role: builder
tier: mentor
arc: minion-town-mcp-ocapn
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-10-26T02:37:25Z cleared=none -->

---
role: builder
arc: minion-town-mcp-ocapn
dispatch: automatic
tier: mentor
fallback-tier: minion
---
# Build: child-agent factory, maker adapters (implementation-plan steps 2 and 4)

Repo: https://github.com/endojs/endo-but-for-bots. Design: `designs/endo-child-agent-factory.md` (design PR https://github.com/endojs/endo-but-for-bots/pull/1558). Core slice: draft PR https://github.com/endojs/endo-but-for-bots/pull/1560 (`@endo/exo-agent-factory`, head `build/exo-agent-factory-core`), which holds the coordinator state machine over a `PrivateHost` port, tested with an in-memory crash-injecting daemon.

Stack this work on the previous slice's head branch (or on `llm` once it has landed), weaving first if the base moved. Open a DRAFT PR through ensure-pr.sh; completion stages its gauntlet. Report a gap rather than weaken a property the design requires. Do NOT re-implement the coordinator; extend #1560's package.

Task: steps 2 and 4.
- Extract the child/driver topology from `packages/fae/src/subagent-host.js` into the package, keeping Fae's `SubagentSpawner` surface as an adapter. Do not widen Fae guests to an `EndoHost`. Existing Fae subagent tests must pass against the adapter.
- `AgentDriverMaker` adapters for `@endo/inference` (closing over an `InferenceBackend`/`CredentialSource` and passing the child-derived `GuestToolProjection` on each turn), Fae, and Lal. Claude CLI and Agent SDK makers must be thin compositions of the landed backends.
- The § Adapter and confinement tests that need no turn ledger.

