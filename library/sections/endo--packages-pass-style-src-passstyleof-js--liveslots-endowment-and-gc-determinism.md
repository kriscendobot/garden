---
title: PassStyleOfEndowmentSymbol — liveslot delegation, the "host has write access to our global" gate, and the GC-determinism hazard
source: packages/pass-style/src/passStyleOf.js
source_kind: comment-fragment
source_repo: endojs/endo
source_path: packages/pass-style/src/passStyleOf.js
source_line_range: "219-245"
source_commit: e56bf00f289ff8484094b785b11636b8bc71d87e
comment_subject: "Why pass-style exports the globalThis-installed passStyleOf when present (liveslots delegation), how the install-on-global gate stands in for explicit authorization, and the GC-detection hazard the delegated implementation must preserve determinism to avoid"
ingested: 2026-05-28
ingested_by: scholar
topics: [pass-style, marshal, capability-security, persistence]
status: current
---

## Abstract

The pass-style package exports `passStyleOf` with a small but
load-bearing twist: if a `Symbol.for('@endo passStyleOf')` property
is already on `globalThis` at module-init time, the package uses
*that* function as its exported `passStyleOf` instead of
constructing its own. The longform comment surrounding the
`PassStyleOfEndowmentSymbol` export and the conditional export is
the canonical source for three claims the construct rests on:
(1) liveslots (the Agoric SwingSet vat host) needs to swap in a
*virtualization-aware* `passStyleOf` so that Far-virtualized
objects from durable stores classify correctly; (2) the
**install-on-global gate is the authorization check** — any caller
that can install the symbol property on the start-compartment
global is already trusted at the same level as liveslots (write
access to the start compartment is roughly equivalent to being
liveslots); and (3) **a delegated implementation MUST preserve
the determinism of `passStyleOf`**, because otherwise a liveslot-like
virtualized environment exposes a *garbage-collection detector* to
any guest that can ask "what is the pass-style of this value?" and
observe a different answer depending on whether the host has
swept some intermediate state.

## The comment as written

Lines 221-235 in the captured commit, on the
`PassStyleOfEndowmentSymbol`-conditioned export of `passStyleOf`:

> If there is already a PassStyleOfEndowmentSymbol property on the
> global, then presumably it was endowed for us by liveslots with
> a `passStyleOf` function, so we should use and export that one
> instead.
> Other software may have left it for us here, but it would
> require write access to our global, or the ability to provide
> endowments to our global, both of which seems adequate as a
> test of whether it is authorized to serve the same role as
> liveslots.
>
> NOTE HAZARD: This use by liveslots does rely on `passStyleOf`
> being deterministic. If it is not, then in a liveslot-like
> virtualized environment, it can be used to detect GC.

The corresponding code:

```js
export const PassStyleOfEndowmentSymbol = Symbol.for('@endo passStyleOf');

export const passStyleOf =
  (globalThis && globalThis[PassStyleOfEndowmentSymbol]) ||
  makePassStyleOf([
    CopyArrayHelper,
    ByteArrayHelper,
    CopyRecordHelper,
    TaggedHelper,
    ErrorHelper,
    RemotableHelper,
  ]);
```

## Why liveslots needs to swap in its own implementation

In a SwingSet vat under liveslots, durable storage holds objects
*virtually*: a remote reference may be represented as a slot index
during persistence and rehydrated to a JavaScript object on
access. The pass-style package's default `passStyleOf` walks the
JavaScript object's properties to classify it; on a Far-virtualized
object whose JS representation is a thin wrapper hiding the real
durable identity, the default walk classifies based on the wrapper's
properties, not the durable identity's.

The liveslots-supplied `passStyleOf` is virtualization-aware: it
consults the live-slot table to recover the underlying kind
(remotable vs copyArray vs copyRecord vs ...) and returns the
classification that the durable state intends. This is what lets
marshal serialize values *out of* a vat's durable store correctly:
the wire format reflects the durable identity, not the in-realm JS
representation.

The Endo / Agoric reuse pattern is to share one implementation of
each pass-style-touching algorithm across both the durable-store
and the realm-only world, by substituting the classifier at the
boundary. The substitution point is this `PassStyleOfEndowmentSymbol`
export.

## The install-on-global gate as authorization

The comment names the gate explicitly: *any* party that can install
a `PassStyleOfEndowmentSymbol` property on the start-compartment
global is already trusted at the level liveslots is trusted at,
because installing a property on the start compartment global
requires either (a) write access to that global or (b) the ability
to provide endowments at compartment construction. Both are
abilities liveslots already has by construction; both are the
*minimum* abilities any other actor would need to substitute a
classifier; therefore the gate stands in for the authorization
check.

This is a worked example of the **authority-by-substrate**
discipline: rather than checking a permission token at the
delegation point, the discipline arranges for the substrate to
*only* grant the necessary primitive to authorized parties. A
caller that lacks write access to the start compartment global
cannot install the symbol property at all, so no check beyond
"is the property present" is needed. The check is *implicit* in
the substrate's authority structure.

