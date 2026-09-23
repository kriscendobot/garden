---
title: The four-problem motivation that frames *giving a value to another agent* as a missing message type (a `package` with empty template strings is the current workaround; lacks clear reply semantics; requires `adopt` ceremony; doesn't fit the AI-agent-replies-with-result LLM-tool-loop) the unified design proposing a new `value` message type carrying exactly one `valueId` formula-identifier with **required** `replyTo` (every value message is a reply, unlike the optional-replyTo `package` type); the §sendValue method on Mail/Host/Guest with `(messageNumber, petNameOrPath, resultName?)` signature; the §implementation that infers the recipient from the parent message's other-party (same logic as `reply`), looks up the value's formula identifier via the directory, constructs the hardened ValueMessage, and posts it; the §auto-retain idiom — recipient's `deliver()` writes the value to the recipient's pet store under the `resultName` hint when present; the open question about envelope-vs-out-of-band carriage of `resultName`; the §message hub directory that exposes seven edges (FROM/TO/DATE/TYPE/MESSAGE/REPLY/VALUE) where VALUE is the primary payload; the §five-decision *reply-only / single-value / auto-retain-optional / no-promise-resolver-infrastructure / recipient-inferred-from-parent* rationale block; the §14-row Files Modified table that names the implementation surface spanning daemon (`types.d.ts` + `mail.js` + `host.js` + `guest.js` + `interfaces.js` + `help-text.js` + `daemon.js`), cli (`endo.js` + new `commands/send-value.js` + `inbox.js`), test (`daemon/test/endo.test.js`), and chat (`inbox-component.js` + `command-registry.js` + `command-executor.js`)
source: designs/daemon-value-message.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: HEAD (origin/llm, fetched 2026-06-02)
source_date: 2026-03-02
source_authors: [Kris Kowal (prompted)]
source_lines: "1-331 (full file)"
topics: [daemon]
status: current
notes: |
  Twenty-third endo-but-for-bots design ingest. Status: **Complete**
  — value message type, persistence, delivery via submit(), Chat UI
  rendering, VALUE edge, standalone sendValue method on Mail/Host/
  Guest, and send-value CLI command all implemented. The 331-line
  design defines a new `value` message type carrying exactly one
  `valueId` formula-identifier with required `replyTo`. Three
  structurally interesting moves: (1) the *reply-only* invariant
  (required replyTo, unlike package's optional replyTo) constrains
  value messages to the reply-with-result pattern that motivates
  them; (2) the *auto-retain* mechanism via optional `resultName`
  hint — recipient's `deliver()` writes the value to the pet store
  under the hint name, enabling zero-ceremony value delivery for
  the common case; (3) the *recipient-inferred-from-parent* rule —
  sendValue doesn't take a recipient argument because the parent
  message's other-party *is* the recipient, mirroring `reply` and
  preventing sending values to unrelated parties.
  
  Single-section cohesion-honest ingest (like cycles 95, 100, 101).
  The 331-line file is *one tight unified proposal* (introduce a new
  message type for value-replies); the apparent four-part decomposition
  (problem / design / decisions / files-modified) is one cohesive
  argument with implementation appendices. Pairs structurally with
  cycle 101's daemon-commands-as-messages which *reuses the reply
  pattern this design establishes* (every command's result reply
  is a value-typed reply with replyTo to the command).
kind: index
section_count: 6
---

Sections:

- [Abstract](endo-but-for-bots--llm-designs-daemon-value-message--value-message-type-and-reply-only-design--abstract.md)
- [Body](endo-but-for-bots--llm-designs-daemon-value-message--value-message-type-and-reply-only-design--body.md)
- [Connection to the wider library](endo-but-for-bots--llm-designs-daemon-value-message--value-message-type-and-reply-only-design--connection-to-the-wider-library.md)
- [Translation block (design idiom → contemporary practice)](endo-but-for-bots--llm-designs-daemon-value-message--value-message-type-and-reply-only-design--translation-block-design-idiom-contemporary-practice.md)
- [See also](endo-but-for-bots--llm-designs-daemon-value-message--value-message-type-and-reply-only-design--see-also.md)
- [Common confusions](endo-but-for-bots--llm-designs-daemon-value-message--value-message-type-and-reply-only-design--common-confusions.md)
