---
title: Connection to the wider library
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

This section is the **canonical *single-feature-fully-traced-across-packages* worked example**. Three threads:

1. **The reply-only single-value invariant** — the `value` message type's structural constraint (required `replyTo`, single `valueId`) keeps it focused on the reply-with-result pattern. Each message type has a single use case; conflation across types is rejected.

2. **The auto-retain-optional `resultName` hint** — the *offer-ergonomics-preserve-flexibility* dual-mode pattern. Recipients can accept the hint for zero-ceremony delivery or ignore it for explicit control.

3. **The recipient-inferred-from-parent discipline** — the security-by-topology pattern. The message-graph topology determines the recipient; `sendValue` cannot send to unrelated parties because it doesn't take a recipient argument.

The §value-as-reply pattern is *foundational* — cycle 101's daemon-commands-as-messages design reuses it (every command's result reply is a value-typed message with `replyTo` to the command). Together they form the *daemon's reply-primitive layer*.
