---
title: See also
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

- [[chat-ui]] (topic) — chat-interface design surface.
- [[ui-design]] (topic) — UI patterns; the implemented-then-superseded lifecycle pattern.
- [[css]] (topic) — CSS implementation; pseudo-element gutter-line drawing.
- `endo-but-for-bots--llm-designs-chat-reply-chain-visualization--message-of-interest-spotlight-algorithm-and-layout-computation` — the previous section: the MOI spotlight algorithm + layout computation.
- `endo-but-for-bots--llm-designs-chat-focus-message--*` (cycles ingesting the *superseding* design): five sections covering motivation/entry-exit, visual-design-and-data-model, indentation-algorithm-and-chain-lines, prefill-mechanism-and-key-files, navigation-and-shortcut-keys. Reading those alongside this section reveals what the successor kept (focus-is-layout) vs changed (keyboard-navigation; explicit-mode-entry; no scroll-pinned auto-promote).
- `endo-but-for-bots--llm-designs-chat-rename-dismiss-to-clear--rename-decision-record` (cycle 95) — sibling single-section design doc; the *dismiss-→-clear rename* decision was captured with similar §Decisions Made table discipline.
