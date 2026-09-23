---
title: §Synthesis target — slot machine library
source-slug: endo-but-for-bots--llm-designs-outliner-design-doc-2
section-slug: design-fragment-breaks-template-and-postpone-broadcast-until-cursor-leaves-and-sidecar-table-for-visible-order-and-moveNodeToAfter-capability-based-mutation
source-url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/outliner-design-doc-2.md
source-repo: endojs/endo-but-for-bots
source-path: designs/outliner-design-doc-2.md
source-author: Endo project (unattributed; design fragment style)
total-lines: 10
ingest-cycle: 263
ingest-date: 2026-06-10
lane: designs
parent: endo-but-for-bots--llm-designs-outliner-design-doc-2--design-fragment-breaks-template-and-postpone-broadcast-until-cursor-leaves-and-sidecar-table-for-visible-order-and-moveNodeToAfter-capability-based-mutation
---

§The-design-fragment-form-applies-to-game-engine-in-flight-thinking:

- §**game-design-fragment** without metadata table — for tentative architectural recommendations not yet ready for the design-doc-template.
- §**three-named-comparison-points** for §game-UX-positioning (e.g., Las-Vegas-physical-slot + classic-arcade-pinball + modern-mobile-slot-app).
- §**postpone-bet-broadcast-until-correction-window-closes** — §when-a-player-presses-bet-then-immediately-presses-cancel, §the-protocol-should-not-have-broadcast-the-bet-yet; §use-cursor-(focus)-position-OR-debounced-timer-as-the-window-boundary.
- §**decompose-atomic-game-action-into-named-protocol-edits** (e.g., spin-the-reels → set-bet-amount + commit-bet + lock-reels + release-reels-on-stop).
- §**sidecar-table-within-the-game-channel** for §visible-order-of-game-events-distinct-from-chronological-game-event-order.
- §**moveBetToAfter(bet, newPrecursor)** capability-based-mutation — §holding-the-bet-IS-the-authorization-to-reorder-it.
- §**game-design-fragments-with-prose-hedges** ("my current recommendation", "presumably", "or something") to mark in-flight thinking.
