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
title: §Three-independent-GC-systems
parent: metamask-ocap-kernel--docs-glossary-md--canonical-vocabulary-for-kernel-vat-baggage-exo-and-kref-vref-rref-eref-name-space
---

> *The garbage collection systems of the kernel, liveslots,
> and javascript are all mutually independent.*

The §don't-conflate-GC-domains discipline — emphasized in
the source (Important: the garbage collection systems of the
kernel, liveslots, and javascript are all mutually
independent.).

§Three-GC-domains enumerated:

- **Kernel GC**: reference-count-based across vats; tracks
  cross-vat references via krefs; delivers GC actions
  (dropExports / retireExports / retireImports / bring-
  OutYourDead) to vats via the §delivery surface.
- **Liveslots GC**: per-vat; tracks JS-object-to-vref
  mappings; reacts to kernel GC actions; manages the §JS-
  object-to-durable-object boundary.
- **JavaScript GC**: V8 / SpiderMonkey runtime; classical
  mark-and-sweep + generational; entirely outside the
  kernel's control.

§GC-side-channel-surface-is-three-domains-wide: cycle 156's
§gc-as-side-channel warning takes on §three-domain
multiplicity here. The kernel can observe its own GC
actions; the kernel cannot observe liveslots' GC reactions
without being told; the kernel can never observe V8's
internal GC.

§Mutually-independent is load-bearing: it means *all three*
GC domains can advance asynchronously, and §determinism-
requires-explicit-coordination.
