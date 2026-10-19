---
role: builder
tier: mentor
arc: unallocated
---
<!-- garden-promoted-from-plan: gate=blocked priority=normal at=2026-10-19T13:41:27Z cleared=none -->

---
role: builder
arc: unallocated
dispatch: automatic
tier: mentor
fallback-tier: minion
---
# Build: the design in endojs/endo-but-for-bots#1497

Repo: https://github.com/endojs/endo-but-for-bots. Design PR: https://github.com/endojs/endo-but-for-bots/pull/1497.

Build exactly the design produced by the completed designer job `daemon-agent-tools-design` (its report is in `jobs/tada/`). Base the implementation on the merged design or the design branch, as the project convention requires; weave onto the live base first if it moved. Open a DRAFT PR: completion stages its gauntlet. Report a gap rather than weaken a property the design requires.

Dispatched by design-build-handoff.sh from the design report's follow-ups:

> - Build: Phase 2c, the sandbox shell engine, as specified in § Next Slice of `designs/daemon-agent-tools.md`. That is the next builder job once the design gauntlet passes.
> - Open Question 4 (daemon `provideHttpClient` formula or `@endo/fetch` plugin) needs a maintainer decision before Phase 8 can proceed.
> - Unrelated to this job: the "Not Started" status that produced this job's prompt must come from somewhere other than the `designs/README.md` M3 row, which already said In Progress. Whatever produced it may need correcting.
