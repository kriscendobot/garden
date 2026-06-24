---
title: §Synthesis target — slot machine library
source-slug: endo-but-for-bots--llm-designs-endor-bus-tui
section-slug: worker-facing-complement-to-endor-tui-and-three-layer-architecture-bus-verbs-plus-XS-handles-plus-Exo-wrapper-and-capability-mediated-TUI-and-state-at-daemon-verbs-at-worker
source-url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/endor-bus-tui.md
source-repo: endojs/endo-but-for-bots
source-path: designs/endor-bus-tui.md
source-author: Kris Kowal (prompted)
total-lines: 1148
ingest-cycle: 271
ingest-date: 2026-06-10
lane: designs
scope: structural-pattern-observations
parent: endo-but-for-bots--llm-designs-endor-bus-tui--worker-facing-complement-to-endor-tui-and-three-layer-architecture-bus-verbs-plus-XS-handles-plus-Exo-wrapper-and-capability-mediated-TUI-and-state-at-daemon-verbs-at-worker
---

§The-host-side-and-the-worker-side-of-the-same-subsystem applies to the §game-engine-cluster:

- §**game-engine-display** (host side) — owns the game screen; renders game state to the user; receives input events.
- §**game-engine-bus-display** (worker side) — game-rule workers declare what they want to render; events flow the other direction.
- §**§capability-mediated-game-display** — game-rule-workers don't touch the display directly; daemon mediates both rendering and events.
- §**§three-layers** — bus verbs (wire) + JS handle API (local) + Exo CapTP wrapper (capability model).
- §**§named non-exposures** — game-rule-workers can't access game-state-directly + can't write to game-state-storage + can't observe other-player-actions.
- §**§deterministic-ID-discipline** for game-events that may scroll out of view.
- §**§abstraction-over-renderer** — game-engine-display doesn't expose raw rendering bytes.
- §**§canvas-regions-as-escape-hatch** for cell-level game-rule rendering.
- §**§no-fighting-for-foreground** — game-rule-workers accept whatever stacking the daemon assigns.
