---
gate: blocked
blocked_on: endojs-endo-but-for-bots-pr1558-gauntlet
priority: normal
role: builder
arc: minion-town-mcp-ocapn
posted_by: design-build-handoff
posted_at: 2026-10-26T00:36:30Z
---

---
role: builder
arc: minion-town-mcp-ocapn
dispatch: automatic
tier: mentor
fallback-tier: minion
---
# Build: the design in endojs/endo-but-for-bots#1558

Repo: https://github.com/endojs/endo-but-for-bots. Design PR: https://github.com/endojs/endo-but-for-bots/pull/1558.

Build exactly the design produced by the completed designer job `design-endo-claude-agents-capability-20261026` (its report is in `jobs/tada/`). Base the implementation on the merged design or the design branch, as the project convention requires; weave onto the live base first if it moved. Open a DRAFT PR: completion stages its gauntlet. Report a gap rather than weaken a property the design requires.

Dispatched by design-build-handoff.sh from the design report's follow-ups:

> 
> - Build `build-endo-child-agent-factory` after the draft design gauntlet converges.
> 
> Self-improvement: nothing this time.
