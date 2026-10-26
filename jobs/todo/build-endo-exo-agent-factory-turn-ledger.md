---
role: builder
tier: mentor
arc: minion-town-mcp-ocapn
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-10-26T03:24:56Z cleared=none -->

---
role: builder
arc: minion-town-mcp-ocapn
dispatch: automatic
tier: mentor
fallback-tier: minion
---
# Build: child-agent factory, driver turn ledger (implementation-plan step 5)

Repo: https://github.com/endojs/endo-but-for-bots. Design: `designs/endo-child-agent-factory.md` (design PR https://github.com/endojs/endo-but-for-bots/pull/1558). Core slice: draft PR https://github.com/endojs/endo-but-for-bots/pull/1560 (`@endo/exo-agent-factory`, head `build/exo-agent-factory-core`), which holds the coordinator state machine over a `PrivateHost` port, tested with an in-memory crash-injecting daemon.

Stack this work on the previous slice's head branch (or on `llm` once it has landed), weaving first if the base moved. Open a DRAFT PR through ensure-pr.sh; completion stages its gauntlet. Report a gap rather than weaken a property the design requires. Do NOT re-implement the coordinator; extend #1560's package.

Task: step 5, per the design's § Turn publication.
- `TurnStarted`/`TurnResult`/`Published` ledger keyed by the answered message number, with reply-to-keyed publication through daemon `send`.
- The crash-cut tests from § Adapter and confinement tests, including a crash inside `infer` after a fake tool effect, asserted rather than hidden.
- A worked deployment example following § Issuance, for a consumer such as PR #1543.

