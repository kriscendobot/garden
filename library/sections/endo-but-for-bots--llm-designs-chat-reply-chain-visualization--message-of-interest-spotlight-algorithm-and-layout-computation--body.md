---
title: Body
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
