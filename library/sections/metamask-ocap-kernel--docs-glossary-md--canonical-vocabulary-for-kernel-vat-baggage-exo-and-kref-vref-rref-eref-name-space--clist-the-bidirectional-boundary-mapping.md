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
title: §Clist — the bidirectional boundary mapping
parent: metamask-ocap-kernel--docs-glossary-md--canonical-vocabulary-for-kernel-vat-baggage-exo-and-kref-vref-rref-eref-name-space
---

> *A clist (short for "capability list") is a bidirectional
> mapping between short, channel-specific identifiers and
> actual object references. The clist is unique to a
> channel-runtime pair, and translates between the javascript
> runtime which holds the object references and the channel
> which communicates about them.*

§Clist-is-the-boundary-translator — the §kref-rref-or-vref-
to-Object-reference dictionary. *Unique to a channel-
runtime pair*: §per-channel-mapping, not §global. §Cycle-
156's-finalize-js-weak-value-map is the per-CapTP-instance
analog (Endo's CapTP slot table); ocap-kernel names this
explicitly and per-channel.

§Bidirectional discipline: short identifier ↔ JS object
reference; both directions are required because messages
flow both ways.
