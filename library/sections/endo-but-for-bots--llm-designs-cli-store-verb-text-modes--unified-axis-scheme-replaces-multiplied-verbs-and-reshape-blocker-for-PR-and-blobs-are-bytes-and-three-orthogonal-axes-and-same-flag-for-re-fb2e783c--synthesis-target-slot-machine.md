---
title: §Synthesis target — slot machine library
source-slug: endo-but-for-bots--llm-designs-cli-store-verb-text-modes
source-url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/cli-store-verb-text-modes.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/cli-store-verb-text-modes.md
total-lines: 446
ingest-cycle: 240
ingest-date: 2026-06-08
lane: designs
parent: endo-but-for-bots--llm-designs-cli-store-verb-text-modes--unified-axis-scheme-replaces-multiplied-verbs-and-reshape-blocker-for-PR-and-blobs-are-bytes-and-three-orthogonal-axes-and-same-flag-for-read-and-write
---

For a slot machine library:

- §game-verb-axis-table for §game-mode-presentation discipline.
- §unified-axis-scheme-replaces-multiplied-verbs for §game-action-presentation: §`spin --classic --coin <n>` rather than `spin-classic` and `spin-classic-bonus` as separate verbs.
- §three-orthogonal-axes for §game-action-design: §game-mode + §payout-shape + §where-it-lives-in-the-rule-graph.
- §same-flag-for-input-and-output for §symmetric-game-action-verbs.
- §no-encoding-flag — §game-engine-doesn't-negotiate-currency-codes; pick one and reject everything else at the boundary.
- §blobs-are-bytes for §game-payout-tokens-are-opaque (no embedded metadata).
- §no-content-type for §game-tokens-don't-carry-currency-type; out-of-band via §game-pet-name or §sibling-formula.
- §two-different-API-shapes-for-two-different-substrates for §game-state-creation-vs-game-state-mutation.
- §state-dependent-dispatch-anti-pattern — §game-rules-whose-effect-depends-on-implicit-game-state-cannot-be-scripted-defensively.
- §reshape-blocker-for-PR for §game-rule-revision-blocks-feature-PR-until-rule-shape-is-revised.
- §verb-count-as-named-cost for §game-rule-count-as-named-cost; each new game rule multiplies the rule surface area.
- §reserved-future-siblings for §game-action-near-neighbors.
- §PR-stacking-discipline for §game-feature-PR-stacking-order.
- §three-named-things-per-deferral for §game-feature-deferred-with-trigger-and-cost.
