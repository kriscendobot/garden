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
---

# Canonical vocabulary for kernel / vat / baggage / exo and the kref-vref-rref-eref name-space

> §Sibling-implementation-comparison genre (third ingest;
> cycles 161 / 162 / 163 form an §ocap-kernel-mini-series).
> Cycle 161 surveyed §canonical-vocabulary from README +
> AGENTS.md; cycle 162 caught the §completion-claim-against-
> named-protocol audit; this cycle ingests the *authoritative*
> vocabulary surface. §Synthesis-target §adopt-vocabulary-not-
> implementation (cycle 162) is grounded here.

`docs/glossary.md` is a **§authoritative-vocabulary-surface**
document — 240 lines, ~30 entries, two-axis structure (##
Concepts + ## Abbreviations), each entry citing the *source-
of-truth implementation file*. The doc is the canonical
reference both cycle 161's overview and cycle 162's Ken-
protocol-assessment depend on for their term-level claims.

§Each-entry-points-at-implementation-file discipline (cycle
162's §each-property-points-at-a-named-implementation-
artifact is the per-protocol-property analog). Twenty-six of
the thirty entries link directly to a `.ts` source file or a
method. §Verifiable-provenance-not-just-glossary; §every-
term-is-a-pointer-to-code.

## Two-axis structure

### §Concepts-vs-Abbreviations split

Two top-level sections by *naming convention*, not by
*subject matter*:

- **## Concepts** — 26 named-concept entries (kernel, vat,
  baggage, bootstrap, cluster, exo, distributed object,
  kernel service, supervisor, endowment, liveslots, crank,
  syscall, delivery, marshaling, kernel promise, decider,
  promise resolution, garbage collection, revocation,
  channel, stream, subcluster, system subcluster, run queue,
  kernel router).
- **## Abbreviations** — 5 typed-short-form refs (clist,
  eref, kref, rref, vref).

§Naming-convention-as-organizing-principle. The
abbreviations are *all* the four-layer name-space terms
(plus clist as the bidirectional mapping mechanism); the
concepts are everything else.

This is a useful structural move: it sets the kref-vref-rref-
eref name-space off as a *typed sub-vocabulary* — a
distinguishable surface that compilers, type-checkers, and
human readers can identify on sight (capital letters in
abbreviation expansions, short ASCII forms in code).

## The kref-vref-rref-eref four-layer name-space (centerpiece)

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

## §Clist — the bidirectional boundary mapping

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

## §Exo — the canonical remotable

> *A remotable object created with `makeDefaultExo()` from
> `@metamask/kernel-utils/exo`. Exos are the standard way to
> create objects that can be passed between vats, stored in
> baggage, and invoked via `E()`. Do not use `Far()` from
> `@endo/far`.*

§Forbid-direct-Far concretized: the glossary itself is
prescriptive — *Do not use Far() from @endo/far*. §Wrap-not-
bypass discipline. §Makedefaultexo-is-the-only-blessed-
remotable-constructor (cycle 161 surfaced this from
AGENTS.md; the glossary confirms it as canonical, not just a
contributor-norm).

§Why-wrap-not-import: §exo-internalizes-kernel-utils-
conventions (durable-by-default, baggage-aware, error-
message-discipline). §wrap-gives-a-place-to-attach-future-
discipline; §wrap-gives-a-bottleneck-for-audit.

## §Endowment — security-as-attenuation

> *A host/Web API value — `setTimeout`, `Date`, `crypto`,
> `URL`, etc. — that is installed in a vat's SES Compartment
> at initialization. Compartments do not expose these APIs by
> default; vats request them by name via the `globals` field
> in their `VatConfig`. **Many endowments are _attenuated_
> for security or isolation (e.g., per-vat timer queues so
> one vat cannot clear another's timers, monotonically-
> clamped `Date.now()`) — they are callable but deliberately
> differ from host semantics.***

The single most semantically rich entry. §Callable-but-
attenuated stance: the surface looks like the host API; the
*behavior* deliberately differs. §Security-as-attenuation-
not-removal; §preserve-shape-mutate-semantics discipline.

Two named attenuations:

- §Per-vat-timer-queues: prevents §timer-cancellation-as-
  cross-vat-side-channel. Cycle 156's §gc-as-side-channel
  warning has a §timer-as-side-channel sibling here.
- §Monotonically-clamped-Date.now(): prevents §clock-as-
  side-channel; monotonicity rules out §non-determinism-by-
  rewinding-clock and §non-determinism-by-skipping-forward
  (depending on the clamping discipline). §Determinism-by-
  clamping observation; analog of cycle 100's deterministic-
  replay invariants.

§Compartments-expose-nothing-by-default: §explicit-globals-
via-VatConfig. §Capability-shape-discipline-applied-to-host-
endowments — the host APIs are themselves treated as
capabilities to be granted, not as ambient authority.

§Reference-to-other-glossary-entry: links to *Vat Endowments*
in kernel-guide.md (§queued-for-future-cycles doc-2).

## §Three-independent-GC-systems

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

## §Bring-out-your-dead — the SwingSet idiom

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

## §Bootstrap-called-exactly-once

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

