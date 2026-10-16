---
gate: blocked
blocked_on: endojs-endo-but-for-bots-pr1480-gauntlet
priority: normal
role: builder
arc: endo-ocapn-background
posted_by: design-build-handoff
posted_at: 2026-10-16T19:41:40Z
---

---
role: builder
arc: endo-ocapn-background
dispatch: automatic
tier: mentor
fallback-tier: minion
---
# Build: the design in endojs/endo-but-for-bots#1480

Repo: https://github.com/endojs/endo-but-for-bots. Design PR: https://github.com/endojs/endo-but-for-bots/pull/1480.

Build exactly the design produced by the completed designer job `endo-but-for-bots-ocapn-tcp-for-test-extraction-design-pr-open` (its report is in `jobs/tada/`). Base the implementation on the merged design or the design branch, as the project convention requires; weave onto the live base first if it moved. Open a DRAFT PR: completion stages its gauntlet. Report a gap rather than weaken a property the design requires.

Dispatched by design-build-handoff.sh from the design report's follow-ups:

> - build `ocapn-tcp-for-test-extraction` (one builder job, implementation PR rooted at `master`)
> - The completion machinery stages the design gauntlet and the build handoff; I did not post either by hand.
