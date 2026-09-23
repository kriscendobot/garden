---
title: Connection to the wider library
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

This section is the **canonical *focus-as-alignment-decision* worked example**. Three threads:

1. **The spotlight model collapses a tree problem into a flat-with-context problem**. Instead of laying out the full reply forest, render only the MOI's immediate neighborhood. The complexity of *what's on screen* is bounded regardless of conversation depth.

2. **The user's selection becomes the layout decision**. The MOI is chosen by the user (via click or scroll-pinned auto-promote); the layout follows from the choice. This is the *user-input-as-state-not-just-action* discipline.

3. **The single-indent-level invariant** is a worked example of *deliberate-vocabulary-restriction*. The algorithm *could* support arbitrary nesting; the design *chooses* not to, because two-zone layout (spine + aside) is easier to read than n-zone layout (depth 0, depth 1, depth 2, ...).

The §superseding-by-chat-focus-message context (covered in the next section): the *Deprecated* status comes from a subsequent redesign that kept the *focus is the layout* observation but changed *how the focus is selected and represented*.
