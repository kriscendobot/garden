---
role: builder
tier: mentor
arc: minion-town-claude-api
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-10-27T07:20:54Z cleared=none -->

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

# Phase 3: minion.town provider endpoint, UI step, and Providers page

Repo kriscendobot/minion.town. Implement build-plan phase 3, including the keyboard and assistive-technology requirements in the User experience section. Clips and pages must never see key material.


---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-10-27T07:21:04Z
