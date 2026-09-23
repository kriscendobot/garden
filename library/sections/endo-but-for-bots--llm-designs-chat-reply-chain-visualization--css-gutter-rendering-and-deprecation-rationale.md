---
title: The CSS-gutter line-drawing implementation that uses `::before`/`::after` pseudo-elements rather than an SVG overlay (rationale: *since segments are simple verticals and horizontals in a fixed gutter column, CSS is simpler and requires no position recalculation*); the line-segment role table (`├`/`│` continue, `├──○` branch fork, `└` terminus); the gutter-layout ASCII spec (~2ex width with the line centered, 2px stroke, muted-grey `#9ca3af` light / `#6b7280` dark sourced from Tailwind gray-400/500); the *off-screen-messages don't break the rendering* invariant; the accessibility surface (visually-hidden *in reply to previous message* links); the performance triad (virtualization + RAF-debounced recalculation + computed-indent caching); the Phase-1-through-5-✅ implementation status; the explicit *Deprecated — see `designs/chat-focus-message.md`* status that captures the design's *implemented-then-superseded* lifecycle; the Decisions Made table that records the granular knob-by-knob choices (indent unit / MOI indication / line thickness / color / nodule styling / off-screen behavior / animation / rendering choice) as a permanent rationale-history artifact
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
kind: index
section_count: 6
---

Sections:

- [Abstract](endo-but-for-bots--llm-designs-chat-reply-chain-visualization--css-gutter-rendering-and-deprecation-rationale--abstract.md)
- [Body](endo-but-for-bots--llm-designs-chat-reply-chain-visualization--css-gutter-rendering-and-deprecation-rationale--body.md)
- [Connection to the wider library](endo-but-for-bots--llm-designs-chat-reply-chain-visualization--css-gutter-rendering-and-deprecation-rationale--connection-to-the-wider-library.md)
- [Translation block (design idiom → contemporary practice)](endo-but-for-bots--llm-designs-chat-reply-chain-visualization--css-gutter-rendering-and-deprecation-rationale--translation-block-design-idiom-contemporary-practice.md)
- [See also](endo-but-for-bots--llm-designs-chat-reply-chain-visualization--css-gutter-rendering-and-deprecation-rationale--see-also.md)
- [Common confusions](endo-but-for-bots--llm-designs-chat-reply-chain-visualization--css-gutter-rendering-and-deprecation-rationale--common-confusions.md)
