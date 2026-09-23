---
ts: 2026-06-18T08:44:35Z
kind: result
role: solicitor
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
refs:
  - entries/2026/06/18/084435Z-dispatch-solicitor-828d9d.md
---

R2 design-panel pass on PR #450 (designs: Add presence-severance-observation).

Panel kind: design-panel (7 seats, in-band fallback; Agent tool not available).
Panel execution: in-band-fallback.
Round: R2 (R1 was kriskowal CHANGES_REQUESTED; 5 asks addressed in 994c1a86b).

panel-hints.sh output: script returned code-panel due to comparison against origin/master spanning full branch history.
Override applied: PR diff (HEAD~1..HEAD) is a single design file (designs/presence-severance-observation.md); panel routed to design-panel as correct classification.

Seats dispatched: critic, skeptic, decomplector, ergonomist, copyeditor, pedant, novice (all 7 design-panel seats).

Disposition counts: must-fix-loop: 0 / summary-fix: 0 / follow-up: 4 / acknowledge: 2 / drop: 0.
Overall verdict: COMMENT (no must-fix-loop items).

Review submitted: gh pr review 450 -R endojs/endo-but-for-bots --comment (review id 4523213324, submitted 2026-06-18T08:43:48Z).

Follow-up items (4) appended to journal/projects/endo-but-for-bots/followups/endo-but-for-bots--450.md (created):
1. Concrete type/shape of severance promise rejection reason (critic/skeptic) — verify on implementation PR.
2. Test vectors for all three sub-cases: transport-level, object-level (CTP_DROP), permission-revoked (skeptic).
3. Routing of permission-revoked sub-case through CTP_DISCONNECT (skeptic).
4. Behavior of E.whenSevered on an already-severed presence at call time (skeptic).

Acknowledge items (2, no work warranted):
1. Line-number cites for presenceToHandler/presenceToPromise WeakMaps will become stale on refactor (skeptic).
2. "HandledPromise primitives" heading sentence case vs title case in sibling headings (pedant).

Proposed-rules message to gardener: entries/2026/06/18 (4 proposed rules).

Post-loop actions:
- No summary-fix items; no job-board post.
- Followup ledger created (status: parked).
- Gardener message written with 4 proposed-rule items.
- No un-draft this round: this is R2 (a COMMENT round); un-draft is post-loop per roles/solicitor/AGENT.md when no must-fix-loop items remain. Round is terminating; liaision should dispatch appellate or proceed directly to gh pr ready 450.

Next stage: appellate (to appeal any follow-up/acknowledge items into summary-fix bundle), then liaison runs gh pr ready 450.

Self-improvement: nothing this time.
