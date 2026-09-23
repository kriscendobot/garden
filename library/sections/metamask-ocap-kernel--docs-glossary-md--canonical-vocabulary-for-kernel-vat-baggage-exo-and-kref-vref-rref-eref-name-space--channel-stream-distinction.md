---
source: docs/glossary.md
source_repo: MetaMask/ocap-kernel
source_url: https://github.com/MetaMask/ocap-kernel/blob/main/docs/glossary.md
source_path: docs/glossary.md
source_commit: a3eff0efb70ba5f4c5919290aa295fe32138df4f
section_kind: doc
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - daemon
  - captp
  - capability-security
genre: §sibling-implementation-comparison
cycle: 163
lane: comments
status: current
title: §Channel-stream-distinction
parent: metamask-ocap-kernel--docs-glossary-md--canonical-vocabulary-for-kernel-vat-baggage-exo-and-kref-vref-rref-eref-name-space
---

§Channel: communication *pathway*. §Stream: §remote-async-
iterator implementing `@endo/stream`'s Reader interface.
§Channels-use-streams-for-message-passing.

§Endo-cycle-comparison: cycle 137's @endo/stream is the
shared substrate. §Common-substrate-different-name: ocap-
kernel calls its bidirectional pair a *channel*; @endo/
stream calls the unidirectional async-iterator a *stream*;
@endo/captp calls the bidirectional thing a *connection*.
§Vocabulary-drift-where-substrate-is-shared observation.
