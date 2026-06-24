---
title: Connection to the wider library
source: designs/chat-reply-chain-visualization.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: HEAD (origin/llm, fetched 2026-06-01)
source_date: 2026-02-28
source_authors: [Kris Kowal (prompted)]
source_lines: "202-502 (Line Drawing + Vertical Alignment + Interactive Selection + Performance + Accessibility + Visual Design + Implementation Phases + Alternatives Considered + Files + Decisions Made + Out of Scope)"
topics: [chat-ui]
status: deprecated
notes: |
  The rendering + lifecycle surface of the deprecated chat-reply-
  chain-visualization design. Four threads: (1) the §CSS-over-SVG
  choice with explicit rationale (*segments are simple verticals
  and horizontals in a fixed gutter column*); the SVG fallback is
  noted only for animation/gradient/virtualization cases that this
  design doesn't need; (2) the §line-segment role table (`│`
  continue, `├──○` branch, `└` terminus) plus the gutter-layout
  ASCII spec with 2ex width and 2px stroke and `#9ca3af`/`#6b7280`
  muted grey (Tailwind gray-400/500); (3) the §Decisions Made
  table — 13 granular choices (indent unit / line thickness /
  color / nodule styling / off-screen rendering / animation /
  CSS over SVG) captured as a permanent decision record; (4) the
  §explicit deprecation pointer to chat-focus-message — Phase 1-5
  ✅, Phase 6 (polish + a11y + keyboard) unfinished — captures
  the *implemented-then-superseded* lifecycle. Together this is
  the canonical *deprecated-but-preserved* design doc pattern.
parent: endo-but-for-bots--llm-designs-chat-reply-chain-visualization--css-gutter-rendering-and-deprecation-rationale
---

This section is the **canonical *deprecated-but-preserved* design-doc worked example**. Four threads:

1. **The CSS-over-SVG implementation choice with explicit rejected-alternative table** is reusable for any *static-line-graphic-in-fixed-column* layout decision. CSS pseudo-elements win when lines are *gutter-local*; SVG wins when lines need animation, gradients, or cross-virtualization continuity.

2. **The §Decisions Made table** is the canonical *knob-by-knob rationale record* shape. Each row is one decision; the table is the permanent answer to *what choices were made at each granular point*.

3. **The §Implementation Phases ✅ / unfinished structure** is the canonical *design-doc-as-implementation-tracker* discipline. The doc is the source of truth for what was built; ✅ phases are immutable history; unfinished phases are the open work surface.

4. **The §Deprecated status with successor pointer** is the canonical *implemented-then-superseded* lifecycle. The deprecated design is preserved (not deleted) so the successor's choices have context. The deprecated doc names its own Out-of-Scope items, which often turn out to be what the successor addresses.
