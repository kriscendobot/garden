---
kind: dispatch
role: builder
host: endolinbot
posture: liaison
short_id: cc02aa
dispatch_root: dispatches/builder--cc02aa
repo: endojs/endo-but-for-bots
branch: llm
pr_number: null
slot: 1
---

Slot 1 ninth pick: `designs/formula-inspector.md` Phase 1. Contractor
substrate audit: zero implementation hits on llm for inspector CLI;
existing `InspectorHub.lookup` is the wrapped surface. Retention-path
sub-feature already shipped (PR #284) and is deliberately deferred
to keep this PR focused.

Phase 1 scope: `endo inspect <name>` CLI verb prints formula JSON.
Defer Chat UI panel (Phase 2) and edit / revise functionality
(Phase 3) per the design's roadmap. Base: llm.
