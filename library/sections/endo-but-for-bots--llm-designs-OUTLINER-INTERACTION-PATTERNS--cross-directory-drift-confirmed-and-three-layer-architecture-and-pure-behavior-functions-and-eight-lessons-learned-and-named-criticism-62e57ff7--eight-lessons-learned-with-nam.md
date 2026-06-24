---
title: §Eight Lessons Learned with named bug-and-fix pairs
source-slug: endo-but-for-bots--llm-designs-OUTLINER-INTERACTION-PATTERNS
section-slug: cross-directory-drift-confirmed-and-three-layer-architecture-and-pure-behavior-functions-and-eight-lessons-learned-and-named-criticism-of-contentEditable
source-url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/OUTLINER_INTERACTION_PATTERNS.md
source-repo: endojs/endo-but-for-bots
source-path: designs/OUTLINER_INTERACTION_PATTERNS.md
source-author: Endo project (with attribution to Muddle project)
total-lines: 997
ingest-cycle: 273
ingest-date: 2026-06-10
lane: designs
scope: structural-pattern-observations
parent: endo-but-for-bots--llm-designs-OUTLINER-INTERACTION-PATTERNS--cross-directory-drift-confirmed-and-three-layer-architecture-and-pure-behavior-functions-and-eight-lessons-learned-and-named-criticism-of-contentEditable
---

Lines 981-997 carry **eight numbered Lessons Learned**:

1. **Measure `.block-row`, not `.block`** — *"Our most persistent drag-select bug was parent blocks being selected when only children were in the selection box. The fix: measure the row element (bullet + content) not the outer block container (which includes children)."*
2. **Textareas over contentEditable** — *"ContentEditable is seductive but treacherous. Cursor position tracking, paste handling, and cross-browser consistency are all dramatically simpler with textareas. The tradeoff (no inline rich text editing) is worth it for an outliner where structure matters more than formatting."*
3. **Pure behavior functions are the best testing investment**.
4. **Focus management is a state machine** — *"The pattern of 'queue focus for a block that doesn't exist yet' is essential. Any operation that changes tree structure (Enter, Backspace merge, indent, unindent) will destroy and recreate DOM nodes."*
5. **Global mouse listeners for drag operations** — *"Always attach mousemove and mouseup to `window` during drag."*
6. **Contiguous-only selection simplifies everything**.
7. **`requestAnimationFrame` nesting for mobile** — *"A single rAF is not enough on mobile browsers. Two nested rAF calls ensure the DOM has fully settled before applying focus."*
8. **The `{ type: 'default' }` action is load-bearing** — *"Most keystrokes should fall through to browser defaults. The behavior layer must explicitly opt-in to intercepting a key, never opt-out. Get this wrong and you break basic typing."*

§First-explicit-observation in library: **§eight-numbered-Lessons-Learned-with-named-bug-and-fix-pairs — §the-richest-Lessons-Learned-section-cycle-ingested + §each-lesson-IS-a-named-named-bug-fix-or-discipline + §the-section-IS-the-cumulative-experience-record-of-the-design**.

§Sibling-pattern to cycle 269's eleven-numbered-Design-Decisions; §the-Lessons-Learned-section-IS-the-retrospective-companion-to-the-Design-Decisions-section; §two-named-rationale-sections in design-documents: §Design-Decisions (prospective rationale) + §Lessons-Learned (retrospective discoveries).

§First-explicit-observation in library: **§two-named-rationale-sections-in-design-documents (Design-Decisions for prospective + Lessons-Learned for retrospective)**.
