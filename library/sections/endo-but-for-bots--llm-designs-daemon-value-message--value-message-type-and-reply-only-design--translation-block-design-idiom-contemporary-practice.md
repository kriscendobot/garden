---
title: Translation block (design idiom → contemporary practice)
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

| Design idiom | Contemporary practice |
| ------------ | --------------------- |
| `replyTo is required, unlike package where it is optional` | The *type-level invariant* discipline; encode the constraint in the type, not just in the implementation. |
| `valueId: FormulaIdentifier` (single value) | The *single-value-per-message* invariant; multi-value cases use multiple messages. |
| `recipient inferred from parent` | The *security-by-topology* discipline; the message-graph determines the recipient. |
| `resultName is a hint from the sender, not a guarantee` | The *offer-not-force* discipline; the recipient retains the right to ignore. |
| `auto-retain mechanism` via `deliver()` writing to pet store | The *zero-ceremony-common-case* ergonomics. |
| `Open question: envelope vs out-of-band carriage` | The *honestly-unresolved* design question; document the trade-off without forcing closure. |
| 7-edge message hub (FROM/TO/DATE/TYPE/MESSAGE/REPLY/VALUE) | The *uniform-directory-shape-with-type-specific-edge* discipline. |
| `endo adopt 5 VALUE my-result` CLI pattern | The *capability-edge-adoption* idiom. |
| `fire-and-forget from sender's perspective` | The *no-promise-when-value-already-exists* distinction; requests use promises; values don't. |
| `one result per task` framing | The *agentic-loop-shape* — task in, result out, both as messages. |
| 14-row Files Modified table | The *design-doc-as-implementation-tracker* shape; surface every touched file. |
| `daemon-form-request uses value messages as their reply mechanism` | The *foundational-primitive-reused-by-higher-level-patterns* design layering. |