## §Crank-can-be-aborted-and-rolled-back

> *Cranks can be aborted and rolled back if errors occur.*

§Crank-as-transactional-unit. Cycle 162's §savepoint-with-
named-rollback-on-throw is the receive-side instance; this
glossary entry confirms cranks generally are §rollback-
capable. The §atomic-checkpoint-includes-output-queue
invariant (cycle 162) extends: cranks themselves are
atomic-or-not, and the kernel guarantees §all-or-nothing
crank execution.

## §Decider-reverts-on-rollback

> *After crank rollback, the decider reverts to its pre-
> delivery value, which matters for error handling (e.g.,
> rejecting the kernel promise of a message sent to a
> terminated vat).*

§Decider-as-authorization-target — only the §decider can
settle a kernel promise; the decider authority is §rollback-
aware. §Authorization-snapshot-restored-on-abort discipline.
§Rollback-restores-decider-too — not just the database state.

§Cycle-162's-revert-in-memory-state-too-not-just-the-
database has a sibling here: §revert-the-authorization-
target-too. Both are instances of §rollback-must-cover-
non-database-state-too.

§Concrete-motivating-example-given: rejecting the kernel
promise of a message sent to a terminated vat. §When-the-
decider-vat-dies-mid-delivery, the kernel needs to know
which authority to invoke to reject the promise; that
authority must be the *pre-delivery* decider, not the just-
attempted-and-failed decider.

## §Kernel-promise-not-JS-promise

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

## §System-subcluster — privilege boundary

> *A subcluster declared at kernel initialization that can
> access privileged (`systemOnly`) kernel services. System
> subclusters persist across kernel restarts and are
> identified by a unique name.*

§Privilege-by-subcluster-declaration: §systemOnly-services
are gated by §subcluster-identity. §Identity-survives-restart
(unique name; reachable across restarts).

§Capability-security-applied-to-kernel-services: §kernel-
service-as-the-authority-bottleneck (cycle 161's overview
noted this from README); the glossary clarifies §systemOnly
as the privilege axis, *not* a permission system on
individual operations.

## §Kernel-services-cannot-return-Exos

> *Because service implementations do not participate in the
> kernel's reference management, they cannot return exos.
> Services marked `systemOnly` can only be accessed by
> system subclusters.*

§Constraint-named: §kernel-services-return-pass-style-data-
only-no-remotables. §Reference-management-is-the-vat-runtime-
not-the-service-context. §Architectural-asymmetry-between-
vat-and-service.

§Why-services-cannot-be-exos: services run in the kernel's
own context, not in a vat; they have no liveslots; they have
no §clist; they have no §kref-vref translation. Returning a
remotable would require all of these.

§Cycle-156's-finalize-js distinction is parallel: the kernel
context has different §rules for what it can return.

## §Endowments-as-the-only-host-API-access

§Compartments-don't-expose-host-APIs-by-default + §vats-
request-by-name-via-globals-field-in-VatConfig + §endowments-
are-attenuated.

This is the §three-layered host-API-access pattern:

1. **Default**: nothing exposed.
2. **Request**: VatConfig declares which globals.
3. **Receive**: attenuated implementations.

§Capability-discipline-applied-to-hostAPI-access — the
maximum-discoverability-of-host-power requires §explicit-
opt-in, §named-attenuation, and §security-or-isolation-
motivation per endowment.

## §Channel-stream-distinction

§Channel: communication *pathway*. §Stream: §remote-async-
iterator implementing `@endo/stream`'s Reader interface.
§Channels-use-streams-for-message-passing.

§Endo-cycle-comparison: cycle 137's @endo/stream is the
shared substrate. §Common-substrate-different-name: ocap-
kernel calls its bidirectional pair a *channel*; @endo/
stream calls the unidirectional async-iterator a *stream*;
@endo/captp calls the bidirectional thing a *connection*.
§Vocabulary-drift-where-substrate-is-shared observation.

## §Gap-revealing-comparison with garden cycles

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

## §Reference-not-substrate stance (continued)

§Vocabulary-borrowing-without-code-borrowing is the §safe-
synthesis posture: read the glossary, lift the names that
carve useful distinctions, leave the implementations alone.
§Don't-import-ocap-kernel-into-Endo; §do-use-its-vocabulary-
when-writing-Endo-designs.

§Citation-discipline-when-borrowing: future Endo-side designs
that adopt a Ken or ocap-kernel term should §cite-the-origin
in the design body or commit message — §where-the-vocabulary-
came-from-is-load-bearing-for-readers.

## §Provenance discipline of the glossary itself

§Every-entry-links-to-a-source-file: of 30 entries, 26 link
to a `.ts` file or method; the remaining 4 (the
abbreviations) are pure name-space definitions with no
source-file citation needed.

§This-is-not-a-marketing-glossary; §this-is-a-runnable-
glossary — every concept points at its implementation.
§Glossary-as-living-documentation-not-frozen-prose.

§Comparison-with-Endo-glossary-attempt: Endo has scattered
glossary-fragments across multiple READMEs and design docs;
no single canonical surface. §Centralized-glossary-as-
artifact-shape is itself a synthesis target.
