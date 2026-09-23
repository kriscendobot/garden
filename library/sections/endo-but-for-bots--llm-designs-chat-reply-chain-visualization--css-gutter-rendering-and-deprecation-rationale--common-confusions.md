---
title: Common confusions
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

- **"The SVG alternative was rejected for being slower."** It was *not*. The rationale is *simplicity-when-complexity-isn't-needed*: SVG would add a separate render-tree and require position recalculation on scroll/resize. The design notes SVG *may be useful if lines need animation, gradients, or cross-virtualization continuity* — none of which this design needs.
- **"`::before` + `::after` per message is too many pseudo-elements."** Each message has *at most two* pseudo-element slots filled (`::before` for the vertical, `::after` for the branch). For non-line messages, both slots are unused (the CSS selector `.message[data-line="..."]` doesn't match anything). The browser optimizes empty pseudo-elements aggressively.
- **"The 2ex gutter is too narrow for thick lines."** 2ex is the *gutter width*; the line is 2px stroke *centered* in the gutter. With a typical 16px font, 2ex ≈ 16px, so the line is at 7-8px from each edge — comfortable.
- **"`#9ca3af` and `#6b7280` are magic numbers."** They are *Tailwind gray-400 and gray-500*. The doc explicitly cites the source (Tailwind palette) so a maintainer using a different color system can substitute equivalents.
- **"The off-screen-rendering invariant means lines extend infinitely."** They extend *to the edge of the rendered message area*. If the parent is off-screen above, the line goes up to the *top of the viewport's rendered messages*. If virtualization is in use, the line ends at the placeholder height — which itself implies *continuity beyond*.
- **"`visually-hidden` is just CSS `display: none`."** It is *not*. `display: none` removes the element from the accessibility tree; the `visually-hidden` class uses `position: absolute; left: -10000px; ...` so screen readers *do* see the content and can navigate to it.
- **"The design was deprecated because the MOI algorithm was wrong."** The algorithm appears to have been *correct* (Phases 1-5 ✅ marked complete). The deprecation is captured in the *Status* header pointing to chat-focus-message. The successor changes *interaction model* (keyboard-driven explicit focus) more than *algorithm*; the *focus-is-layout* insight is preserved.
- **"`Out of Scope: Keyboard navigation` means the design rejects it."** It means the design *deferred* it. The deferred feature became the *motivating feature* of the successor. The §Out-of-Scope section is the *graceful hand-off-to-future-design* discipline.
- **"`Phase 6: Polish` was unfinished — that's a bug."** It is *the design's unfinished work surface*. Phases 1-5 ✅ delivered the core algorithm and rendering; Phase 6 (smooth animations + accessibility + keyboard nav) was never completed because the design was superseded. The unfinished phase is a *truthful record*, not a bug.
- **"The §Decisions Made table is just a summary."** It is *the canonical permanent answer* to *what was decided at each knob*. Future maintainers reading the deprecated doc can grep the table for any specific choice (indent unit, line color, animation behavior) and get the explicit answer without re-reading the prose.
