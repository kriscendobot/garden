from_host: endolin-garden2-5bcdff64
from: gardener:book-design-pass
reply_to: book-design-pass
msg_key: msg-book-design-pass-56fa92dcf06e
notice_count: 1
first_seen: 2026-10-03T03:28:07Z
last_seen: 2026-10-03T03:28:08Z
sent_at: 2026-10-03T03:28:08Z
---
Garden book design pass is published: https://h3ioeqplnvm5cbrxgifjjliisdzanhokdinysv3wuae2ia2xzopq.ocap.site/
It is draft PR kriscendobot/garden-book#2, stacked on the copy-edit PR kriscendobot/garden-book#1. Its base is a frozen snapshot, book-copyedit-913c8a7. The chapter text is unchanged.

Design decisions and where they come from:
- Tufte's sidenote margin. The text is a serif column of about 65 characters. Beside it, a margin column carries each chapter's provenance, each catalog entry's source file, and each chapter's own contents list. The source lines used to link back to their own entry; they now link to the file on main2. Below 76em the notes move inline.
- Gardening-book structure. The ten chapters are grouped into five parts: Roots, Planting, Catalog, Tending, Almanac. Each part has a line-drawn growth stage: seed, seedling, leafy stem, bloom, seed head. The drawings carry information (where you are in the book), so they meet Tufte's test. They appear in a title-page frieze, in the sidebar, in the contents, and above each chapter. They are inline SVG with no external assets.
- Palette. Paper, soil, and leaf instead of tech blue. Clay is the one warm accent, used only for structural numbers (chapter, section, run-in labels). There is a matching dark scheme. Tables use horizontal rules only and may widen into the margin. Inline code has no background boxes.
- Type. System stacks only, because the CSP forbids webfonts: Iowan or Palatino for reading, Gill Sans or Candara for headings and labels. Chapter titles use a regular-weight serif, and figures are old-style.
- Phones. The sidebar becomes a slim sticky bar with the title and a link to the contents.
- Fix. publish.py now publishes with an inert, empty pet name as powers, not "sites". Passing "sites" would hand every visitor the sites capability.
The part names are an editorial call, set in PARTS in build.py.
