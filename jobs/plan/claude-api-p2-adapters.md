---
gate: orchestrated
orchestrated_by: claude-api-build-20261027-resume
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

# Phase 2: provider adapters and accounting

Implement build-plan phase 2 (Anthropic API-key adapter first; other provider kinds only per the maintainer's answer to open question 1) with its tests. Depends on phase 1 being merged or its PR head available.

