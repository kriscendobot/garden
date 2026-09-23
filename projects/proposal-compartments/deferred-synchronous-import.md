# Deferred: synchronous import (follow-on proposal plan)

This plan records the maintainer decision to defer synchronous evaluation out of
the minimal Compartments surface, and lays out the follow-on proposal work the
decision calls for. It is a design deliverable that presents a choice; it does
not settle the choice alone. See the charter's "Both TLA and non-TLA evaluation
paths" item in [README.md](README.md).

## The decision

Maintainer @kriskowal, 2026-08-17 (in a liaison session), on the charter's open
question about a host-only synchronous evaluation operation:

> Defer synchronous import. That will likely take the shape of
> `compartment.importNow` and `import.now` (syntax). We should plan to create a
> separate proposal based on the compartment core proposal, or a pair of
> proposals that introduce synchronous import and then later reconcile with
> compartment synchronous import.

So the minimal Compartments surface keeps `Compartment.prototype.import`
asynchronous and adds no synchronous entry point. The anticipated future shape:

- **`compartment.importNow(key)`** — a synchronous method on a Compartment,
  parallel to the asynchronous `import`, returning a module namespace directly
  (rejected for graphs with top-level await).
- **`import.now(...)`** — a syntactic synchronous import form, parallel to the
  existing `import`/`import.source`/`import.defer` phase family, so a source can
  request a synchronous instance the way it requests a source-phase or deferred
  instance today.

Both are follow-on work, not part of this proposal.

## Why it is deferred, not dropped

Synchronous import is a real host requirement (Node's `require(esm)` path,
synchronous CommonJS interop, and any host that must produce a namespace without
yielding to the event loop). It is deferred rather than dropped because:

- The minimal surface stays minimal and asynchronous-only, which keeps the
  intersection-with-module-harmony story clean: this proposal layers on the
  existing async phase family and does not introduce a second, synchronous
  evaluation contract mid-stream.
- A synchronous import form is independently motivated outside Compartments (see
  below), so it is better carried by its own proposal that the Compartment work
  can then intersect with, exactly as this proposal intersects source-phase and
  import-defer today.

## The choice: one proposal, or a pair

The decision explicitly leaves the shape open. Present both; do not pick alone.

### Option A — one proposal, built on the Compartment core

A single follow-on proposal that introduces `compartment.importNow` and
`import.now` **as Compartment operations**, stacked on the Compartment core
proposal.

- **Staging:** one proposal to advance through the stages; no second artifact to
  keep in sync. Fastest path to a shippable synchronous Compartment method.
- **Committee sequencing:** it is strictly downstream of the Compartment core, so
  it cannot advance ahead of the core and inherits the core's fate. It reads as
  "Compartments, part two," which is easy for the committee to situate.
- **Cost:** it binds synchronous import to Compartments. If the committee wants a
  synchronous import form in the *base language* (outside Compartments), this
  shape does not offer it, and the two would have to be reconciled later anyway
  — reintroducing the pair, but after the fact and under time pressure.

### Option B — a pair, general first then reconciled

Two proposals:

1. **Synchronous import, generally** — `import.now` (and a synchronous dynamic
   `import.now(...)` form) in the base language, defined against ordinary module
   records, rejected for graphs with top-level await. No Compartment dependency.
2. **Compartment synchronous import** — reconciles the general synchronous form
   with Compartments: `compartment.importNow`, and how `import.now` resolves and
   evaluates across compartment links and the source-key instance map.

- **Staging:** the general proposal can advance on its own timeline; the
  reconciliation proposal stacks on both it and the Compartment core. More
  artifacts, more coordination.
- **Committee sequencing:** the general synchronous-import question gets debated
  on its own merits, not entangled with Compartments. If synchronous import is
  contentious, that debate does not stall the Compartment core; if it is
  uncontentious, it can land ahead of the reconciliation.
- **Cost:** two proposals to shepherd, and a reconciliation step that only makes
  sense once both predecessors are stable. The general proposal must be careful
  not to bake in assumptions that the Compartment reconciliation then has to
  undo.

### Is synchronous import independently motivated outside Compartments?

This is the hinge for choosing. If synchronous import is only ever wanted *for*
Compartments, Option A is the honest shape. If it is wanted in the base language
regardless of Compartments — and the Node `require(esm)` and synchronous-interop
demand suggests it is — then Option B matches the real dependency structure, and
Option A would only be deferring the pair, not avoiding it.

Preliminary lean: the evidence points to independent motivation (host demand for
synchronous namespace production predates and exceeds Compartments), which favors
**Option B**. But this is a committee-facing sequencing call, so it is presented
as a choice for the maintainer, not decided here.

## Hard constraint carried into any shape

Whatever shape is chosen, **dynamic loader registration is unsound** (maintainer
@kriskowal, 2026-08-17): there is a race between registering a loader and loading
that can corrupt cache keys already permanently committed. A synchronous import
form must not resolve by registering a loader into a live graph. See the "Standing
design constraints" section of [README.md](README.md).

## Next actions (when this is promoted)

1. Maintainer picks Option A or Option B (and, under B, whether the general
   proposal leads).
2. Draft an explainer for the chosen shape naming `compartment.importNow` and
   `import.now`, cross-referencing this proposal's source-key and instance-map
   semantics.
3. Only then scaffold a proposal repo / stage entry; this plan is upstream of any
   spec text.
