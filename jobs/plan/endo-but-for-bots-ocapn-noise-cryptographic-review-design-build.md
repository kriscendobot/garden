---
gate: blocked
blocked_on: endojs-endo-but-for-bots-pr1475-gauntlet
priority: normal
role: builder
arc: endo-ocapn-background
posted_by: design-build-handoff
posted_at: 2026-10-16T17:56:58Z
---

---
role: builder
arc: endo-ocapn-background
dispatch: automatic
tier: mentor
fallback-tier: minion
---
# Build: the design in endojs/endo-but-for-bots#1475

Repo: https://github.com/endojs/endo-but-for-bots. Design PR: https://github.com/endojs/endo-but-for-bots/pull/1475.

Build exactly the design produced by the completed designer job `endo-but-for-bots-ocapn-noise-cryptographic-review-design` (its report is in `jobs/tada/`). Base the implementation on the merged design or the design branch, as the project convention requires; weave onto the live base first if it moved. Open a DRAFT PR: completion stages its gauntlet. Report a gap rather than weaken a property the design requires.

Dispatched by design-build-handoff.sh from the design report's follow-ups:

> - **Build: `build-ocapn-noise-cryptographic-review`.** This is one builder job to implement R1, R2 (once Q2 is answered) and R4 in `packages/ocapn-noise` and `packages/ocapn`. It should also amend `designs/ocapn-noise-session-reconnect.md` to drop the Resume path (R3). The design-build handoff machinery should post or park it behind the design gauntlet.
> - PR #1475 is left as a draft for the automatic design-panel gauntlet.
