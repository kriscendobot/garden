---
gate: deferred
priority: normal
role: researcher
posted_by: liaison
posted_at: 2026-07-28T07:46:28Z
---

# Investigate the Bejar-Hofman Box: reachable-only-from-roots monitoring

Maintainer directive (kriskowal, 2026-07-28, via the liaison on
`endolin-garden-ece02cb4`): investigate *"an API analogous to FinalizationRegistry
to be called a Bejar-Hofman Box (our coinage, no references online) that can be
used to break cycles in distributed retention graphs, by monitoring whether an
object or objects are reachable only from specified roots, where the ingress and
egress references are both mutable at runtime."*

**Research and proposal only. Write no implementation in this job.** The output is
findings plus a filed issue.

## On the name

**"Bejar-Hofman Box" is our own coinage and has no online references.** Do not go
looking for prior art under that name, do not cite a source for it, and do not let
a search engine or a model's recall invent one. If you find something that appears
to match the name, treat it as a false positive and say so. Prior art for the
*mechanism* is worth finding and is asked for below; prior art for the *name* does
not exist.

## The problem

Distributed object graphs retain each other across vats. A cycle that spans two or
more parties is not collectible by either side alone, because each end sees a live
inbound reference from the other. Local garbage collection cannot see through the
network seam, so the cycle leaks. Breaking such cycles is the motivating use case.

The proposed primitive: a box that watches an object, or a set of objects, and
reports when that object is **reachable only from a specified set of roots**. Not
"is it dead" (that is `FinalizationRegistry`), but "is everything still holding it
inside the region I named". When the answer becomes yes, the holder learns the
outside world has let go, and can drop the internal edge that closes the cycle.

The hard part the maintainer named explicitly: **both the ingress and the egress
references are mutable at runtime.** The set of edges into the watched region and
out of it changes while the box is armed, so the predicate is not evaluated once
against a frozen graph. Whatever is proposed has to stay sound under mutation.

## Deliver

1. **Precise semantics.** State exactly what is being asserted, in language that
   survives contact with a garbage collector. "Reachable only from these roots"
   needs to say: reachable by what kind of reference (strong, weak, ephemeron),
   observed at what moment, and with what liveness guarantee afterward, given that
   the answer can be invalidated by a mutation the instant after it is computed.
   Say whether the notification is a one-shot edge trigger or a level that can
   toggle back.
2. **Relation to what exists.** Compare against `WeakRef`, `FinalizationRegistry`,
   ephemerons and `WeakMap`, and reference counting with cycle collection (the
   trial-deletion and back-tracing families). Say specifically what
   `FinalizationRegistry` cannot express here and why the analogy holds only
   partway. Cover distributed GC prior art honestly, including why distributed
   reference counting alone does not collect cross-vat cycles, and what the
   published approaches (distributed trial deletion, back-tracing, migration into
   one space, leases and timeouts) cost.
3. **What the runtime must expose.** To answer "reachable only from these roots"
   you need something the JS heap does not currently offer a program. Say what:
   a partial trace, a barrier, a snapshot, an incremental maintained invariant.
   Estimate the cost, and say whether it is plausible in `endor-vm` specifically,
   given what the port has built so far, and separately in XS as it stands. An
   answer of "this needs engine support that does not exist" is a legitimate and
   useful finding.
4. **The ocap and security analysis, and treat this as first-class.** Observable
   reachability is a communication channel. `FinalizationRegistry` is already
   carefully constrained in SES for exactly this reason, and a predicate over the
   reference graph is strictly more informative than a death notification. Work
   out what an attacker learns by arming a box and watching it, whether it can be
   used to probe for the existence of references held by parties who never granted
   anything, whether it breaks the "no observable GC" discipline the platform
   depends on, and what constraints (which parties may arm a box, over which
   objects, with what timing granularity) would make it safe. If it cannot be made
   safe under ocap rules, say that clearly. That is a real result.
5. **The distributed extension.** How the box behaves when the roots and the
   watched objects live in different vats over CapTP, what messages it implies on
   the wire, and how it degrades under partition, restart, and a malicious or
   merely broken peer. Relate it to the sturdyref and retention work already on
   this arc.
6. **An API sketch.** Concrete enough to argue about: the shape of the
   constructor, how roots are named, how ingress and egress edges are registered
   and mutated while armed, and what the notification looks like. Include a worked
   example of the motivating case, a two-party cycle being broken.

## Deliver, and where

A `jobs/tada/` report with the findings, **and file an issue** on
https://github.com/endojs/endo-but-for-bots with the same findings, framed as
preparation for writing a proposal. State the problem, the options with their
trade-offs, the security analysis, and a recommendation, so the proposal can be
written from the issue without re-research. Link the issue in your report. Do not
open a pull request in this job.

Ground claims in sources you actually read, and cite them. Where the answer is
genuinely open, say it is open. A confident invention here is worse than an
acknowledged gap, particularly on the prior-art and security questions.
