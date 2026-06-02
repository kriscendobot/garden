---
title: The *spotlight model* with exactly one *message-of-interest* (MOI) at a time as the canonical *focus-as-alignment-decision* idiom; the four-rule MOI lifecycle (MOI never indented + scroll-pinned-auto-promotes-new-messages + click-to-change + ephemeral-resets-on-reload); the upward-to-parent + downward-to-replies bidirectional line-drawing rules with last-chronological-reply special-cased as the *terminus* (flush-left) and earlier replies as *branches* (indented); the `computeLayout(messages, moiId)` pseudocode that returns a `Map<id, { indent, lines }>` keyed by message-id; the *no-deep-nesting* invariant (single indent level only); the vertical-alignment-as-emergent property — the MOI selection *is* the alignment decision; intermediate-messages-between-MOI-and-last-reply also get indented even when not direct replies
source: designs/chat-reply-chain-visualization.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: HEAD (origin/llm, fetched 2026-06-01)
source_date: 2026-02-28
source_authors: [Kris Kowal (prompted)]
source_lines: "1-200 (Motivation + Data Model + Message-of-Interest Algorithm + Indentation)"
topics: [chat-ui, ui-design, layout]
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
---

## Abstract

The §Message-of-Interest (MOI) Algorithm section opens with the *spotlight model* framing:

> Rather than visualizing all reply relationships, we use a *spotlight model* focused on a single *message-of-interest* (MOI). This keeps the UI clean and emphasizes the current conversation context.

The §Core Rules (lines 41-51) name five invariants: (1) *one MOI at a time*; (2) MOI is *never indented*; (3) automatic selection on scroll-pinned new-message arrival; (4) click to change MOI; (5) ephemeral state — MOI resets to the last message in the buffer on page reload. The §Line Drawing Rules (lines 53-68) decompose into two directions: *upward* (single line from MOI to parent; parent not indented) and *downward* (single reply → terminus flush-left + earlier replies as branches at indent 1 + intermediate messages between MOI and last-reply at indent 1 even when not direct replies). The §Visual Example (lines 70-90) renders the spine-with-branch structure as ASCII art. The §Algorithm Pseudocode (lines 92-145) defines `computeLayout(messages, moiId) → Map<id, { indent, lines }>` — looks up the MOI, sets MOI at indent 0 + no lines; finds the MOI's parent and adds an *up* line on the MOI; sorts replies-to-MOI chronologically; takes the *last* reply as the *primary* (down + primary: true line, indent 0); sets earlier replies as *branches* (down + primary: false lines, indent 1); walks the messages-array-slice between MOI and last-reply and sets any non-reply intermediates to indent 1. The §State Management section (lines 147-176) defines a ReplyVisualizationState typedef with `messageOfInterestId` + `scrollPinned`; on-message-received auto-promotes when pinned; on-message-click changes MOI explicitly; on-load resets to last-message. The §Indentation rule (lines 178-184): *single indent level* (~2ex; *no deep nesting since the MOI algorithm only visualizes one level of reply relationships at a time*).

## Body

### §The spotlight model — one MOI as the focus-as-alignment-decision idiom

The §opening framing names the design's central insight:

> Rather than visualizing all reply relationships, we use a *spotlight model* focused on a single *message-of-interest* (MOI). This keeps the UI clean and emphasizes the current conversation context.

The §structural reading:

- **The naïve alternative** would visualize the full reply forest — every message's `replyTo` rendered as a tree edge. For a busy channel with branching replies, this produces visual clutter and ambiguous *where am I in the conversation* state.
- **The spotlight model** instead picks *one* MOI and renders *only its immediate context* (parent + replies). All other reply relationships are *invisible*.
- **The benefit**: the layout is always interpretable. A user sees *what conversation am I in* (the spine through MOI), and *what other replies exist* (branch-indented), and *who is the parent of this message* (flush-left above).

The §discipline: *focus is the layout, not a decoration on top of the layout*. There is no special MOI styling beyond its position in the line structure. The MOI is *implicit in the visual structure* — the user infers which message is MOI from the fact that *it sits on the spine without indentation while connected to a parent above and replies below*.

