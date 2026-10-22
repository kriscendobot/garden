---
role: builder
tier: mentor
arc: moonshots
---
<!-- garden-promoted-from-plan: gate=blocked priority=normal at=2026-10-22T04:36:04Z cleared=none -->

---
role: builder
arc: moonshots
dispatch: automatic
tier: mentor
fallback-tier: minion
---
# Build: the design in endojs/endo-but-for-bots#1528

Repo: https://github.com/endojs/endo-but-for-bots. Design PR: https://github.com/endojs/endo-but-for-bots/pull/1528.

Build exactly the design produced by the completed designer job `design-endor-bus-tui-phase-breakdown-open-pr` (its report is in `jobs/tada/`). Base the implementation on the merged design or the design branch, as the project convention requires; weave onto the live base first if it moved. Open a DRAFT PR: completion stages its gauntlet. Report a gap rather than weaken a property the design requires.

Dispatched by design-build-handoff.sh from the design report's follow-ups:

> - The design-panel gauntlet for #1528, which the completion machinery stages from the URL above.
> - Once that gauntlet passes: the build of endor-bus-tui Phase 1 (daemon region store and text/buffer verbs).
