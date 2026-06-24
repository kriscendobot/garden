---
title: Common confusions
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

- **"`replyTo` could be optional — let value messages be unsolicited too."** It could *not* in this design. The §Design Decision #1 explicitly states *unsolicited values stay as `package`*. The `value`-type's purpose is *the reply-with-result pattern*; allowing unsolicited values would dilute the type's semantic.
- **"`sendValue` should take a recipient argument."** It explicitly does *not*. The §Design Decision #5 names *recipient inferred from parent* as a security feature — `sendValue` cannot send values to unrelated parties. The message-graph topology determines the recipient.
- **"Auto-retain should be unconditional — always write to the pet store."** It is *intentionally optional*. The §Design Decision #3 names *the recipient may choose to ignore* the hint. Forcing auto-retain would override recipient autonomy.
- **"Why not let `value` carry multiple values?"** §Design Decision #2 names this — *to send multiple values, send multiple value messages or use a `package`*. The *one-result-per-task* framing matches the common case; multi-value containers would dilute the type and complicate handling.
- **"`fire-and-forget` means the sender doesn't know if the value was received."** The sender knows the *message was delivered* (the `Promise<void>` resolves on delivery). The sender doesn't get *confirmation that the recipient retained or did anything with* the value — but that's appropriate because the recipient autonomy is preserved.
- **"`resultName` being in the envelope is a privacy leak."** The envelope is visible to both sender and recipient, but only the recipient *acts* on it. The §open question section acknowledges the privacy trade-off and names the alternative (recipient manually adopts).
- **"`endo adopt 5 VALUE my-result`'s `VALUE` is just a magic string."** It is *the canonical edge name* in the message hub directory schema. Other types have their own edge sets (`MESSAGE`, `REPLY`, etc.); `VALUE` is the value-message-specific edge. The schema is documented.
- **"The 14-file Files Modified table is excessive — most of it is plumbing."** It is *plumbing* — and the §design-doc-as-implementation-tracker discipline surfaces all of it. A future maintainer who wants to *add* a new message type can use this table as a template for what they'll need to touch.
- **"Why is this design `Complete` but daemon-commands-as-messages is `Not Started`?"** They're independent. Value messages shipped 2026-03-02 as the foundational reply primitive; commands-as-messages was proposed 2026-03-11 as a *consumer* of the value-as-reply pattern. The consumer hasn't been built yet; the primitive has.
- **"Daemon-form-request uses value messages — that's a circular dependency."** It's a *layering*. Value messages are the foundational primitive; form-request layers on top by using value-replies as form-submission results. The §Related Designs cross-reference names form-request as the *consumer*, not the dependency. The value-message design stands alone; form-request depends on it.
