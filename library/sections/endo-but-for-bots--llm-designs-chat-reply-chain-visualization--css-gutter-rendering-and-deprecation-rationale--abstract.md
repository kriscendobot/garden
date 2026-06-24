---
title: Abstract
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

The §Line Drawing section opens with the *gutter-locality* observation: *since lines run strictly along the left gutter, the implementation is straightforward*. The §Gutter Layout (lines 196-219) renders an ASCII column diagram with a 16px gutter beside the message content area; the §vertical line in the gutter *connects the three flush-left messages (Parent, MOI, Last reply) with a single straight stroke*. The §Line Segments table (lines 221-233) maps message-role to ASCII glyph (`├` parent / `├` MOI / `│` intermediate pass-through / `├──○` branch reply / `└` last-reply terminus). The §CSS Implementation (lines 235-285) uses `::before`/`::after` pseudo-elements on `.message[data-line]`-attributed elements: the `continue` value paints a full-height vertical via `::before`; the `end` value paints a top-half-only vertical that *terminates at message center*; the `branch` value adds a horizontal `::after` stub extending right from the spine to the indented reply. The §Alternative: SVG Overlay paragraph (lines 287-296) names SVG's three legitimate use cases (animation, complex styling, cross-virtualization-boundary lines) and explicitly *rejects them for this design* because none apply. The §Line Styling (lines 298-329) specifies 2px thickness, `#9ca3af` light / `#6b7280` dark (Tailwind gray-400/500), simple right-angle nodules with *no circles, squares, or other ornamentation*, and the *off-screen-messages don't break rendering* invariant. The §Interactive Selection section (lines 343-378) names click-to-change-MOI as the only interaction; *no special visual feedback* on the MOI beyond its position. The §Scroll Pinning (lines 363-378) uses the existing chat scroll-pinning logic. The §Performance Considerations (lines 380-405) names virtualization + RAF/debounce + caching. The §Accessibility surface (lines 407-430) provides visually-hidden *in reply to previous message* anchors. The §Implementation Phases section (lines 442-468) marks Phases 1-5 ✅ and Phase 6 (polish + a11y + keyboard nav) unfinished. The §Alternatives Considered (lines 470-487) evaluates four sibling approaches (flat-list-with-chips / separate-thread-view / GitHub-collapsed / Slack-side-panel). The §Files section (lines 489-498) lists the implementation artifacts (`packages/chat/moi-layout.js` + `reply-lines.css` + 13 unit tests; modified `inbox-component.js` + `index.html`). The §Decisions Made table (lines 500-516) captures 13 granular knob-by-knob choices as a permanent record. The §Out of Scope tail notes keyboard navigation as the deferred follow-on, eventually picked up by chat-focus-message.
