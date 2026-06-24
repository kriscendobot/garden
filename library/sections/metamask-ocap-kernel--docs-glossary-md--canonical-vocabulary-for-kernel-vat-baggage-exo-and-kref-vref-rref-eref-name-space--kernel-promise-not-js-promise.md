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
title: §Kernel-promise-not-JS-promise
parent: metamask-ocap-kernel--docs-glossary-md--canonical-vocabulary-for-kernel-vat-baggage-exo-and-kref-vref-rref-eref-name-space
---

> *Kernel promises are distinct from JavaScript promises.
> Vat code works with JS promises and `E()` calls; liveslots
> translates between the vat's JS promises and kernel promise
> IDs (krefs) via syscalls.*

§Two-promise-systems-with-translation-layer. §Liveslots-as-
the-promise-bridge. §Kernel-promise-survives-vat-restarts
(persistent record in the kernel store); §JS-promise-does-
not-survive-(GC'd-on-vat-restart).

§Cycle-152's-memo-race.js (the racing-promise utility from
@endo/promise-kit) lives entirely on the §JS-promise side;
§kernel-promise-is-a-distinct-concept-with-its-own-
state-machine.

§Bridging-via-subscription-callback (cited in the glossary):
*Kernel-space code may create both a kernel promise (for
routing) and a JS promise (for the caller to await), bridged
by a subscription callback.* §Two-systems-bridged-by-
callback discipline.