## The GC-determinism hazard

The hazard the second paragraph names is subtle. `passStyleOf` is
called from many places, often as a guard (`assertPassable`,
`isPassable`, marshal's per-element classification). If a
liveslot-supplied `passStyleOf` is non-deterministic — if it can
return different classifications for the same value at different
times — then a guest program can use the *change* in classification
as an oracle for events the host did not intend to expose. The
canonical such event is **garbage collection**: a virtualized
reference whose backing slot has been swept and reconstituted may
be classified differently than one whose slot is still live. If
the guest sees `passStyleOf(x) === 'remotable'` at time T1 and
`passStyleOf(x) === 'tagged'` at time T2, the change is
information about the host's GC schedule.

GC-detection is a known covert-channel hazard in capability-secure
runtimes. It is most consequential for *information-flow* security:
two parties that share access to a virtualized reference can use
the host's GC to communicate without either party having an
explicit channel. The pass-style package's defense is therefore
not to *prevent* the channel (which would require liveslots to
buffer state across GC, an unacceptable cost) but to **require
the delegated classifier to be deterministic**. The hazard note
makes the requirement explicit so liveslots authors know to
preserve it.

## How the hazard interacts with the memo

The default `passStyleOf` returned by `makePassStyleOf` is the one
documented in [`endo--packages-pass-style-src-passstyleof-js--passstylememo-as-mutable-static-state`](endo--packages-pass-style-src-passstyleof-js--passstylememo-as-mutable-static-state.md):
it carries a `passStyleMemo` `WeakMap` cache. A delegated
liveslots `passStyleOf` may or may not carry its own cache. The
determinism requirement is *separate* from the caching question:

- A non-caching deterministic classifier returns the same answer
  on repeated calls because its classification function is pure.
- A caching deterministic classifier returns the same answer
  *because* it remembered the first answer. The cache is a
  determinism mechanism rather than a hazard.
- A non-deterministic classifier (caching or not) leaks the
  determining state. The hazard.

The TODO on `passStyleMemo` (the static-channel question from the
sibling section) and this hazard on the delegated classifier are
*aligned*: both ask whether the classifier's observable behavior
is over-narrow relative to the input value. The pass-style
package's discipline is to make the classifier *purely a function
of the input value's properties*, and to require any substitute
classifier to honor the same discipline.

## Implications

- **Liveslots authors must preserve determinism even across GC.**
  A liveslot-supplied `passStyleOf` that re-classifies a reference
  after a sweep must return the same answer it would have returned
  before the sweep. The implementation is non-trivial: durable
  state may not survive GC verbatim, so the classifier must
  reconstitute enough to answer consistently.
- **Code paths that observe `passStyleOf` results are observing a
  contract.** Any code that branches on `passStyleOf(x)` and stores
  the result for later use is relying on the deterministic-classifier
  invariant. A future change to the classifier's contract (e.g.,
  permitting non-determinism in exchange for performance) would
  break the GC-detection-resistance argument; the change would
  need explicit security review.
- **The `Symbol.for('@endo passStyleOf')` name is a registry
  contract.** Two packages installing classifiers under the same
  symbol would collide; the name is therefore part of pass-style's
  ABI in the same way the wire format is. Any alternative
  virtualization layer (e.g., a non-SwingSet host that needs
  pass-style virtualization) must use the same symbol and accept
  the determinism requirement.
- **The delegation mechanism is the canonical example of
  authority-by-substrate in the Endo codebase.** Other authority
  delegations (the bare-module endowment pattern, the global
  Symbol registry usage for shim coordination) follow the same
  shape. Reviewers of new delegation points can cite this comment
  as precedent.

## See also

- [[principle-of-least-authority]] — the install-on-global gate
  enacts POLA at the delegation boundary: the only party with the
  authority to substitute is the one already holding the
  substrate-level authority that a substitute would imply.
- [[four-ways-to-acquire-references]] — Endowment (the third of the
  four mechanisms) is what installs the
  `PassStyleOfEndowmentSymbol` property; the substitution mechanism
  is therefore an Endowment-shaped authority transfer rather than
  Introduction or Parenthood.
- [[object-capability]] — Property A (No Designation Without
  Authority) is what the gate enacts: any party that can designate
  the symbol property on the global also has the authority to
  install a classifier under it. The two are the same fact.
- [`endo--packages-pass-style-src-passstyleof-js--passstylememo-as-mutable-static-state`](endo--packages-pass-style-src-passstyleof-js--passstylememo-as-mutable-static-state.md)
  — the sibling section on the realm-default classifier's memo;
  both sections together cover the pass-style package's two
  distinct hazard surfaces.

Source: [packages/pass-style/src/passStyleOf.js](https://github.com/endojs/endo/blob/e56bf00f289ff8484094b785b11636b8bc71d87e/packages/pass-style/src/passStyleOf.js#L219-L245) at commit `e56bf00f`.
