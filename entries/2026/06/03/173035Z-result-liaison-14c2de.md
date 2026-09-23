---
kind: result
role: liaison
host: endolin
dispatch_root: /home/kris/garden/dispatches/liaison--14c2de
ts: 2026-06-03T17:30:35Z
ref_id: 14c2de
---

# Cycle 163: ocap-kernel docs/glossary.md (third ocap-kernel ingest; authoritative vocabulary surface)

Cycle 163 continues the §ocap-kernel-mini-series (cycles 161
/ 162 / 163). §Queued-doc-2 from cycle 161's plan:
`docs/glossary.md` (240 lines). This is the **§authoritative-
vocabulary-surface** that cycle 161's overview surveyed
partially and cycle 162's §synthesis-target §adopt-
vocabulary-not-implementation depends on.

## Source

`MetaMask/ocap-kernel docs/glossary.md` from the bare clone
at `/home/kris/garden/worktrees/metamask-ocap-kernel.git/`.
HEAD `a3eff0efb` 2026-05-28; file last-touched in same
commit. 240 lines. Dual Apache-2.0 + MIT.

## Sections written (1)

`metamask-ocap-kernel--docs-glossary-md--canonical-
vocabulary-for-kernel-vat-baggage-exo-and-kref-vref-rref-
eref-name-space.md` (489 lines; commit `43feac34`).

**§Cohesion-honest section count**: One section. §The-
glossary-is-one-vocabulary-surface; splitting would fragment
the four-layer name-space across multiple files and lose the
§each-entry-links-to-a-source-file structural observation.

## Why this is high-value

The glossary instantiates two observations from earlier
cycles:

1. Cycle 161's overview noted §canonical-vocabulary survey
   of 22 terms — partial, READMEs + AGENTS.md scraped.
2. Cycle 162's §synthesis-target §adopt-vocabulary-not-
   implementation needed a vocabulary set to draw from.

This doc is the *authoritative* source for both. 26 of 30
entries link directly to a `.ts` source file. §Every-term-
is-a-pointer-to-code; §runnable-glossary-not-frozen-prose.

## Structural moves captured

- **§Two-axis structure**: ## Concepts (26 named-concepts) +
  ## Abbreviations (5 typed short-form refs). §Naming-
  convention-as-organizing-principle. The abbreviations
  *are* the four-layer name-space (plus clist).
- **§kref-vref-rref-eref four-layer name-space** centerpiece
  with canonical definitions. §Rref-does-not-survive-the-
  channel (§scoped-lifetime; channels are §ephemeral-
  namespaces); §eref-is-the-union (§polymorphic-over-
  locality, §location-transparency-at-the-type-level).
  §Trade-off-named: four-layer vs Endo's one-layer formula-
  identifier.
- **§Clist as bidirectional channel-runtime mapping**:
  §per-channel not §global. Cycle 156's WeakValueMap is the
  per-CapTP-instance analog.
- **§Exo prescriptive**: *Do not use Far() from @endo/far*.
  §Forbid-direct-Far promoted from §contributor-norm to
  §canonical-doc. §Wrap-not-bypass; §wrap-gives-a-
  bottleneck-for-audit.
- **§Endowment as security-attenuation** (single most
  semantically rich entry): §callable-but-attenuated;
  §security-as-attenuation-not-removal; two named
  attenuations §per-vat-timer-queues (prevents §timer-as-
  side-channel) and §monotonically-clamped-Date.now()
  (prevents §clock-as-side-channel; §determinism-by-
  clamping).
- **§Three-independent-GC-systems** (kernel + liveslots +
  JavaScript mutually independent): §don't-conflate-GC-
  domains; §gc-side-channel-surface-is-three-domains-wide
  (cycle 156 multiplied).
- **§Six-delivery-types**: 2 business (message, notify) + 4
  GC (dropExports, retireExports, retireImports,
  bringOutYourDead). §bringOutYourDead is the §Monty-Python-
  named-syscall from Agoric SwingSet folklore.
- **§Bootstrap-called-exactly-once** lifecycle discipline:
  §bootstrap-is-not-resuscitation; §idempotence-by-
  construction-not-by-code; §synthesis-target §named-
  lifecycle-events.
- **§Crank-can-be-aborted-and-rolled-back**: §crank-as-
  transactional-unit; ties cycle 162's §savepoint-with-
  named-rollback-on-throw to the cranks generally.
- **§Decider-reverts-on-rollback**: §authorization-snapshot-
  restored-on-abort; sibling to cycle 162's §revert-in-
  memory-state-too-not-just-the-database. §Rollback-must-
  cover-non-database-state-too.
- **§Kernel-promise-not-JS-promise**: §two-promise-systems-
  with-translation-layer; §liveslots-as-the-promise-bridge.
- **§System-subcluster** §privilege-by-subcluster-
  declaration; §systemOnly-services as privilege boundary.
- **§Kernel-services-cannot-return-Exos** constraint;
  §architectural-asymmetry-between-vat-and-service.
- **§Channel-stream-distinction**: shared substrate
  (@endo/stream) with §vocabulary-drift across implementations.

## Gap-revealing comparison table

11 synthesis-targets identified across cycles 94 / 100 /
119 / 137 / 156 / 157 / 162. Detailed in the section.

## §Adopt-vocabulary-not-implementation tiering

- **Tier-1** (high-value, no Endo collision): kref, vref,
  rref, eref, crank, decider, baggage, liveslots,
  bringOutYourDead.
- **Tier-2**: endowment, syscall, delivery, subcluster,
  kernel-service.
- **Tier-3** (already-share-or-redundant): vat, exo,
  channel, stream, marshaling, garbage collection,
  revocation.

§Tier-1-borrowing-would-add-clarity-not-collision.
§Citation-discipline-when-borrowing — future Endo-side
designs adopting Ken or ocap-kernel terms should §cite-
the-origin.

## Files written / edited

- `library/sections/metamask-ocap-kernel--docs-glossary-md--
  canonical-vocabulary-for-kernel-vat-baggage-exo-and-kref-
  vref-rref-eref-name-space.md` (489 lines; commit
  `43feac34`)
- `library/sources/metamask-ocap-kernel--docs-glossary-md.md`
  (new source page)
- `library/sources/README.md` (cycle-163 row added under
  "External code repositories (sibling implementations)"
  above cycle-162 row)
- `library/sections/README.md` (cycle-163 entry; totals
  bumped 667/208 → 668/209)
- `library/topics/daemon.md` (cycle-163 row)
- `library/topics/captp.md` (cycle-163 row)
- `library/topics/capability-security.md` (cycle-163 row;
  the §endowment-as-security-attenuation moves justify
  capability-security cross-listing)
- `library/keywords.md` (75 new keyword rows)
- `inboxes/endolin/scholar.md` (timestamp + commit hash
  bumped manually)

## Library totals

667 / 208 → **668 sections from 209 source documents**.

## Lane rotation note

Cycle 163 was nominally papers-lane in the rotation;
papers-lane has been blocked **57+ consecutive cycles** due
to lack of PDF-fetching infrastructure. Pivoted gracefully
to comments-lane and continued the ocap-kernel queue.

The §ocap-kernel-mini-series now spans three cycles:
- Cycle 161: monorepo overview (user-directed; off-rotation)
- Cycle 162: ken-protocol-assessment.md (comments-lane)
- Cycle 163: glossary.md (comments-lane)

Remaining §queued-doc items from cycle 161's plan:
identity-backup-recovery.md, kernel-guide.md, platform-
specific.md, usage.md.

## Cycle 163 — done. Schedule cycle 164.
