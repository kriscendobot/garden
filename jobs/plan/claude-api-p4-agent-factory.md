---
gate: orchestrated
orchestrated_by: claude-api-build-20261027
priority: normal
posted_by: producer
posted_at: 2026-10-27T04:11:50Z
---

---
role: builder
arc: minion-town-claude-api
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Arc tracker: https://github.com/kriscendobot/minion.town/issues/227 (read it fresh; post progress there as a comment, and add maintainer review asks to its "Review requests" table).
Spec: https://github.com/endojs/endo-but-for-bots/blob/design/claude-api-key-agents/designs/api-key-inference-providers-and-pinned-agents.md (PR https://github.com/endojs/endo-but-for-bots/pull/1543). Read the "Build and acceptance plan" phase named below and the sections it cites. Do not build on the retired subscription CLI path (see designs/claude-bare-course-correction.md on that PR).
If a design open question this phase depends on is still unanswered on the tracker or PR, ask it on the tracker and park with the awaiting-maintainer gate rather than guessing.

# Phase 4: agent factory and UI step

Implement build-plan phase 4: server-supplied lal/fae catalog (menu per open question 2), agent creation operation with its intent/commit records, and the UI step.

