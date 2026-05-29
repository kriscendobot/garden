---
title: Pre-fill mechanism and key files
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
  The mechanism that connects "press a shortcut key in focus mode" to
  "open the inline command form with `messageNumber` pre-filled and
  focus on the next empty field." Two API additions: `prefill?` on
  `setCommand(name, prefill?)` and `skipFilled` on `focus()`. Together
  they form a generic pre-fill primitive — not specific to focus
  mode — that other features (the blob `/view` and `/edit` editors;
  potentially the chat-message `/edit`) can compose with. Out-of-scope
  list at the bottom captures three deliberately-not-attempted ideas
  the design names explicitly.
---

> Abstract: `inline-command-form.js` accepts an optional `prefill`
> parameter on `setCommand(name, prefill?)`. After rendering the form
> fields, any matching field names in the prefill record are set as
> initial values; the `focus(skipFilled)` method advances past pre-
> filled fields so the user lands on the next *empty* field. The
> shortcut-key dispatch in focus mode reads `data-number` from the
> `.focused` envelope element, calls
> `enterCommandMode(commandName, { messageNumber: number })`, and the
> inline form renders with the message number already filled in and
> focus on the next empty field (typically the message body). The
> two API additions (`prefill?` and `skipFilled`) are deliberately
> **generic primitives**, not focus-mode-specific: any caller can
> pre-fill any form field through the same mechanism, which is why
> sibling designs (the blob `/view` and `/edit` editor's focus-mode
> shortcuts) can compose with it without re-architecting the form
> system. Four key files carry the implementation:
> `chat-bar-component.js` (focus logic, keyboard handling, modeline,
> chain/connection algorithms); `inline-command-form.js`
> (the `prefill` + `skipFilled` API additions);
> `inbox-component.js` (envelope wrapping with the three data
> attributes); `index.css` (envelope, focus, chain line, and
> connection styles). Out of scope: automatic MOI selection (this is
> exactly what the now-superseded reply-chain-visualization tried);
> multi-message selection; arrowheads on chain lines.

## The pre-fill API

`inline-command-form.js` accepts an optional `prefill` parameter on
`setCommand(name, prefill?)`. The contract:

1. The form renders the fields the command's registry entry declares.
2. Any field name in the `prefill` record that matches a declared
   field is set as that field's initial value.
3. The `focus(skipFilled)` method advances past pre-filled fields, so
   the user lands on the next *empty* field rather than the first
   field overall.

The `skipFilled` parameter is what makes the pre-fill *helpful* rather
than disruptive. Without it, the focus would land on the pre-filled
`messageNumber` field, and the user would have to tab past it to
reach the body field they want to type into. With `skipFilled`, the
form lands the cursor where the user's intent is: the next field they
need to fill themselves.

## The shortcut-to-form flow

When a shortcut key is pressed in focus mode:

1. Read `data-number` from the `.focused` envelope element (the
   attribute is set by `inbox-component.js` per
   [[endo-but-for-bots--llm-designs-chat-focus-message--visual-design-and-data-model]]).
2. Call `enterCommandMode(commandName, { messageNumber: number })`.
3. The inline form renders with the message number already filled in.
4. Focus advances to the next empty field.

The chain `data-number → setCommand prefill → focus(skipFilled)` is
the path from "user pressed `r`" to "user is typing the reply body."
Each link in the chain is independently generic: the `data-number`
attribute is just a DOM attribute; the prefill record is just a
key-value mapping; the `skipFilled` advance is a generic property of
the form's focus logic. Nothing in the path knows specifically about
focus mode.

## Genericity of the pre-fill primitive

The two API additions — `prefill?` on `setCommand` and `skipFilled` on
`focus()` — are deliberately generic primitives, not focus-mode-
specific. Any caller can pre-fill any form field through the same
mechanism.

Sibling designs that compose with the same primitive:

- [[endo-but-for-bots--llm-designs-chat-view-edit-commands--loading-blob-content-and-focus-mode]]
  uses focus mode plus the `v` and `e` shortcuts to dispatch `/view`
  and `/edit` against blob chips, pre-filling the `petNamePath` field
  with the focused blob's pet-name path. The same `setCommand`-with-
  `prefill` API serves both message-number and pet-name-path pre-fills.

- [[endo-but-for-bots--llm-designs-chat-edit-message-ui--design-decisions]]
  uses pre-fill in a slightly different shape: the *body* field is
  pre-populated from the message's typed payload (not the rendered
  DOM); embedded token chips carry the underlying locator. The same
  `prefill` mechanism carries the structured body and chip references
  rather than just a scalar like the message number.

