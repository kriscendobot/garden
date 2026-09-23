---
gate: orchestrated
orchestrated_by: garden-tada-shard-orchestration
priority: normal
posted_by: producer
posted_at: 2026-08-13T21:30:29Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
role: builder
handler-timeout: 7200
repo: kriskowal/garden (main2, direct push; no PR)

Stage 5, the last of the `jobs/tada/` date-sharding chain.

**Precondition:** stage 4's migration is complete and verified, and no flat
entries remain. Confirm that directly rather than assuming; if any flat entry
survives, STOP and report.

1. **Retire the flat-path fallback** added in stage 2, so the layout has exactly
   one shape and no dead branch pretending otherwise. Keep the centralized
   `common.sh` helpers — those are the durable win, and they are what makes the
   next layout change cheap.
2. **Deliver the thing the maintainer actually asked for:** make recently
   completed work easy to find. A date-sharded tree enables that but does not by
   itself provide it. Add the affordance the design specifies (a recent-window
   lister, a bulletin section, or similar) and say in your report how someone now
   answers "what completed today, and this week".
3. **Update the docs and skills** that describe the flat layout:
   `skills/journalism/SKILL.md`, `skills/review-retrospective/SKILL.md`,
   `skills/pr-creation-flow/SKILL.md`, `CLAUDE.md` where it describes the board,
   and `designs/job-board.md`. A stale description of the board is how the next
   agent writes a flat path.
4. Full test suite green.
