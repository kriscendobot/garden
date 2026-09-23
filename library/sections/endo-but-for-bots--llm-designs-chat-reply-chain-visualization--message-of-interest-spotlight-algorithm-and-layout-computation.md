---
title: The *spotlight model* with exactly one *message-of-interest* (MOI) at a time as the canonical *focus-as-alignment-decision* idiom; the four-rule MOI lifecycle (MOI never indented + scroll-pinned-auto-promotes-new-messages + click-to-change + ephemeral-resets-on-reload); the upward-to-parent + downward-to-replies bidirectional line-drawing rules with last-chronological-reply special-cased as the *terminus* (flush-left) and earlier replies as *branches* (indented); the `computeLayout(messages, moiId)` pseudocode that returns a `Map<id, { indent, lines }>` keyed by message-id; the *no-deep-nesting* invariant (single indent level only); the vertical-alignment-as-emergent property — the MOI selection *is* the alignment decision; intermediate-messages-between-MOI-and-last-reply also get indented even when not direct replies
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
kind: index
section_count: 6
---

Sections:

- [Abstract](endo-but-for-bots--llm-designs-chat-reply-chain-visualization--message-of-interest-spotlight-algorithm-and-layout-computation--abstract.md)
- [Body](endo-but-for-bots--llm-designs-chat-reply-chain-visualization--message-of-interest-spotlight-algorithm-and-layout-computation--body.md)
- [Connection to the wider library](endo-but-for-bots--llm-designs-chat-reply-chain-visualization--message-of-interest-spotlight-algorithm-and-layout-computation--connection-to-the-wider-library.md)
- [Translation block (design idiom → contemporary practice)](endo-but-for-bots--llm-designs-chat-reply-chain-visualization--message-of-interest-spotlight-algorithm-and-layout-computation--translation-block-design-idiom-contemporary-practice.md)
- [See also](endo-but-for-bots--llm-designs-chat-reply-chain-visualization--message-of-interest-spotlight-algorithm-and-layout-computation--see-also.md)
- [Common confusions](endo-but-for-bots--llm-designs-chat-reply-chain-visualization--message-of-interest-spotlight-algorithm-and-layout-computation--common-confusions.md)
