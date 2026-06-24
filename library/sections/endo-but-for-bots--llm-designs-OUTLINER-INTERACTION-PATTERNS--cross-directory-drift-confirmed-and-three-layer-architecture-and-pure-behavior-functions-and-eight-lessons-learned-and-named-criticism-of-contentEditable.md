---
title: "OUTLINER_INTERACTION_PATTERNS.md — cross-directory drift from cycle 263 confirmed + three-layer architecture (Behavior + Component + Data) + pure-functions-over-DOM-events + eight Lessons Learned + named criticism of contentEditable"
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
kind: index
section_count: 21
---

Sections:

- [`OUTLINER_INTERACTION_PATTERNS.md` — the guide that closes cycle 263's cross-directory-drift loop](endo-but-for-bots--llm-designs-OUTLINER-INTERACTION-PATTERNS--cross-directory-drift-confirmed-and-three-layer-architecture-and-pure-behavior-functions-and-eight-lessons-learned-and-named-criticism-62e57ff7--outliner-interaction-patterns.md)
- [§The ALL-CAPS-FILENAME distinguishes this from sibling design docs](endo-but-for-bots--llm-designs-OUTLINER-INTERACTION-PATTERNS--cross-directory-drift-confirmed-and-three-layer-architecture-and-pure-behavior-functions-and-eight-lessons-learned-and-named-criticism-62e57ff7--the-all-caps-filename-distingu.md)
- [§No metadata table — the file is a guide, not a design](endo-but-for-bots--llm-designs-OUTLINER-INTERACTION-PATTERNS--cross-directory-drift-confirmed-and-three-layer-architecture-and-pure-behavior-functions-and-eight-lessons-learned-and-named-criticism-62e57ff7--no-metadata-table-the-file-is.md)
- [§Named prior-art attribution — the Muddle project](endo-but-for-bots--llm-designs-OUTLINER-INTERACTION-PATTERNS--cross-directory-drift-confirmed-and-three-layer-architecture-and-pure-behavior-functions-and-eight-lessons-learned-and-named-criticism-62e57ff7--named-prior-art-attribution-th.md)
- [§Three-layer architecture — sibling to cycle 271's three-layers-not-one](endo-but-for-bots--llm-designs-OUTLINER-INTERACTION-PATTERNS--cross-directory-drift-confirmed-and-three-layer-architecture-and-pure-behavior-functions-and-eight-lessons-learned-and-named-criticism-62e57ff7--three-layer-architecture-sibli.md)
- [§"The single most important architectural decision"](endo-but-for-bots--llm-designs-OUTLINER-INTERACTION-PATTERNS--cross-directory-drift-confirmed-and-three-layer-architecture-and-pure-behavior-functions-and-eight-lessons-learned-and-named-criticism-62e57ff7--the-single-most-important-arch.md)
- [§The pure-functions-test-without-browser discipline](endo-but-for-bots--llm-designs-OUTLINER-INTERACTION-PATTERNS--cross-directory-drift-confirmed-and-three-layer-architecture-and-pure-behavior-functions-and-eight-lessons-learned-and-named-criticism-62e57ff7--the-pure-functions-test-withou.md)
- [§Eight Lessons Learned with named bug-and-fix pairs](endo-but-for-bots--llm-designs-OUTLINER-INTERACTION-PATTERNS--cross-directory-drift-confirmed-and-three-layer-architecture-and-pure-behavior-functions-and-eight-lessons-learned-and-named-criticism-62e57ff7--eight-lessons-learned-with-nam.md)
- [§"ContentEditable is seductive but treacherous" — named criticism of an existing browser API](endo-but-for-bots--llm-designs-OUTLINER-INTERACTION-PATTERNS--cross-directory-drift-confirmed-and-three-layer-architecture-and-pure-behavior-functions-and-eight-lessons-learned-and-named-criticism-62e57ff7--contenteditable-is-seductive-b.md)
- [§"The fix: ..." pattern — named bug-and-remedy as testimony](endo-but-for-bots--llm-designs-OUTLINER-INTERACTION-PATTERNS--cross-directory-drift-confirmed-and-three-layer-architecture-and-pure-behavior-functions-and-eight-lessons-learned-and-named-criticism-62e57ff7--the-fix-pattern-named-bug-and.md)
- [§"opt-in to intercepting a key, never opt-out" — the load-bearing discipline](endo-but-for-bots--llm-designs-OUTLINER-INTERACTION-PATTERNS--cross-directory-drift-confirmed-and-three-layer-architecture-and-pure-behavior-functions-and-eight-lessons-learned-and-named-criticism-62e57ff7--opt-in-to-intercepting-a-key-n.md)
- [§"requestAnimationFrame nesting for mobile" — named-platform-specific-workaround](endo-but-for-bots--llm-designs-OUTLINER-INTERACTION-PATTERNS--cross-directory-drift-confirmed-and-three-layer-architecture-and-pure-behavior-functions-and-eight-lessons-learned-and-named-criticism-62e57ff7--requestanimationframe-nesting.md)
- [§"Focus management is a state machine" — named architectural style](endo-but-for-bots--llm-designs-OUTLINER-INTERACTION-PATTERNS--cross-directory-drift-confirmed-and-three-layer-architecture-and-pure-behavior-functions-and-eight-lessons-learned-and-named-criticism-62e57ff7--focus-management-is-a-state-ma.md)
- [§Cycle 273 first-explicit-observations roundup (twelve)](endo-but-for-bots--llm-designs-OUTLINER-INTERACTION-PATTERNS--cross-directory-drift-confirmed-and-three-layer-architecture-and-pure-behavior-functions-and-eight-lessons-learned-and-named-criticism-62e57ff7--cycle-273-first-explicit-obser.md)
- [§Recurring meta-pattern counters bumped at cycle 273](endo-but-for-bots--llm-designs-OUTLINER-INTERACTION-PATTERNS--cross-directory-drift-confirmed-and-three-layer-architecture-and-pure-behavior-functions-and-eight-lessons-learned-and-named-criticism-62e57ff7--recurring-meta-pattern-counter.md)
- [§Closing the cycle 263 loop](endo-but-for-bots--llm-designs-OUTLINER-INTERACTION-PATTERNS--cross-directory-drift-confirmed-and-three-layer-architecture-and-pure-behavior-functions-and-eight-lessons-learned-and-named-criticism-of-62e57ff7--closing-the-cycle-263-loop.md)
- [§Synthesis target — slot machine library](endo-but-for-bots--llm-designs-OUTLINER-INTERACTION-PATTERNS--cross-directory-drift-confirmed-and-three-layer-architecture-and-pure-behavior-functions-and-eight-lessons-learned-and-named-criticism-62e57ff7--synthesis-target-slot-machine.md)
- [§Tier-1 borrowing](endo-but-for-bots--llm-designs-OUTLINER-INTERACTION-PATTERNS--cross-directory-drift-confirmed-and-three-layer-architecture-and-pure-behavior-functions-and-eight-lessons-learned-and-named-criticism-of-contentEditable--tier-1-borrowing.md)
- [§Tier-2 borrowing](endo-but-for-bots--llm-designs-OUTLINER-INTERACTION-PATTERNS--cross-directory-drift-confirmed-and-three-layer-architecture-and-pure-behavior-functions-and-eight-lessons-learned-and-named-criticism-of-contentEditable--tier-2-borrowing.md)
- [§Tier-3 borrowing](endo-but-for-bots--llm-designs-OUTLINER-INTERACTION-PATTERNS--cross-directory-drift-confirmed-and-three-layer-architecture-and-pure-behavior-functions-and-eight-lessons-learned-and-named-criticism-of-contentEditable--tier-3-borrowing.md)
- [Pattern summary (tag-prefixed)](endo-but-for-bots--llm-designs-OUTLINER-INTERACTION-PATTERNS--cross-directory-drift-confirmed-and-three-layer-architecture-and-pure-behavior-functions-and-eight-lessons-learned-and-named-criticism-o-62e57ff7--pattern-summary-tag-prefixed.md)
