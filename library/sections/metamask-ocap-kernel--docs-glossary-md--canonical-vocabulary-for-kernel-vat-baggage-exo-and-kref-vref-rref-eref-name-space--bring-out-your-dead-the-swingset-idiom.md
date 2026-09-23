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
title: §Bring-out-your-dead — the SwingSet idiom
parent: metamask-ocap-kernel--docs-glossary-md--canonical-vocabulary-for-kernel-vat-baggage-exo-and-kref-vref-rref-eref-name-space
---

The §deliveries-are-typed list:

> *Deliveries can be of type 'message', 'notify',
> 'dropExports', 'retireExports', 'retireImports', or
> 'bringOutYourDead'.*

§Six-delivery-types; §two-business-types (message, notify) +
§four-GC-types. §bringOutYourDead is the §sweep-trigger from
Agoric SwingSet — the kernel asks the vat to identify
objects it considers dead so the kernel can free its own
references. Famous as the §Monty-Python-named-syscall in the
SwingSet folklore (cycle 161 noted ocap-kernel preserves
SwingSet's terminology; this is one of the most distinctive
borrowings).

§Cycle-156's-finalize-js-WeakValueMap-gc-as-side-channel
warning manifests at this layer: liveslots responds to
bringOutYourDead by walking its WeakValueMap-equivalent and
reporting unreachable vrefs; the §determinism-invariant
must hold despite §V8's-internal-GC-timing-being-non-
deterministic.
