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
# Build: child-agent factory, reader-side reply collapse (implementation-plan step 6)

Repo: https://github.com/endojs/endo-but-for-bots. Design: `designs/endo-child-agent-factory.md` (design PR https://github.com/endojs/endo-but-for-bots/pull/1558). Core slice: draft PR https://github.com/endojs/endo-but-for-bots/pull/1560 (`@endo/exo-agent-factory`, head `build/exo-agent-factory-core`), which holds the coordinator state machine over a `PrivateHost` port, tested with an in-memory crash-injecting daemon.

Stack this work on the previous slice's head branch (or on `llm` once it has landed), weaving first if the base moved. Open a DRAFT PR through ensure-pr.sh; completion stages its gauntlet. Report a gap rather than weaken a property the design requires. Do NOT re-implement the coordinator; extend #1560's package.

Task: step 6. In the Fae and Lal conversation views, collapse byte-identical replies from the same sender that carry an equal `replyTo`, so each republished reply shows once. Change no daemon API. Add the end-to-end acceptance test from the design: a republished reply reaches the parent with its original `replyTo` and each view shows it once.

