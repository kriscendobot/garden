---
title: Visual design and data model
source: designs/chat-focus-message.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 8fe17b1c61bf50fae8a97f97bc2aa7385a209f11
source_date: 2026-03-04
source_authors: [Kris Kowal]
ingested: 2026-05-29
ingested_by: scholar
topics: [chat-ui]
status: current
notes: |
  The DOM and CSS shape that the indentation / chain-line algorithm
  acts on, plus the three data attributes (`data-number`,
  `data-message-id`, `data-reply-to`) the envelope carries to support
  the algorithm. The `background-image` gradient technique is the
  reason chain lines can span continuously between messages without
  intermediate margins; without zero-margin envelope wrapping, the
  gradients would break at envelope boundaries.
---

> Abstract: Each message is wrapped in a `.message-envelope` element
> with **no intermediate margin**, so chain and sub lines can span
> continuously between messages as `background-image` gradients drawn
> on the envelope itself. The envelope carries `data-number`,
> `data-message-id`, and `data-reply-to` attributes (set during
> rendering in `inbox-component.js`); these are exactly what the
> indentation algorithm walks and what shortcut-key dispatch reads.
> Envelopes use `padding: 4px 0` to center the message bubble, and
> chain/sub lines are drawn as gradients that span continuously
> *between* envelopes precisely because the envelopes have no margin
> between them. The focused message stays at its normal position
> (no indentation) and receives a 2px ring highlight in
> `var(--accent-primary)`; indented (non-chain) messages are
> indented `4ex` via `margin-left` on the inner `.message` element.
> Primary lines run at `2ex` (the chain gutter) and secondary
> lines at `6ex` (`2ex` inside the indent column). Both use
> `--msg-sent-bg` color at `2px` width so the visual language is
> consistent between primary and secondary lines at their respective
> gutter positions.

## Envelope structure

Each message is wrapped in a `.message-envelope` element with no
intermediate margin. The envelope carries three data attributes:

- `data-number` — the message number (used for command pre-fill).
- `data-message-id` — the message's unique ID (used for chain
  traversal).
- `data-reply-to` — the ID of the parent message (used for chain
  traversal and connection classification).

Envelopes use `padding: 4px 0` to center the message bubble. Chain
and sub lines are drawn as `background-image` gradients on the
envelope so they span continuously between messages.

The zero-margin-between-envelopes discipline is what lets the
gradients continue across envelope boundaries. If envelopes carried a
margin, the gradient would break at each boundary and the chain line
would appear as discrete segments rather than one continuous line. The
`padding` lives *inside* the envelope and centers the bubble; spacing
*between* messages comes from the envelope's own height (the bubble's
own size plus the padding), not from inter-envelope margin.

## Focused message

The focused message stays at its normal position (no indentation) and
receives a ring highlight:

```css
.focus-active .message-envelope.focused .message {
  box-shadow: 0 0 0 2px var(--accent-primary);
}
```

The `.focus-active` class on the messages container scopes the
highlight to focus mode; outside focus mode the `.focused` class is
removed (per the *exiting focus mode* contract in
[[endo-but-for-bots--llm-designs-chat-focus-message--motivation-entry-and-exit]])
and the highlight does not render even if the class were stale.

## Indented messages

All non-chain messages are indented:

```css
.focus-active .message-envelope.indented .message {
  margin-left: 4ex;
}
```

The indent applies to the inner `.message` element rather than the
outer `.message-envelope` so the envelope's own background-image
gradient (the chain line, when this envelope contributes to one)
still spans full-width without being indented.

## Line styling

Both primary and secondary lines use `--msg-sent-bg` color at `2px`
width:

| Line kind | Offset | Where in the envelope |
|---|---|---|
| Primary (chain) | `2ex` | The chain gutter created by the indent |
| Secondary (sub) | `6ex` | `2ex` into the `4ex` indent of indented messages |

Both lines use the same color and weight at *corresponding positions
within their respective gutter spaces*. This is what the source
describes as "the same color and weight at corresponding positions"
keeping the visual language consistent — the chain line and the sub
line are not visually distinguished by color or weight, only by where
they sit in the layout.

The choice of `--msg-sent-bg` (the user's own outgoing-message
background color) for the line color ties the visualization to the
chat's color scheme: in dark mode the chain line picks up the
sent-bubble color; in light mode it picks up that scheme's
corresponding token; in high-contrast modes it follows the same. The
[[endo-but-for-bots--llm-designs-chat-color-schemes--motivation-and-current-state]]
section captures the broader parameterization of color tokens that
makes this work.

## Data model

Message envelopes carry the three data attributes set during rendering
in `inbox-component.js`:

- `data-number`: the message number, used for command pre-fill when
  a shortcut key fires (see
  [[endo-but-for-bots--llm-designs-chat-focus-message--prefill-mechanism-and-key-files]]).
- `data-message-id`: the message's unique ID, used for chain traversal
  (the primary chain walk in
  [[endo-but-for-bots--llm-designs-chat-focus-message--indentation-algorithm-and-chain-lines]]
  reads this to identify ancestor and descendant chain members).
- `data-reply-to`: the ID of the parent message, used for both chain
  traversal (the backward walk follows `replyTo` links) and connection
  classification (the secondary-connections pass reads this to decide
  whether an indented message is gutter-connected,
  predecessor-connected, or a reply-indicator).

The three attributes form a minimal interface between the rendering
side (`inbox-component.js` writes them) and the focus-mode side
(`chat-bar-component.js` reads them). The split lets the focus-mode
algorithms walk the DOM without needing access to the underlying
message data model: the DOM itself carries enough structure to run the
chain walk and the connection classification. This is one instance of
[[producer-typed-shape-consumer-rendering]] applied at the DOM
boundary — the producer (the inbox component) owns the typed shape
(the message records); the consumer (the focus-mode algorithms) reads
a *rendered* projection of that shape (the DOM data attributes) and
does not re-parse the underlying records.

## See also

- [[endo-but-for-bots--llm-designs-chat-focus-message--indentation-algorithm-and-chain-lines]] — the algorithm that operates on this DOM shape: which envelopes are indented, which carry chain-* and sub-* classes, and how the data attributes are walked.
- [[endo-but-for-bots--llm-designs-chat-focus-message--prefill-mechanism-and-key-files]] — the `data-number` attribute's other use: pre-filling the inline command form when a shortcut key fires.
- [[endo-but-for-bots--llm-designs-chat-components--css-variables-and-security]] — the `--accent-primary` and `--msg-sent-bg` CSS custom properties used here; the broader CSS variable inventory.
- [[endo-but-for-bots--llm-designs-chat-color-schemes--motivation-and-current-state]] — how `--msg-sent-bg` is parameterized across the chat client's color schemes; the chain line's color tracks the scheme automatically.
- [[producer-typed-shape-consumer-rendering]] — the broader design principle: the focus-mode algorithms consume a rendered DOM projection of the message records, not the records themselves.

Source: [designs/chat-focus-message.md](https://github.com/endojs/endo-but-for-bots/blob/8fe17b1c61bf50fae8a97f97bc2aa7385a209f11/designs/chat-focus-message.md) at commit `8fe17b1c`.
