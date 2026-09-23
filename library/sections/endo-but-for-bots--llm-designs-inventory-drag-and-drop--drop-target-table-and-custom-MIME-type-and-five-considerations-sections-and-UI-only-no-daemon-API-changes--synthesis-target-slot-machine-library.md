---
title: §Synthesis target — slot machine library
source-slug: endo-but-for-bots--llm-designs-inventory-drag-and-drop
source-url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/inventory-drag-and-drop.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/inventory-drag-and-drop.md
total-lines: 99
ingest-cycle: 248
ingest-date: 2026-06-08
lane: designs
parent: endo-but-for-bots--llm-designs-inventory-drag-and-drop--drop-target-table-and-custom-MIME-type-and-five-considerations-sections-and-UI-only-no-daemon-API-changes
---

For a slot machine library:

- §UI-only-no-game-engine-changes — when a UI feature could be implemented in the game engine or in the UI, prefer the UI when the engine already supports the operation.
- §Action-target-table mapping UI gestures to existing game-engine API calls.
- §Custom-MIME-type for §game-token-MIME-type as discriminator on drag-and-drop transfers between games.
- §Five-Considerations-sections for §game-feature-spec-shape.
- §Empty-considerations-section-acknowledged-explicitly for §game-feature-completeness-signal.
- §Default-non-destructive-action-modifier-key-for-destructive for §game-action-safety-default.
- §Acknowledged-non-atomic-action with named matching-existing-behavior for §game-action-inherits-known-non-atomic-substrate-behavior.
- §Confirmation-dialog for §irreversible-game-action-defense-against-misclick.
- §Three-named-visual-affordances for §game-action-source-target-validity-states.
- §Stretch-goal as named scope deferral for §game-feature-considered-and-deferred.
