---
title: Abstract
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
parent: endo-but-for-bots--llm-designs-daemon-value-message--value-message-type-and-reply-only-design
---

The §opening Problem block (lines 10-38) frames *giving a value to another agent* as a missing message type. Endo's existing messages either carry text-with-references (`package`), promises (`request`/`form-request`), or code (`eval-request`/`definition`). The §four problems with the current `package`-as-empty-template workaround: (1) *a `package` requires template strings* — the sender must construct a non-empty `strings` array; (2) *no clear reply semantics* — promise-resolution returns a value, but `package` reply can only carry references as named edges within text; (3) *adopt ceremony* — the recipient must explicitly `adopt` each edge name; (4) *LLM agent tool results* — an AI agent producing a task result (file, capability, computed object) should be able to reply with the result as a first-class retained value. The §Design (lines 40-277) proposes a new `value` message type carrying exactly one `valueId` formula-identifier with *required* `replyTo` (every value message is a reply). The §implementation traces through 14 subsections covering: (a) the `ValueMessage` typedef with required `replyTo: FormulaNumber` and `valueId: FormulaIdentifier`; (b) `MessageFormula.messageType` union extension adding `'value'`; (c) the `Mail.sendValue(messageNumber, petNameOrPath, resultName?)` interface; (d) the `mail.js` implementation that infers the recipient from the parent message's other-party, looks up the value's formula identifier via the directory, constructs the hardened ValueMessage with `replyTo: parent.messageId`, and posts to the recipient handle; (e) the auto-retain mechanism — recipient's `deliver()` writes the value to the pet store under the `resultName` hint when present; (f) the open question of envelope-vs-out-of-band `resultName` carriage; (g) the message hub directory's seven edges (FROM/TO/DATE/TYPE/MESSAGE/REPLY/VALUE); (h) Guest+Host interface exposures with M.call interface guards; (i) help text and CLI command (`endo send-value <message-number> <pet-name> --as <agent> --name <result>`); (j) CLI inbox display formatting (with optional *(as "task-result")* annotation when `resultName` is present); (k) Chat UI rendering (sender chip + *sent a value* text + reply-chain indicator + inline value preview + Adopt button or pet-name chip). The §Design Decisions (lines 279-301) name five rationale points: *reply-only* (unsolicited values stay as `package`); *single value* (multiple values use multiple messages or `package`); *auto-retain is optional* (resultName is a hint, not a guarantee); *no promise/resolver infrastructure* (value messages are fire-and-forget from sender perspective; no promise to resolve); *recipient inferred from parent* (prevents sending values to unrelated parties). The §Files Modified (lines 303-321) names 14 implementation surfaces spanning daemon (7 files), cli (3 files), test (1 file), and chat (3 files). The §Related Designs (lines 322-331) cross-references three sister designs: `daemon-form-request` (forms use value messages as reply mechanism), `chat-reply-chain-visualization` (value messages participate in reply chains), `daemon-capability-bank` (value messages could deliver capability grants).
