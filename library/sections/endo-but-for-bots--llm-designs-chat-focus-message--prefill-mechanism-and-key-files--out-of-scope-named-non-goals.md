---
title: Out of scope (named non-goals)
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
parent: endo-but-for-bots--llm-designs-chat-focus-message--prefill-mechanism-and-key-files
---

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

Source: [designs/chat-focus-message.md](https://github.com/endojs/endo-but-for-bots/blob/8fe17b1c61bf50fae8a97f97bc2aa7385a209f11/designs/chat-focus-message.md) at commit `8fe17b1c`.
