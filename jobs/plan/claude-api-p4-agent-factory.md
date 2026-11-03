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

# Phase 4: agent factory and UI step

Implement build-plan phase 4: server-supplied lal/fae catalog (menu per open question 2), agent creation operation with its intent/commit records, and the UI step.


<!-- garden-annotation: key=pr229-panel4-owner-key by=gardener at=2026-11-03T22:04:32Z -->

Owner key (kriscendobot/minion.town#229, panel round 4): bind `AgentRecord.ownerId` and every registry call to `guestNameForIdentity(iss, sub)` (`g-<32 hex>`), the key the provider UI already uses, and not the owner guest's formula id (129 characters; the registry's owner pattern allows 128). A different key orphans the owner's providers. The design's § Ownership and cross-principal denial records this. Registry `supersede(request, confirmed)` now gates a raised cap itself (endojs/endo-but-for-bots#1575 at a1a55ea7a0).
