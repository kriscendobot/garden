---
title: Translation block (design idiom → contemporary practice)
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

| Design idiom | Contemporary practice |
| ------------ | --------------------- |
| `spotlight model` | The *focus-on-one-element-with-immediate-context* discipline; bounded visual complexity regardless of full structure. |
| `MOI is never indented` | The *spine-at-indent-0* invariant; the MOI defines the column for the conversation. |
| `MOI selection IS the alignment decision` | The *user-selection-as-layout-input* discipline; alignment is not heuristic but explicit. |
| `single indent level` | The *two-zone-layout-vocabulary* simplification; deliberately rules out depth-of-reply as information. |
| `Click to change` | The *click-anywhere-to-refocus* affordance; no special UI affordance, all messages are clickable. |
| `scroll-pinned auto-promotes` | The *follow-along-mode* — when pinned, new messages take focus automatically. |
| `ephemeral state` | The *no-MOI-persistence* discipline; reload resets to latest message. |
| `computeLayout(messages, moiId) → Map<id, { indent, lines }>` | The *id-keyed-monotonic-Map* layout-output shape; renderer iterates by chronology, looks up by id. |
