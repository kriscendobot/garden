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
kind: index
section_count: 6
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

Sections:

- [The pre-fill API](endo-but-for-bots--llm-designs-chat-focus-message--prefill-mechanism-and-key-files--the-pre-fill-api.md)
- [The shortcut-to-form flow](endo-but-for-bots--llm-designs-chat-focus-message--prefill-mechanism-and-key-files--the-shortcut-to-form-flow.md)
- [Genericity of the pre-fill primitive](endo-but-for-bots--llm-designs-chat-focus-message--prefill-mechanism-and-key-files--genericity-of-the-pre-fill-primitive.md)
- [Key files](endo-but-for-bots--llm-designs-chat-focus-message--prefill-mechanism-and-key-files--key-files.md)
- [Out of scope (named non-goals)](endo-but-for-bots--llm-designs-chat-focus-message--prefill-mechanism-and-key-files--out-of-scope-named-non-goals.md)
- [See also](endo-but-for-bots--llm-designs-chat-focus-message--prefill-mechanism-and-key-files--see-also.md)

Source: [designs/chat-focus-message.md](https://github.com/endojs/endo-but-for-bots/blob/8fe17b1c61bf50fae8a97f97bc2aa7385a209f11/designs/chat-focus-message.md) at commit `8fe17b1c`.
