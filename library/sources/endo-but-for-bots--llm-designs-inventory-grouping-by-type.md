---
title: "inventory-grouping-by-type — Group inventory items into collapsible sections by formula type"
source-slug: endo-but-for-bots--llm-designs-inventory-grouping-by-type
url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/inventory-grouping-by-type.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/inventory-grouping-by-type.md
total-lines: 125
status: Not Started (2026-02-14 → 2026-02-24)
ingest-cycle: 250
ingest-date: 2026-06-08
lane: designs
---

# inventory-grouping-by-type.md

A 125-line **Not Started** design that groups inventory items in the chat UI by formula type into four collapsible sections (Handles + Hubs + Workers + Everything Else). Sibling design to cycle-248's inventory-drag-and-drop (same author + same week + same chat-UI-inventory cluster).

## Key design moves

- **§Group table** — four-column dispatch table (Group × Formula Types × Icon × Description).
- **§Catch-all bucket explicitly named** — "Everything Else" with icon and description.
- **§Options-Considered-with-preferred** — distinct from Alternatives-Considered (both options viable, one preferred).
- **§Additive API change via destructure-immune consumers** as named compatibility discipline.
- **§Substrate count named as evidence of categorization scope** (26 types in substrate, 4 explicit groups).
- **§The design IS the exposure not the computation** — when substrate already has the information.
- **§Exposing X doesn't grant new capabilities** as named security argument shape.
- **§Restrict interface metadata to host-level authority** — stretch-goal security thinking not deferred.
- **§No migration needed** — when API extension exposes existing substrate field.
- **§Five-Considerations-sections** recurring template (sibling to cycle 248).
- **§Affected Packages section** as blast-radius evidence (3 rows vs cycle 248's 1 row).
- **§`stretch goal` vocabulary** as named author's recurring deferral vocabulary.
- **§Preserve existing toggle as named non-change** — system @-prefixed names retain existing show/hide toggle.

## Section files

- [§Group-table + §Options-Considered-with-preferred + §additive-API-change + §five-Considerations-sections](../sections/endo-but-for-bots--llm-designs-inventory-grouping-by-type--Group-table-and-Options-Considered-with-preferred-and-additive-API-change-and-five-Considerations-sections.md) — full 125-line design ingest.

## Ingest scope

Cycle 250 (designs-lane): full 125-line ingest. §**Cycle-250-milestone-cycle** — the 250th librarian cycle in this session. §First-explicit-observation of seven patterns: §Options-Considered-with-preferred-as-distinct-from-Alternatives-Considered + §four-column-Group-table-with-Icon-and-Description + §additive-API-change-via-destructure-immune-consumers + §substrate-count-named-as-evidence-of-categorization-scope + §exposing-X-doesn't-grant-new-capabilities as named security argument + §design-doc-template-recurs-across-related-designs as named author-discipline + §preserve-existing-toggle-as-named-non-change.
