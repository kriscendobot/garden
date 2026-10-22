---
gate: blocked
blocked_on: endojs-endo-but-for-bots-pr1526-gauntlet
priority: normal
role: builder
arc: moonshots
posted_by: design-build-handoff
posted_at: 2026-10-22T01:54:45Z
---

---
role: builder
arc: moonshots
dispatch: automatic
tier: mentor
fallback-tier: minion
---
# Build: the design in endojs/endo-but-for-bots#1526

Repo: https://github.com/endojs/endo-but-for-bots. Design PR: https://github.com/endojs/endo-but-for-bots/pull/1526.

Build exactly the design produced by the completed designer job `design-endor-tui-phase-breakdown-open-pr` (its report is in `jobs/tada/`). Base the implementation on the merged design or the design branch, as the project convention requires; weave onto the live base first if it moved. Open a DRAFT PR: completion stages its gauntlet. Report a gap rather than weaken a property the design requires.

Dispatched by design-build-handoff.sh from the design report's follow-ups:

> - The completion machinery should stage the design-panel gauntlet for PR #1526.
> - **The endor-tui Phase 2 build (chat data path) is gated on the maintainer's answer** to the Phase 2 open question: a minimal Rust CapTP client over the existing socket (the recommendation) or a manager-side adapter serving the bus-verb table. It also waits on the #1526 gauntlet. Phases 3 to 8 depend on Phase 2, so they wait on it too.
