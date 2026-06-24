---
title: Synthesis target
section-slug: endo-but-for-bots--llm-designs-OUTLINER-INTERACTION-PATTERNS--five-cycles-with-Muddle-attribution-and-the-ALL-CAPS-UNDERSCORES-naming-convention-canonical-example-and-the-default-action-as-pass-through-and-three-vertical-zones-and-double-rAF-for-mobile
source-slug: endo-but-for-bots--llm-designs-OUTLINER-INTERACTION-PATTERNS
url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/OUTLINER_INTERACTION_PATTERNS.md
authors: [Endo project (with attribution to Muddle project)]
status: (no explicit metadata table)
ingest-cycle: 285
ingest-date: 2026-06-10
lane: designs
scope: full
total-lines: 996
parent: endo-but-for-bots--llm-designs-OUTLINER-INTERACTION-PATTERNS--five-cycles-with-Muddle-attribution-and-the-ALL-CAPS-UNDERSCORES-naming-convention-canonical-example-and-the-default-action-as-pass-through-and-three-vertical-zones-and-double-rAF-for-mobile
---

Slot machine library `@game/ui/INTERACTION_PATTERNS.md` (ALL_CAPS_UNDERSCORES naming): three-layer architecture (Behavior + Component + Data) with pure-function behavior layer that returns `GameAction` descriptors including the named `{ type: 'default' }` pass-through; textarea-not-contentEditable for the bet-input field with four named reasons; `data-bet-id` on `.bet-row` not `.bet` for correct rect measurement; padding-left per nesting depth for sub-bets; double-rAF for mobile DOM settling on payout-animation completion; pending-focus queue for the next-spin button; three vertical drop zones for re-ordering bet slips (25%-50%-25% with "into" as easiest target); Alt-drag for copying a bet rather than moving; 500ms hover-to-auto-expand for collapsed parlay groups; same-parent-index-adjustment for re-ordered bets; shift-click on selected bet removes bet AND derived bets; block-position-registry four-named-fields (betId + parentBetId + indexInParent + depth); `canBatchPlace` validation before batch placement; bullet-pattern regex with five named bullet shapes for paste-import of bet histories; `{ shift, cmd, alt }` modifier object with cmd as platform-abstracting name; 7 numbered Lessons Learned with bold-leading-sentence at the end of the document; What-Unit-Tests-Catch-vs-E2E table for game-rule logic vs game-UI effects; global mouse listeners on window for drag-to-reorder-bets; contiguous-only bet selection as named simplification.
