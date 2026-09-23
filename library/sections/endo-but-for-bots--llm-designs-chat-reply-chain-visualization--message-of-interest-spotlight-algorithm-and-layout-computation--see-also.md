---
title: See also
source: designs/chat-reply-chain-visualization.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: HEAD (origin/llm, fetched 2026-06-01)
source_date: 2026-02-28
source_authors: [Kris Kowal (prompted)]
source_lines: "1-200 (Motivation + Data Model + Message-of-Interest Algorithm + Indentation)"
topics: [chat-ui]
status: deprecated
notes: |
  The MOI spotlight algorithm of the *deprecated* chat-reply-chain-
  visualization design doc (superseded by chat-focus-message;
  Phases 1-5 marked ✅ — the design was implemented before being
  superseded). Three structural ideas: (1) the *one-MOI-at-a-time*
  invariant collapses what could have been a deep-tree-of-replies
  layout problem into a *flat-spotlight-with-context* problem;
  (2) the *MOI selection is the alignment decision* observation —
  vertical alignment emerges from the rule that MOI + parent +
  last-chronological-reply all share indent 0; (3) the *single
  indent level* invariant — intermediates and earlier branch
  replies are *all* at indent 1; there is no recursive nesting.
  The four-rule MOI lifecycle (never-indented + scroll-pinned-
  auto-promotes + click-to-change + ephemeral-resets-on-reload)
  is the discipline that keeps the algorithm side-effect-free
  on a fresh page load.
parent: endo-but-for-bots--llm-designs-chat-reply-chain-visualization--message-of-interest-spotlight-algorithm-and-layout-computation
---

- [[chat-ui]] (topic) — chat-interface design surface; the MOI algorithm is one approach to reply-relationship visualization.
- [[ui-design]] (topic) — UI patterns; the *focus-as-alignment-decision* idiom.
- [[layout]] (topic) — layout algorithms; the *spine-with-branches* gutter layout.
- `endo-but-for-bots--llm-designs-chat-reply-chain-visualization--css-gutter-rendering-and-deprecation-rationale` — the next section: CSS pseudo-element line-drawing implementation, the CSS-over-SVG choice, and the deprecation context.
- `endo-but-for-bots--llm-designs-chat-focus-message--*` — the *superseding design*; takes the focus-as-layout-decision insight forward but with explicit-focus and keyboard-navigation rather than spotlight-on-spine.
- `endo-but-for-bots--llm-designs-chat-rename-dismiss-to-clear--rename-decision-record` (cycle 95) — another *single-section single-decision* chat design doc; sister structural pattern (focused-design-with-deprecation-history-or-rationale).
