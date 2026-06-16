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
title: The kref-vref-rref-eref four-layer name-space (centerpiece)
parent: metamask-ocap-kernel--docs-glossary-md--canonical-vocabulary-for-kernel-vat-baggage-exo-and-kref-vref-rref-eref-name-space
---

The §kref-vref-rref-eref four-layer name-space identified in
cycle 161 as **the most distinctive divergence from Endo**
gets its canonical definitions here:

### §kref — kernel-scope reference

> *A KRef ... designates an Object within the scope of the
> Kernel itself. It is used in the translation of References
> between one Vat and another. A KRef is generated and
> assigned by the Kernel whenever an Object reference is
> imported into or exported from a Vat for the first time.*

§Kernel-globally-unique. §Generated-on-first-crossing.
§Kernel-scoped-name-for-cross-vat-routing.

### §vref — vat-scope reference

> *A VRef ... designates an Object within the scope of the
> Objects known to a particular Vat. It is used across the
> Kernel/Vat boundary in the marshaling of messages
> delivered into or sent by that Vat. A VRef is generated and
> assigned by the Kernel when importing an Object Reference
> into a Vat for the first time and by the Vat when exporting
> an Object Reference from it for the first time.*

§Vat-locally-unique. §Either-side-can-generate (kernel on
import; vat on export). §Used-at-Kernel-Vat-boundary.

### §rref — channel-scope reference

> *An RRef ... designates an object within the scope of an
> established point-to-point communications Channel between
> two Clusters. **An RRef does not survive the Channel it is
> associated with.** An RRef is generated when the Kernel for
> one Cluster exports an Object Reference into the Channel
> connecting it to another Cluster's Kernel.*

§Rref-does-not-survive-the-channel — the §scoped-lifetime
observation. Channels are §ephemeral-namespaces; if the
channel goes down, all rrefs through it are stale. The kref/
vref counterparts persist; rrefs do not. §Lifetime-tracks-
scope discipline.

### §eref — endpoint-reference union type

> *An ERef ... is a generic term for a ref which is either a
> vref or a rref.*

§Eref-is-the-union — the type used when code doesn't care
whether the endpoint is a local vat or a remote cluster.
§Polymorphic-over-locality; §location-transparency-at-the-
type-level.

### §Four-layer-scoping-is-the-divergence

Endo's CapTP layer conflates many of these into a flat
*formula-identifier* (cycle 145's formula-inspector.md is
the user-facing surface). The cycle 156 finalize.js comment
hints at slot-index-as-shared-name, but Endo's identifier
space is *one layer* (formulas), where ocap-kernel uses
*four layers* (kref/vref/rref/eref).

§Trade-off-named: more layers = more bookkeeping but
sharper §locality-information; fewer layers = simpler runtime
but locality must be reconstructed from context.