### §The four-rule MOI lifecycle

The §Core Rules (lines 41-51) name the MOI's lifecycle invariants:

1. **One MOI at a time** — always exactly one message is the MOI. No multi-spotlight, no MOI-stack, no MOI-history.
2. **MOI is never indented** — appears at indent 0 (left edge).
3. **Automatic selection on scroll-pinned new-message arrival** — when the user is *following along* (scroll pinned to bottom), each new incoming message becomes the MOI automatically.
4. **Click to change** — user can click any message to make it the MOI.
5. **Ephemeral state** — MOI resets to the last message in the buffer on page reload.

The §structural picture:

- **Two ways to advance the MOI**: implicit (scroll-pinned + new-message) and explicit (click).
- **No persistence**: the MOI is intentionally session-local. Reload resets to *the latest message*. The design favors *current-conversation-context* over *resume-where-you-left-off*.
- **The scroll-pinned trigger** is the *follow-along* affordance. When pinned, the user has implicitly opted into *show me whatever just arrived*; promoting new messages to MOI matches that intent. When unpinned (user scrolled up to read something), new messages don't disturb the user's focus.

### §The bidirectional line-drawing rules

The §Line Drawing Rules (lines 53-68) split into *upward* and *downward* directions.

**§Upward — MOI to parent**:

> Draw a line from the MOI to the message it replies to. The parent message is not indented.

The §invariant: *the parent is flush-left*. This is structurally significant — the parent, like the MOI, *sits on the main spine*. The spine is therefore a vertical line through *parent + MOI + last-reply* (and any pass-through messages between them).

**§Downward — MOI to replies**:

The §three sub-cases:

- **Single reply** — draw a line to the reply; the reply is *not indented* (flush-left, on the spine). All messages chronologically between MOI and the reply that *aren't* the reply itself are indented to indent 1.
- **Multiple replies** — the *chronologically last* reply is the *terminus*: not indented, on the spine. Earlier replies are *branches*: indented + connected by a horizontal stub from the spine. Intermediates between MOI and last-reply are indented.
- **No replies** — the spine ends at the MOI (no downward line).

The §sub-case-collapsing observation: *single reply* is a degenerate *multiple replies* with zero earlier replies. The pseudocode handles them with one branch (lines 119-135).

**§No other lines**:

> Reply relationships not involving the MOI are not visualized.

The §discipline: *the spotlight is exclusive*. A message that is a reply to *some other message that isn't the MOI* is rendered as a plain message — no line, no connection to its parent, no indication of its reply-status. The MOI defines *the* conversation; everything else is just *other recent messages*.

### §The computeLayout pseudocode

The §pseudocode (lines 92-145) is structurally compact (~50 lines) and worth quoting in full:

```js
const computeLayout = (messages, moiId) => {
  const moi = messages.find(m => m.id === moiId);
  const layout = new Map(); // messageId -> { indent: number, lines: [] }

  // MOI is never indented
  layout.set(moiId, { indent: 0, lines: [] });

  // Find MOI's parent
  if (moi.replyTo) {
    const parent = messages.find(m => m.id === moi.replyTo);
    if (parent) {
      layout.set(parent.id, { indent: 0, lines: [] });
      layout.get(moiId).lines.push({ to: parent.id, direction: 'up' });
    }
  }

  // Find replies to MOI
  const replies = messages
    .filter(m => m.replyTo === moiId)
    .sort((a, b) => a.timestamp - b.timestamp);

  if (replies.length > 0) {
    const lastReply = replies[replies.length - 1];
    // Last reply is not indented
    layout.set(lastReply.id, { indent: 0, lines: [] });
    layout.get(moiId).lines.push({ to: lastReply.id, direction: 'down', primary: true });

    // Other replies are branches
    for (const reply of replies.slice(0, -1)) {
      layout.set(reply.id, { indent: 1, lines: [] });
      layout.get(moiId).lines.push({ to: reply.id, direction: 'down', primary: false });
    }

    // Intermediate messages (between MOI and last reply, not replies themselves)
    const moiIndex = messages.findIndex(m => m.id === moiId);
    const lastReplyIndex = messages.findIndex(m => m.id === lastReply.id);
    const replyIds = new Set(replies.map(r => r.id));

    for (let i = moiIndex + 1; i < lastReplyIndex; i++) {
      const msg = messages[i];
      if (!replyIds.has(msg.id) && !layout.has(msg.id)) {
        layout.set(msg.id, { indent: 1, lines: [] });
      }
    }
  }

  // All other messages: no indent, no lines
  for (const msg of messages) {
    if (!layout.has(msg.id)) {
      layout.set(msg.id, { indent: 0, lines: [] });
    }
  }

  return layout;
};
```

