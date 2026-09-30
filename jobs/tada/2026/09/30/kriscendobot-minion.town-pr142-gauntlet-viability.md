Deciding question: Is PR #142 still the only design for turning the full clip lifecycle (publish, upgrade, unpublish, transfer, list) into capabilities, and is the maintainer's objection to owner-gated authority still unaddressed on `main`?

Answer: yes to both. The PR has not been superseded, and the problem it answers is still live.

Evidence:
- **PR state:** kriscendobot/minion.town#142 is OPEN, draft and unmerged. It was created 2026-09-30T04:15Z, based on the frozen `main-33aac61`, and adds one file, `designs/clip-lifecycle-capabilities.md`. It has no reviews or comments yet.
- **Motivation still holds:** The PR answers kriskowal's CHANGES_REQUESTED review on #85 (2026-09-30T02:41Z): "If you have to ask who is acting, you have failed … the right to publish or upgrade should be modeled as a transferable or attenuatable capability." #85 is still OPEN and draft, and that review is its most recent one.
- **Still owner-gated on `main`:** `designs/clip-ocap-synthesis.md` on `main` still describes `upgrade`, `listSites` and `unpublish` as owner-gated or owner-scoped, with a `hash → { directoryId, owner }` registry. That file was last changed 2026-09-12, before the review.
- **No newer displacing work:** Commits on `main` since 2026-09-29 are npm-registry deploy work, @claude-agents delegation, and pin bumps. None of them touch clip lifecycle authority. No design file on `main` covers a clip controller, unpublish as a right, or owner → account.
- **No competing PR:** The only clip PR opened after #142 is #143 (the clip gutter as the signed-in landing page). It is a UI change and does not overlap.
- **Complements #85:** #85 moves only `upgrade` onto a swiss-number capability. #142 covers the rest of the lifecycle and lists seven open questions for the maintainer.

This check spent none of the clean, panel, fix or CI budget, so the gauntlet can go ahead.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr142-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (170309 cached reads)
- Output: 1666 tokens
- Cost: $0.4294938
- Wall-clock: 25s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
