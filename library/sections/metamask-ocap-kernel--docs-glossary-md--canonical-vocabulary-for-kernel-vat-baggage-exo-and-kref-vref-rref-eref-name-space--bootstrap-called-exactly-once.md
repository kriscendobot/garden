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
title: §Bootstrap-called-exactly-once
parent: metamask-ocap-kernel--docs-glossary-md--canonical-vocabulary-for-kernel-vat-baggage-exo-and-kref-vref-rref-eref-name-space
---

> *The bootstrap method ... is called exactly once — it is
> not called again after a vat restart.*

§Lifecycle-discipline-named: §bootstrap-is-not-resuscitation.
Restart restores baggage; bootstrap remains unrun (because
the bootstrap argument graph was set up at first-launch).
§Idempotence-by-construction-not-by-code: the vat doesn't
have to be idempotent because bootstrap is never re-invoked.

§Endo-doesn't-yet-have-this-named: cycle 119's `dp` design
sketches partition-and-revival but doesn't name a §lifecycle-
event-called-exactly-once-vs-on-resuscitation distinction.
§Synthesis-target candidate: §named-lifecycle-events.