The §five-pass structure:

1. **MOI** at indent 0, no lines.
2. **Parent (if present)** at indent 0; the MOI gets an *up* line to it.
3. **Last reply (if any)** at indent 0; the MOI gets a *down primary* line to it.
4. **Earlier replies** at indent 1; the MOI gets *down branch* lines to each.
5. **Intermediates** between MOI and last-reply at indent 1 (only those that aren't themselves direct replies and aren't already in the layout).
6. **Everything else** at indent 0, no lines (the *plain messages*).

The §pass-order observation: each later pass *adds* entries but never *modifies* earlier ones. The Map is monotonic-grow. The §discipline lets the algorithm be re-runnable from scratch on each MOI change with no need to clear or diff.

The §key data-structure choice: `Map<id, { indent: number, lines: [] }>` — id-keyed not array-indexed. The renderer iterates the messages array in chronological order; for each, it looks up the layout entry by id. The Map can be passed across re-renders without needing to track index-stability.

### §The vertical-alignment-as-emergent property

The §Vertical Alignment section (lines 280-298) names the emergent property:

> The MOI algorithm naturally produces vertical alignment: the MOI, its parent, and the chronologically last reply all share indent level 0. This creates a clean vertical spine through the primary conversation path. Branch replies and intermediate messages are indented, visually *set aside*.

The §observation:

> This approach eliminates the need for complex alignment heuristics — the MOI selection *is* the alignment decision.

The §structural picture:

- **The naïve approach** to reply-chain alignment is *render the tree with each reply indented under its parent*. The result is a *staircase* — replies of replies of replies push further right; the visual structure depends on the conversation's branching depth.
- **The MOI approach** instead picks a *single spine* (parent → MOI → last-reply) at indent 0, and pushes everything else (branches, intermediates) to indent 1. The spine is *always* a single vertical line regardless of conversation depth.
- **The user's input becomes the alignment**. Clicking a different message re-roots the spine. The alignment is *not* a property of the message tree; it is a property of *which message the user is looking at*.

The §design intent: *focus is the layout decision*. Instead of having a layout algorithm that tries to *guess* what conversation the user is in (recent-most-active branch? deepest unread thread? message with most reactions?), the layout asks the user. The MOI is *the user's answer*.

### §The single-indent-level invariant

The §Indentation section (lines 178-184) names the depth invariant:

> **Indent unit**: ~2ex (approximately 2 character widths, scales with font size). All indented messages (intermediates and earlier replies) use a single indent level. There is no deep nesting since the MOI algorithm only visualizes one level of reply relationships at a time.

The §two claims:

- **Indent unit is ~2ex**, font-size-relative. The choice scales with text size: when the user zooms or the font changes, the indent grows proportionally.
- **Single indent level only**. The algorithm never produces indent ≥ 2.

The §design intent: *the layout has only two zones — spine and aside*. The simplification rules out *visual depth-of-reply* as an information channel. A user cannot infer *how deep this thread goes* from the indentation; they can only infer *am I on the spine or aside*.

The §contrast with Slack/Discord *threaded replies*: those systems indent each reply under its parent, producing nested visual structure. The MOI approach explicitly rejects that — depth-of-nesting is not part of the layout vocabulary.

## Connection to the wider library

