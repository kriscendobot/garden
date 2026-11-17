---
gate: blocked
blocked_on: endojs-endo-but-for-bots-pr1671-gauntlet
priority: normal
role: builder
arc: unallocated
posted_by: design-build-handoff
posted_at: 2026-11-17T12:01:23Z
---

---
role: builder
arc: unallocated
dispatch: automatic
tier: mentor
fallback-tier: minion
---
# Build: the design in endojs/endo-but-for-bots#1671

Repo: https://github.com/endojs/endo-but-for-bots. Design PR: https://github.com/endojs/endo-but-for-bots/pull/1671.

Build exactly the design produced by the completed designer job `design-endopi-prompt-templates` (its report is in `jobs/tada/`). Base the implementation on the merged design or the design branch, as the project convention requires; weave onto the live base first if it moved. Open a DRAFT PR: completion stages its gauntlet. Report a gap rather than weaken a property the design requires.

Dispatched by design-build-handoff.sh from the design report's follow-ups:

> - **Build:** rework the existing draft #1640 to match this design (the "Delta from #1640" list), rather than opening a new build PR. #1640 also edits this design file, so it will need a rebase.
> - I left #1671 as a draft; the completion machinery records its design-panel gauntlet.
