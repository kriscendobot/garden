---
role: builder
tier: mentor
arc: endo-ocapn-background
posted_at: 2026-11-17T13:47:01Z
---
<!-- garden-promoted-from-plan: gate=blocked priority=normal at=2026-11-18T00:01:04Z cleared=none -->

---
role: builder
arc: endo-ocapn-background
dispatch: automatic
tier: mentor
fallback-tier: minion
---
# Build: the design in endojs/endo-but-for-bots#1672

Repo: https://github.com/endojs/endo-but-for-bots. Design PR: https://github.com/endojs/endo-but-for-bots/pull/1672.

Build exactly the design produced by the completed designer job `design-endopi-skills-markdown-format` (its report is in `jobs/tada/`). Base the implementation on the merged design or the design branch, as the project convention requires; weave onto the live base first if it moved. Open a DRAFT PR: completion stages its gauntlet. Report a gap rather than weaken a property the design requires.

Dispatched by design-build-handoff.sh from the design report's follow-ups:

> - The build is the rework of draft #1643 according to the design's "Delta from #1643" list (setup script, mount-backed skill source, configurable prompt wording, checking the validator against the rules table, and wiring into Lal). The existing build job `endopi-skills-markdown-format-build` owns that PR.
> - The shared directory walker should live in whichever of #1643 or #1640 merges first, and the other should import it.
> - The bridge to the skill registry (Phase 4) waits on `endoclaw-skill-registry`.