This section is the **canonical *focus-as-alignment-decision* worked example**. Three threads:

1. **The spotlight model collapses a tree problem into a flat-with-context problem**. Instead of laying out the full reply forest, render only the MOI's immediate neighborhood. The complexity of *what's on screen* is bounded regardless of conversation depth.

2. **The user's selection becomes the layout decision**. The MOI is chosen by the user (via click or scroll-pinned auto-promote); the layout follows from the choice. This is the *user-input-as-state-not-just-action* discipline.

3. **The single-indent-level invariant** is a worked example of *deliberate-vocabulary-restriction*. The algorithm *could* support arbitrary nesting; the design *chooses* not to, because two-zone layout (spine + aside) is easier to read than n-zone layout (depth 0, depth 1, depth 2, ...).

The §superseding-by-chat-focus-message context (covered in the next section): the *Deprecated* status comes from a subsequent redesign that kept the *focus is the layout* observation but changed *how the focus is selected and represented*.

## Translation block (design idiom → contemporary practice)

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

## See also

- [[chat-ui]] (topic) — chat-interface design surface; the MOI algorithm is one approach to reply-relationship visualization.
- [[ui-design]] (topic) — UI patterns; the *focus-as-alignment-decision* idiom.
- [[layout]] (topic) — layout algorithms; the *spine-with-branches* gutter layout.
- `endo-but-for-bots--llm-designs-chat-reply-chain-visualization--css-gutter-rendering-and-deprecation-rationale` — the next section: CSS pseudo-element line-drawing implementation, the CSS-over-SVG choice, and the deprecation context.
- `endo-but-for-bots--llm-designs-chat-focus-message--*` — the *superseding design*; takes the focus-as-layout-decision insight forward but with explicit-focus and keyboard-navigation rather than spotlight-on-spine.
- `endo-but-for-bots--llm-designs-chat-rename-dismiss-to-clear--rename-decision-record` (cycle 95) — another *single-section single-decision* chat design doc; sister structural pattern (focused-design-with-deprecation-history-or-rationale).

## Common confusions

- **"The MOI algorithm just renders the reply tree."** It does *not* render the reply tree. It renders *only* the MOI's parent, the MOI's replies, and intermediates-between-MOI-and-last-reply. All other reply relationships in the message buffer are *invisible*.
- **"Intermediates between MOI and last-reply are also replies to MOI."** They are *not necessarily*. The pseudocode (lines 137-144) walks the messages-array-slice between MOI and last-reply and indents *everything* that isn't already in the layout. A message in that range that replies to *some other* message (not MOI) gets indented because it's *in the slice*, not because it has any reply relationship to MOI. This is intentional — the indent visually says *this is between the MOI and the conversation's end; aside from the main spine*.
- **"The 'last reply' should be the most-recent-by-timestamp."** It is — the pseudocode sorts replies by timestamp and takes the last. The §discipline: chronological-last, not most-recent-by-arrival-time. For a synchronous channel these are the same.
- **"Scroll-pinned new-message auto-promote can clobber the user's MOI."** It can — *when the user is scroll-pinned*. The intent is that scroll-pinned implies *follow-along*; promoting new messages matches that intent. If the user wants to keep a specific MOI, they unpin (scroll up).
- **"The single-indent-level invariant means the algorithm can't handle deep threads."** It is *deliberate*. The MOI algorithm visualizes *one level of reply relationships at a time*. Deeper-thread navigation would happen by clicking a reply to make it the MOI; the previous-MOI moves up to be the parent in the new layout. Multi-step navigation through a deep thread becomes a sequence of MOI changes.
- **"`messages.find` is O(n) on every layout — that's slow."** It is — *and the design accepts it*. The Performance Considerations section names virtualization, debouncing, and caching as the response. The pseudocode is the canonical reference shape; production code can substitute an id-indexed Map for the find calls.
- **"The MOI must be visible in viewport — it's the user's focus."** It does not have to be. The off-screen-messages note says *lines render regardless of whether the parent or other connected messages are currently visible in the viewport*. The MOI is a *state* property, not a *viewport* property.
