---
ts: 2026-05-15T01:20:44Z
kind: result
role: liaison
project: garden-library
---

# Liaison: new concept page `token-chip` (maintainer request)

## Maintainer ask

After cycle 55 noted that the token-chip abstraction had appeared in
two chat sources and a concept page was warranted "after one more
chat source uses it", the maintainer responded: *"A concept page for
token chip would be good."*

Threshold overridden in favor of writing now.

## Landed

- **`journal/library/concepts/token-chip.md`** — new concept page.
  Covers: what a chip *is* (visual + identity + clickable + removable
  + autocompleted); explicit *not-a-string* clarification (textual
  `@name` is input grammar; chip travels by formula identifier);
  four design properties (confinement-by-structure, identity-vs-name
  separation, removable-without-ambient-effect, multi-chip
  composition); table of sections that touch the concept (4 chat
  sections); see-also block linking to producer-typed-shape-consumer-rendering, dehydrate-hydrate, and pass-invariant-handle-equality.

- **`journal/library/concepts/README.md`** — inventory updated with the new concept row.

- **`journal/library/keywords.md`** — 8 keyword entries pointing at `token-chip` (replacing the previous single-entry redirect to the chat-invariants section): `token chip`, `token chips`, `` `@`-prefix chip ``, `pet-name chip`, `named-value chip`, `path chip`, `removable chip`, `token autocomplete`.

- **`chat-components/inventory-and-messages`** — added a `## See also` block linking back to the new concept page.

## Library state

- Sources: 103 (unchanged).
- Sections: 461 (unchanged).
- Topics: 26 (unchanged).
- **Concepts: 19 → 20** (new: `token-chip`).
- Keywords: ~179 → ~186 (7 net new, replacing one previous entry).
- Roles: 3 (unchanged).

## Notes

- The concept page links to *three* existing concept pages (producer-typed-shape-consumer-rendering, dehydrate-hydrate, pass-invariant-handle-equality), all from the daemon cluster. This is the cleanest cross-cluster link of any chat-related material so far — token-chip surfaces a daemon-level abstraction at the UI layer.
- The 4-property design table (confinement by structure / identity-vs-name / removable-without-ambient-effect / multi-chip composition) is new material — these properties were *implicit* in the chat sources but not enumerated. Writing the concept page surfaced them.
- Future chat ingests (chat-edit-message-ui, chat-spaces-gutter, chat-command-bar) will likely extend the section table for this concept.
