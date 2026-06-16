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
title: §Gap-revealing-comparison with garden cycles
parent: metamask-ocap-kernel--docs-glossary-md--canonical-vocabulary-for-kernel-vat-baggage-exo-and-kref-vref-rref-eref-name-space
---

### §Synthesis-targets identified

| Glossary term | Synthesis-target observation |
|---------------|------------------------------|
| §exo (wraps Far) | Cycle 157's exo-zip-package design might benefit from §wrap-not-bypass framing |
| §endowment (attenuated) | Endo lacks a §named-attenuation-per-endowment discipline; OCPL (cycle 94) is the security framework |
| §three-independent-GC-systems | Cycle 156's §gc-as-side-channel warning extends to §three-domain multiplicity |
| §bootstrap-exactly-once | Cycle 119's `dp` could borrow §named-lifecycle-events |
| §bringOutYourDead | Cycle 156's WeakValueMap shape is the per-vat-liveslots equivalent |
| §kernel-promise-not-JS-promise | Endo's E() and HandledPromise live entirely on the JS side; no kernel-promise analog yet |
| §decider-reverts-on-rollback | Cycle 162's §revert-in-memory-state-too-not-just-the-database is the database-side analog |
| §kernel-router | Endo has no explicit named-router component |
| §rref-does-not-survive-the-channel | Endo's formula-identifier persists; the §scoped-lifetime axis is implicit |
| §clist (per-channel) | Cycle 156's WeakValueMap is per-CapTP-instance; explicit naming would help |
| §kernel-services-cannot-return-Exos | Endo's analog (host-side methods) doesn't yet name this constraint |

### §Adopt-vocabulary-not-implementation continuation

Cycle 162's §synthesis-target named §adopt-vocabulary-not-
implementation. This glossary supplies the candidate
vocabulary set:

**Tier-1 (high-value)**: kref, vref, rref, eref (the four-
layer name-space); crank (transactional unit); decider
(authorization target); baggage (durable KV per vat);
liveslots (the JS-to-durable bridge); bringOutYourDead (GC
sweep trigger).

**Tier-2 (medium-value)**: endowment (attenuated host APIs);
syscall (vat → kernel call); delivery (kernel → vat call);
subcluster (group of related vats); kernel-service (in-
kernel-context method).

**Tier-3 (already-share-or-redundant)**: vat, exo, channel,
stream, marshaling, garbage collection, revocation — Endo
already uses these (sometimes with the same meaning, often
with the same name).

§Tier-1-borrowing-would-add-clarity-not-collision: none of
these names collide with established Endo vocabulary.
