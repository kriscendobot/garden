---
title: Abstract
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

The §Message-of-Interest (MOI) Algorithm section opens with the *spotlight model* framing:

> Rather than visualizing all reply relationships, we use a *spotlight model* focused on a single *message-of-interest* (MOI). This keeps the UI clean and emphasizes the current conversation context.

The §Core Rules (lines 41-51) name five invariants: (1) *one MOI at a time*; (2) MOI is *never indented*; (3) automatic selection on scroll-pinned new-message arrival; (4) click to change MOI; (5) ephemeral state — MOI resets to the last message in the buffer on page reload. The §Line Drawing Rules (lines 53-68) decompose into two directions: *upward* (single line from MOI to parent; parent not indented) and *downward* (single reply → terminus flush-left + earlier replies as branches at indent 1 + intermediate messages between MOI and last-reply at indent 1 even when not direct replies). The §Visual Example (lines 70-90) renders the spine-with-branch structure as ASCII art. The §Algorithm Pseudocode (lines 92-145) defines `computeLayout(messages, moiId) → Map<id, { indent, lines }>` — looks up the MOI, sets MOI at indent 0 + no lines; finds the MOI's parent and adds an *up* line on the MOI; sorts replies-to-MOI chronologically; takes the *last* reply as the *primary* (down + primary: true line, indent 0); sets earlier replies as *branches* (down + primary: false lines, indent 1); walks the messages-array-slice between MOI and last-reply and sets any non-reply intermediates to indent 1. The §State Management section (lines 147-176) defines a ReplyVisualizationState typedef with `messageOfInterestId` + `scrollPinned`; on-message-received auto-promotes when pinned; on-message-click changes MOI explicitly; on-load resets to last-message. The §Indentation rule (lines 178-184): *single indent level* (~2ex; *no deep nesting since the MOI algorithm only visualizes one level of reply relationships at a time*).
