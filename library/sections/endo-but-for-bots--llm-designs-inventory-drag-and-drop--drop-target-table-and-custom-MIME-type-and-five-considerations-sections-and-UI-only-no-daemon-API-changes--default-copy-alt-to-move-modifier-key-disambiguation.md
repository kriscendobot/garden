---
title: §Default copy + Alt-to-move (modifier-key disambiguation)
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

§The-Interaction-Details-section names §two-default-modifier-key-behaviors:

- **Default**: drop = copy.
- **Alt/Option held during drop**: drop = move (copies then removes the source name).

§Two-default-modifier-behaviors-with-named-default-and-named-override. §The-default-IS-the-safer-non-destructive-action + §the-modifier-IS-the-destructive-explicit-action. §When-a-UI-action-could-be-destructive-or-non-destructive, §default-to-non-destructive + §require-a-modifier-for-the-destructive-form.

§Sibling-pattern-to-cycle-244's-default-resolve-on-timeout-not-default-reschedule — §two-cycles-with-the-default-IS-the-safer-or-forward-progress-choice. §Cycle-244's-default-is-forward-progress; §cycle-248's-default-is-non-destructive-copy.

§First-explicit-observation in library of §modifier-key-disambiguation-on-drop-action as named UI pattern.
