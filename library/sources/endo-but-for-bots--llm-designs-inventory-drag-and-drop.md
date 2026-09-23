---
title: "inventory-drag-and-drop — HTML5 drag-and-drop on inventory items dispatching to existing daemon APIs"
source-slug: endo-but-for-bots--llm-designs-inventory-drag-and-drop
url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/inventory-drag-and-drop.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/inventory-drag-and-drop.md
total-lines: 99
status: Not Started (2026-02-14 → 2026-02-24)
ingest-cycle: 248
ingest-date: 2026-06-08
lane: designs
---

# inventory-drag-and-drop.md

A 99-line **Not Started** design that adds HTML5 drag-and-drop to the chat UI's inventory, dispatching drops to existing daemon API methods (no daemon API changes needed).

## Key design moves

- **§UI-only — no daemon API changes** (eleven-cycles-on-no-new-abstractions discipline).
- **§Drop-target table** mapping UI targets to existing daemon API calls.
- **§Custom MIME type** (`application/x-endo-petname`) as discriminator on HTML5 drag payload.
- **§Two MIME types on drag data** (legacy `text/plain` + custom `application/x-endo-petname`).
- **§Five Considerations sections** as named implementation-spec shape (Security + Scaling + Test Plan + Compatibility + Upgrade).
- **§Empty considerations section acknowledged explicitly** — say `None` not omit.
- **§Default copy + Alt-to-move** — modifier-key disambiguation; default IS the safer non-destructive action.
- **§Move operations not atomic — acknowledged** — match existing CLI behavior.
- **§Send-confirmation dialog** — defense against accidental capability sharing.
- **§Three named visual affordances** on drag interaction (source ghost + target highlight + no-drop cursor).
- **§Multi-select as stretch goal** — named scope deferral.
- **§Affected Packages section** — narrow blast radius as evidence of decoupling.

## Section files

- [§drop-target-table + §custom-MIME-type + §five-Considerations-sections + §UI-only-no-daemon-API-changes](../sections/endo-but-for-bots--llm-designs-inventory-drag-and-drop--drop-target-table-and-custom-MIME-type-and-five-considerations-sections-and-UI-only-no-daemon-API-changes.md) — full 99-line design ingest.

## Ingest scope

Cycle 248 (designs-lane): full 99-line ingest. §First-explicit-observation of five patterns: §custom-MIME-type-as-discriminator-on-HTML5-drag-payload + §five-named-Considerations-sections-as-implementation-spec-shape + §empty-considerations-section-acknowledged-explicitly + §modifier-key-disambiguation-on-drop-action + §three-named-visual-affordances-on-drag-interaction.
