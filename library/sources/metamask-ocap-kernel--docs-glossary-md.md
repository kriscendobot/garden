---
source: docs/glossary.md
source_repo: MetaMask/ocap-kernel
source_url: https://github.com/MetaMask/ocap-kernel/blob/main/docs/glossary.md
source_branch: main
source_commit: a3eff0efb70ba5f4c5919290aa295fe32138df4f
source_date: (last touched in commit `a3eff0efb`)
source_authors: [MetaMask ocap-kernel team]
ingested: 2026-06-03
ingested_by: scholar
section_count: 1
status: current
notes: |
  Cycle 163. **Third ocap-kernel ingest** (cycles 161 / 162 /
  163 form an §ocap-kernel-mini-series). §Queued-doc-2 from
  the cycle 161 overview's §queued-for-future-cycles plan.

  §Authoritative-vocabulary-surface document — 240 lines,
  ~30 entries, two-axis structure (## Concepts + ##
  Abbreviations). The canonical reference both cycle 161's
  overview and cycle 162's Ken-protocol-assessment depend on
  for their term-level claims.

  §Each-entry-links-to-a-source-file: 26 of 30 entries cite
  a `.ts` file or method. §Verifiable-provenance-not-just-
  glossary; §every-term-is-a-pointer-to-code; §runnable-
  glossary-not-frozen-prose.

  §Two-axis structure observation:
  - ## Concepts — 26 named concepts (kernel, vat, baggage,
    bootstrap, cluster, exo, distributed object, kernel
    service, supervisor, endowment, liveslots, crank, syscall,
    delivery, marshaling, kernel promise, decider, promise
    resolution, garbage collection, revocation, channel,
    stream, subcluster, system subcluster, run queue, kernel
    router)
  - ## Abbreviations — 5 typed-short-form refs (clist, eref,
    kref, rref, vref)

  §Naming-convention-as-organizing-principle. The
  abbreviations are *all* the four-layer name-space terms
  plus clist as the bidirectional mapping mechanism;
  capitalized abbreviation expansions, short ASCII forms in
  code.

  Centerpiece: §kref-vref-rref-eref four-layer name-space —
  identified in cycle 161 as the most distinctive divergence
  from Endo. Canonical definitions captured. §Rref-does-not-
  survive-the-channel is the §scoped-lifetime observation;
  channels are §ephemeral-namespaces. §Eref-is-the-union
  type used when code doesn't care about locality.

  §Trade-off-named: four-layer scoping = more bookkeeping
  but sharper §locality-information; Endo's one-layer
  formula-identifier = simpler runtime, locality
  reconstructed from context.

  §Clist-is-the-boundary-translator: bidirectional mapping
  between short channel-specific identifiers and JS object
  references. §Per-channel-mapping not §global. Cycle 156's
  finalize.js WeakValueMap is the per-CapTP-instance analog
  (Endo's CapTP slot table).

  §Exo-as-canonical-remotable: the glossary itself is
  prescriptive — *Do not use Far() from @endo/far*. §Forbid-
  direct-Far reaffirmed; §wrap-not-bypass discipline;
  §makeDefaultExo-is-the-only-blessed-remotable-constructor
  promoted from §contributor-norm to §canonical-doc.

  §Endowment-as-security-attenuation entry is the most
  semantically rich. §Callable-but-attenuated; §security-as-
  attenuation-not-removal; §preserve-shape-mutate-semantics.
  Two named attenuations: §per-vat-timer-queues (prevents
  §timer-as-side-channel) and §monotonically-clamped-Date.
  now() (prevents §clock-as-side-channel). §Capability-
  shape-discipline-applied-to-host-endowments.

  §Three-independent-GC-systems: §don't-conflate-GC-domains.
  Kernel GC (across vats; reference-count; via deliveries),
  liveslots GC (per-vat; JS-to-vref mapping), JavaScript GC
  (V8/SpiderMonkey; mark-and-sweep). §GC-side-channel-
  surface-is-three-domains-wide — cycle 156's §gc-as-side-
  channel takes on §three-domain multiplicity.

  §Six-delivery-types: §two-business-types (message, notify)
  + §four-GC-types (dropExports, retireExports,
  retireImports, bringOutYourDead). §bringOutYourDead is the
  §Monty-Python-named-syscall from Agoric SwingSet folklore —
  cycle 161 noted ocap-kernel preserves SwingSet terminology;
  this is one of the most distinctive borrowings.

  §Bootstrap-called-exactly-once: §lifecycle-discipline-
  named. §Bootstrap-is-not-resuscitation. §Synthesis-target
  candidate: §named-lifecycle-events for Endo (cycle 119's
  `dp` design lacks this distinction).

  §Crank-can-be-aborted-and-rolled-back: §crank-as-
  transactional-unit. Cycle 162's §savepoint-with-named-
  rollback-on-throw is the receive-side instance; this entry
  confirms cranks generally are §rollback-capable.

  §Decider-reverts-on-rollback: §authorization-snapshot-
  restored-on-abort discipline. Cycle 162's §revert-in-
  memory-state-too-not-just-the-database has a sibling
  here — §rollback-must-cover-non-database-state-too.

  §Kernel-promise-not-JS-promise: §two-promise-systems-
  with-translation-layer. §Liveslots-as-the-promise-bridge.
  §Kernel-promise-survives-vat-restarts; §JS-promise-does-
  not.

  §Tier-1 vocabulary borrowing candidates: kref, vref, rref,
  eref, crank, decider, baggage, liveslots, bringOutYourDead.
  §Tier-2: endowment, syscall, delivery, subcluster, kernel-
  service. §Tier-3 (already-share-or-redundant): vat, exo,
  channel, stream, marshaling, garbage collection,
  revocation.

  §Tier-1-borrowing-would-add-clarity-not-collision: none of
  the high-value names collide with established Endo
  vocabulary.

  §Citation-discipline-when-borrowing: future Endo-side
  designs adopting Ken or ocap-kernel terms should §cite-
  the-origin. §Reference-not-substrate stance from cycle 161
  extends to §vocabulary-borrowing-without-code-borrowing.

  Cycle 163 is comments-lane. Papers-lane blocked 57+
  consecutive cycles.
---

> Abstract: `docs/glossary.md` (240 lines) is the **§authoritative-vocabulary-surface** document — ~30 entries
> across two top-level axes (## Concepts + ## Abbreviations);
> 26 of 30 entries link directly to a `.ts` source file.
>
> **Third ocap-kernel ingest** after cycle 161's overview and
> cycle 162's Ken-protocol-assessment; §queued-doc-2 from
> cycle 161's plan.
>
> §Each-entry-links-to-a-source-file (§verifiable-provenance-
> not-just-glossary; §runnable-glossary). §Naming-convention-
> as-organizing-principle: abbreviations isolate the four-
> layer name-space.
>
> **Centerpiece**: §kref-vref-rref-eref four-layer name-space
> identified in cycle 161 as the most distinctive divergence
> from Endo; canonical definitions captured. §Rref-does-not-
> survive-the-channel; §eref-is-the-union; §clist-is-the-
> boundary-translator.
>
> §Exo prescriptive (*Do not use Far() from @endo/far*);
> §forbid-direct-Far promoted from §contributor-norm to
> §canonical-doc.
>
> §Endowment as the §callable-but-attenuated surface;
> §security-as-attenuation. Two named attenuations:
> §per-vat-timer-queues and §monotonically-clamped-Date.now().
>
> §Three-independent-GC-systems; §don't-conflate-GC-domains;
> §gc-side-channel-surface-is-three-domains-wide.
>
> §bringOutYourDead syscall — §Monty-Python-named-syscall
> from SwingSet folklore.
>
> §Tier-1 vocabulary borrowing candidates identified for
> §adopt-vocabulary-not-implementation (cycle 162's
> synthesis target): kref, vref, rref, eref, crank, decider,
> baggage, liveslots, bringOutYourDead.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [canonical-vocabulary-for-kernel-vat-baggage-exo-and-kref-vref-rref-eref-name-space](../sections/metamask-ocap-kernel--docs-glossary-md--canonical-vocabulary-for-kernel-vat-baggage-exo-and-kref-vref-rref-eref-name-space.md) | daemon, captp, capability-security | current |

One cohesion-honest section. §Authoritative-vocabulary-
surface as the unifying property; splitting would fragment
the four-layer name-space across multiple sections.

## Provenance

- Fetched 2026-06-03 from `MetaMask/ocap-kernel@a3eff0efb`
  (file last touched in same commit on `main`).
- License: dual Apache-2.0 + MIT.
- **Third ocap-kernel ingest** after cycle 161's overview
  and cycle 162's Ken-protocol-assessment. §Queued-doc-2
  from cycle 161 overview's plan.
- Cycle 163 was nominally **comments-lane** (continuing the
  §ocap-kernel-mini-series). Papers-lane has been blocked
  for **57+ consecutive cycles**.
- One cohesion-honest section.
