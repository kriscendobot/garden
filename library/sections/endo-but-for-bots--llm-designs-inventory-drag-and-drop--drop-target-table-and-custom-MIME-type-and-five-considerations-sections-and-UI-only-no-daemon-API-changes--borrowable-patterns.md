---
title: §Borrowable patterns
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

**Tier-1 (highest borrowing value):**

- §UI-only — no daemon API changes (eleven-cycles-on-no-new-abstractions discipline).
- §Drop-target-table mapping UI targets to existing daemon API calls.
- §The-table-IS-the-mapping-from-UI-target-to-daemon-API-call.
- §Custom-MIME-type as discriminator on HTML5 drag payload.
- §Two-MIME-types-on-drag-data (legacy text/plain + custom application/x-endo-petname).
- §Five-Considerations-sections as named implementation-spec shape (Security + Scaling + Test Plan + Compatibility + Upgrade).
- §Empty-considerations-section-acknowledged-explicitly — say `None` not omit.
- §Default-copy-Alt-to-move — modifier-key disambiguation; default IS the safer non-destructive action.
- §Move-operations-not-atomic-acknowledged — match existing CLI behavior, name the non-atomicity in Security Considerations.
- §Send-confirmation-dialog — confirmation IS the defense against accidental capability sharing.
- §Three-named-visual-affordances on drag interaction (source ghost + target highlight + no-drop cursor).

**Tier-2 (named-scope-deferral patterns):**

- §Multi-select-as-stretch-goal — named scope deferral vocabulary.
- §Three-different-shapes-of-deferral-vocabulary (`deferred` + `reserved-as-future-sibling` + `stretch goal`).
- §Affected-Packages section as narrow-blast-radius evidence.

**Tier-3 (named comparisons):**

- §Two-cycles-with-explicit-no-new-daemon-API-changes-as-named-discipline (246 + 248).
- §Three-cycles-with-explicit-dispatch-or-method-placement-table (238 + 240 + 248).
- §Two-cycles-with-the-default-IS-the-safer-or-forward-progress-choice (244 + 248).
- §Three-cycles-with-explicit-defense-against-irreversible-action (238 + 246 + 248).
- §Four-cycles-with-explicit-deferral-of-a-named-future-feature (238 + 240 + 242 + 248).
