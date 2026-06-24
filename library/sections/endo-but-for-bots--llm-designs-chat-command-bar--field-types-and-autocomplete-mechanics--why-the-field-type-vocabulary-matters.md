---
title: Why the field-type vocabulary matters
source: designs/chat-command-bar.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 3b031592e5f97a86e317cb96f1b7c44abb4e41f9
source_date: 2026-03-02
source_authors: [Kris Kowal]
topics: [chat-ui, agent-conventions]
status: current
parent: endo-but-for-bots--llm-designs-chat-command-bar--field-types-and-autocomplete-mechanics
---

The eight field types are how the chat command system **avoids
text-parsing** (one of the design principles in
[[endo-but-for-bots--llm-designs-chat-invariants--principles]]).
Instead of parsing `move foo.bar baz` as freeform text, the
`/move` command exposes two `petNamePath` fields and the user fills
each via the autocomplete grammar described above. The
text-parsing avoidance is the design's *structured input over text
parsing* principle realized at the field-vocabulary layer.

A new command added to the system uses these field types or extends
the vocabulary; new field types are rare enough that adding one
should be a deliberate, documented step (none of the eight have
been added since extraction).