The genericity is the reason the focus-mode design can ship the
mechanism once and have it compose with later features without those
features needing to extend it.

## Key files

The four files the focus-mode design touches:

| File | Change |
|------|--------|
| `packages/chat/chat-bar-component.js` | Focus mode logic, keyboard handling, modeline, chain/connection algorithms |
| `packages/chat/inline-command-form.js` | `prefill` parameter on `setCommand`, `skipFilled` on `focus` |
| `packages/chat/inbox-component.js` | Envelope wrapping, `data-number`/`data-message-id`/`data-reply-to` |
| `packages/chat/index.css` | Envelope, focus, chain line, and connection styles |

The split lines up with the design's architectural division: the
`chat-bar-component` owns mode and behavior; the
`inline-command-form` owns the form API; the `inbox-component` owns
the rendering of envelopes (and the data attributes they carry); the
CSS file owns the visual surface. The four files are the surface the
design names; the
[[endo-but-for-bots--llm-designs-chat-components--file-structure-and-component-map]]
section gives the broader context of the chat package's file layout
and what each component is responsible for.

## Out of scope (named non-goals)

The design names three deliberately out-of-scope ideas:

- **Automatic MOI selection.** This is exactly what the now-superseded
  `chat-reply-chain-visualization.md` tried to do (and what the
  [[endo-but-for-bots--llm-designs-chat-focus-message--motivation-entry-and-exit]]
  section quotes as "complex and implicit"). The supersession is
  deliberate: focus mode replaces automatic-MOI with deliberate-user-
  initiated.
- **Multi-message selection.** Focus mode highlights exactly one
  message at a time. The design names this constraint explicitly. The
  rationale isn't stated, but the constraint coheres with the
  shortcut-key contract: every shortcut pre-fills *one* message
  number into *one* form, and multi-message selection would require
  rethinking the form's typed-input model
  ([[endo-but-for-bots--llm-designs-chat-command-bar--field-types-and-autocomplete-mechanics]])
  which currently distinguishes `messageNumber` (one) from
  `petNamePaths` (multi).
- **Arrowheads on chain lines.** The chain and sub lines are plain
  vertical bars without arrowheads. The design names this absence;
  whether it is a stylistic preference or a deliberate simplification
  is not detailed. (One reading: arrowheads would force the renderer
  to determine *direction* of each connection at render time, which
  the current `chain-start` / `chain-end` / `sub-start` / `sub-end`
  class scheme already encodes structurally.)

The three out-of-scope items are useful even as non-goals: they bound
the design's claim. A future request to add multi-message selection
or arrowhead rendering is a deliberate change of scope, not an
oversight in the focus-message design.

## See also

- [[endo-but-for-bots--llm-designs-chat-focus-message--navigation-and-shortcut-keys]] — the shortcut-key list (`r` / `d` / `a` / `g` / `s`) the pre-fill mechanism dispatches into; modeline rendering.
- [[endo-but-for-bots--llm-designs-chat-focus-message--visual-design-and-data-model]] — the `data-number` attribute the shortcut-to-form flow reads; the DOM substrate the algorithm consumes.
- [[endo-but-for-bots--llm-designs-chat-components--file-structure-and-component-map]] — the broader chat package file layout; the four key files this section names sit within that map.
- [[endo-but-for-bots--llm-designs-chat-view-edit-commands--loading-blob-content-and-focus-mode]] — the sibling design that composes with the same pre-fill primitive, pre-filling `petNamePath` rather than `messageNumber`.
- [[endo-but-for-bots--llm-designs-chat-edit-message-ui--design-decisions]] — the chat-message-edit design that pre-fills the *body* field from typed payload; one more consumer of the same `prefill` mechanism.
- [[endo-but-for-bots--llm-designs-chat-command-bar--field-types-and-autocomplete-mechanics]] — the typed-field-types vocabulary; the pre-fill mechanism operates on these typed fields.
- [[producer-typed-shape-consumer-rendering]] — the broader principle: a generic pre-fill primitive at the typed-shape layer (the form's field model) lets multiple consumers (focus-mode, blob-editor, message-editor) compose without each needing its own pre-fill plumbing.

Source: [designs/chat-focus-message.md](https://github.com/endojs/endo-but-for-bots/blob/8fe17b1c61bf50fae8a97f97bc2aa7385a209f11/designs/chat-focus-message.md) at commit `8fe17b1c`.
