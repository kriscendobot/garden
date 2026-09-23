---
title: Common confusions
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

- **"The MOI algorithm just renders the reply tree."** It does *not* render the reply tree. It renders *only* the MOI's parent, the MOI's replies, and intermediates-between-MOI-and-last-reply. All other reply relationships in the message buffer are *invisible*.
- **"Intermediates between MOI and last-reply are also replies to MOI."** They are *not necessarily*. The pseudocode (lines 137-144) walks the messages-array-slice between MOI and last-reply and indents *everything* that isn't already in the layout. A message in that range that replies to *some other* message (not MOI) gets indented because it's *in the slice*, not because it has any reply relationship to MOI. This is intentional — the indent visually says *this is between the MOI and the conversation's end; aside from the main spine*.
- **"The 'last reply' should be the most-recent-by-timestamp."** It is — the pseudocode sorts replies by timestamp and takes the last. The §discipline: chronological-last, not most-recent-by-arrival-time. For a synchronous channel these are the same.
- **"Scroll-pinned new-message auto-promote can clobber the user's MOI."** It can — *when the user is scroll-pinned*. The intent is that scroll-pinned implies *follow-along*; promoting new messages matches that intent. If the user wants to keep a specific MOI, they unpin (scroll up).
- **"The single-indent-level invariant means the algorithm can't handle deep threads."** It is *deliberate*. The MOI algorithm visualizes *one level of reply relationships at a time*. Deeper-thread navigation would happen by clicking a reply to make it the MOI; the previous-MOI moves up to be the parent in the new layout. Multi-step navigation through a deep thread becomes a sequence of MOI changes.
- **"`messages.find` is O(n) on every layout — that's slow."** It is — *and the design accepts it*. The Performance Considerations section names virtualization, debouncing, and caching as the response. The pseudocode is the canonical reference shape; production code can substitute an id-indexed Map for the find calls.
- **"The MOI must be visible in viewport — it's the user's focus."** It does not have to be. The off-screen-messages note says *lines render regardless of whether the parent or other connected messages are currently visible in the viewport*. The MOI is a *state* property, not a *viewport* property.
