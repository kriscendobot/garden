---
role: fixer
tier: mentor
arc: minion-town-claude-api
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-10-27T04:15:18Z cleared=none -->

---
role: fixer
arc: minion-town-claude-api
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Arc tracker: https://github.com/kriscendobot/minion.town/issues/227 (read it fresh; post progress there as a comment, and add maintainer review asks to its "Review requests" table).
Spec: https://github.com/endojs/endo-but-for-bots/blob/design/claude-api-key-agents/designs/api-key-inference-providers-and-pinned-agents.md (PR https://github.com/endojs/endo-but-for-bots/pull/1543). Read the "Build and acceptance plan" phase named below and the sections it cites. Do not build on the retired subscription CLI path (see designs/claude-bare-course-correction.md on that PR).
If a design open question this phase depends on is still unanswered on the tracker or PR, ask it on the tracker and park with the awaiting-maintainer gate rather than guessing.

# Phase 0: clear the panel findings on the design PR

Address the outstanding panel must-fix findings on https://github.com/endojs/endo-but-for-bots/pull/1543 (head branch design/claude-api-key-agents), keep CI green, and stop. Do not resolve the design's open questions yourself; they are the maintainer's. When done, comment on the tracker with the head SHA and state that the PR is ready for maintainer review, and update the tracker's review-requests row 2.

