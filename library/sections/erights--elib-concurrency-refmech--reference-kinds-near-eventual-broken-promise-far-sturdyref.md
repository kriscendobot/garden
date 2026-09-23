---
title: "Reference Mechanics: Near / Eventual / Broken, Promise / Resolved, Far, SturdyRef"
source_kind: web
source_url: http://erights.org/elib/concurrency/refmech.html
source_effective_url: https://erights.github.io/erights-org-website/elib/concurrency/refmech.html
source_fetched_via: mirror
source_content_sha256: e21219868359f16f811c7d20fd9a07e7df505eacee14b6378e905b934c0f25d6
source_authors: [Mark S. Miller]
source_date: 1998-10-03
ingested: 2026-06-28
ingested_by: scholar
topics: [e-language, eventual-send, pass-style, capability-security]
status: current
notes: >
  Reference-level child chapter of the ELib Event Loop Concurrency hub
  (erights--elib-concurrency-index). The reference-kind taxonomy: every live
  reference is Near, Eventual, or Broken (horizontal axis) and Promise or Resolved
  (vertical axis); a Resolved Eventual reference is a Far reference; SturdyRefs
  survive partition. This is the direct ancestor of the `@endo/eventual-send`
  / `@endo/marshal` distinction between a present reference (callable now), a
  promise (eventual only), a broken/rejected reference, and a remote presence, and
  of the PassByProxy vs PassByCopy split marshal calls pass-style. source_date is
  an era approximation matching the sibling concurrency chapters.
---

## Abstract

The chapter that enumerates **the kinds of live reference** so that message
delivery and partial failure can be reasoned about precisely. Two orthogonal axes
classify every reference. The **horizontal taxonomy**: a live reference is **Near**,
**Eventual**, or **Broken**. Near is the familiar same-vat reference (supports both
immediate calls and eventual sends, guaranteed delivery, never partitions); Eventual
is strictly weaker (eventual sends only, fail-stop, not guaranteed); Broken
designates nothing and never will (holds a `Throwable` problem). The **vertical
taxonomy**: a reference is a **Promise** (not yet locally known to designate an
object; messages queue behind the unbound arrowhead) or **Resolved** (it is locally
known whether and what it designates). A Resolved non-Broken reference is
**Fulfilled**; a Resolved Eventual reference is a **Far** reference (designates a
PassByProxy object in a remote vat). At the detailed level there are LocalPromise
and RemotePromise variants, and the **SturdyRef** (diamond arrowhead) is the only
reference kind that survives a network partition. Near and Broken are terminal
states; once Near always Near, once Broken always Broken; once Resolved always
Resolved. This is the taxonomy `@endo/eventual-send` collapsed into present /
promise / rejected, and the PassByProxy-vs-PassByConstruction split that became
marshal's pass-style.

## Why this taxonomy exists

The page explains the different kinds of references "for purposes of accurately
understanding message delivery and partial failure," and as orientation for
**reference equality**: if a reference is **Settled**, it supports E's `==`
construct and may be a key in E's hashtables. (For the full equality treatment,
the chapter forwards to "When are two references the same?".)

## Horizontal taxonomy: Near, Eventual, Broken

All references are either **Sturdy** or **Live**. The most important distinction
among live references is that each is **Near**, **Eventual**, or **Broken**. The
diagrams use David Harel's **Statecharts** notation: a rounded rectangle is a state
or set of states, and an arrow from a from-set to a to-set means a transition from
any state in the from-set to any in the to-set. A Promise may become Near, Far, or
Broken; a Far reference may become Broken.

- **Near.** The reference familiar from single-machine object languages: a reference
  arrow whose head and tail are in the same vat, with the arrowhead attached to the
  designated object. Being Near is a **final state** (once Near, forever Near), so
  Near references are not susceptible to partition. Near references support **both
  immediate calls and eventual sends**. Immediate calls are guaranteed to reach
  their recipient; eventually-sent messages are guaranteed delivered per the
  partial order, except across a checkpoint/revival.
- **Eventual.** Strictly weaker than Near: it supports **only eventual sends**, with
  only a **fail-stop** guarantee rather than guaranteed delivery. Fail-stop means
  that if it ever comes to designate an object it delivers messages per the partial
  order until it fails, and once it fails it never again delivers any message and
  eventually becomes Broken.
- **Broken.** Strictly weaker still: it does not and never will designate an object.
  It holds a `Throwable` indicating the problem that caused it not to designate. It
  does not support immediate calls (an attempt throws its problem) and does not
  support eventual sends (an attempt yields a reference broken by the same problem).
  Like Near, **Broken is terminal** (once Broken always Broken). Broken references
  are transitively immutable and transitively passed by copy.

## Vertical taxonomy: Promise vs Resolved (and Far)

A reference is either a **Promise** or **Resolved**.

- **Promise.** Not (yet) locally known to designate an object. Messages sent to a
  Promise are **queued, awaiting resolution**; if the Promise becomes fulfilled
  (whether to a Near or a Far reference) the queued messages are delivered to that
  object. The result of an eventual-send always **starts as a Promise** for the
  outcome. Promises are Unsettled.
- **Resolved.** It is locally known whether the reference designates an object and,
  if so, which. When an eventual send's result becomes Resolved we know the request
  completed. Promises can become Resolved, but **once Resolved always Resolved**. A
  Resolved non-Broken reference is **Fulfilled** (we know the object and it conveys
  messages); if instead the result becomes Broken, either the request reported an
  exceptional outcome (a `throw`, or a returned Broken reference), or a network
  partition prevented the request from arriving, or a partition prevented the answer
  from coming back. In the partition cases the reference the message was sent on has
  failed and will become Broken as well.
- **Far.** A **Resolved Eventual** reference. A Far reference is locally known to
  designate a **PassByProxy** object in a remote vat. Messages sent on it eventually
  reach that object unless the Far reference fails because of a partition
  (communications failure or vat crash). A Far reference is **Settled** and carries
  the identity of the remote object it designates.

## Detailed taxonomy: LocalPromise and RemotePromise

There are two kinds of Promise, mostly of interest to the theoretician or E
implementor (for most programming purposes all Promises are alike). The result of
an eventual-send starts as either a **LocalPromise** or a **RemotePromise**
depending on whether the send was intra- or inter-vat.

- A **LocalPromise** is a reference locally known to **not yet** designate any
  object (as opposed to a RemotePromise, which is **not yet locally known** to
  designate any object). Its tail (the Ref) and head (the Resolver) are in the same
  vat, but the head is not yet pointing anywhere. It is paired with a corresponding
  **Resolver** used to attach the arrowhead to a target; since it can be attached to
  anything, a LocalPromise can transition to any other state. An eventual-send on an
  intra-vat reference returns a LocalPromise as the promise for the result; a
  LocalPromise can also be created explicitly via `Ref.promise()`.
- A **RemotePromise** is a remote reference whose target identity and location are
  not yet locally known, and whose arrow's tail and head are not both in the same
  vat. It nevertheless sends messages towards its arrowhead in the hope they can be
  delivered once the target is determined. An eventual send on a RemotePromise
  returns a RemotePromise for the result. When a LocalPromise is passed over the
  network, the receiving vat receives a RemotePromise remotely designating the
  original LocalPromise.

## Expanded taxonomy and the diagram legend

The expanded taxonomy mixes statechart notation (rounded rectangles and their
arrows) with the **extended Granovetter notation** (the dotted reference arrows
inside the leaf states). The arrowhead glyphs encode the reference kind:

- A line **without** a squiggle is wholly within a single vat; a line **with** a
  squiggle (Remote) is not (or, for a SturdyRef, may not be).
- A **triangular arrowhead** is a reference messages can be sent on; messages move
  towards the arrowhead hoping to be delivered.
- A **gray halo** around an arrowhead (Promise) means the arrowhead is not yet
  attached to an object but is reified as a **Resolver** object, used to determine
  whether and what the arrow should point at.
- A **gray circle** attached to an arrowhead is the designated object; elsewhere
  circle vs rectangle distinguishes PassByProxy (circle) from PassByConstruction
  (rectangle), the common case of the latter being **PassByCopy**.
- A **slash** as arrowhead (Broken) indicates the reference will never point at
  anything; it is paired with a side box holding the problem-object (a `Throwable`).
  Messages sent on it report the problem and are discarded. A gray circle after the
  slash is the object it used to point at before breaking, retained for
  equality-testing identity.
- A **diamond** as arrowhead (SturdyRef) is "forever": the only reference kind to
  survive a network partition, and thus the means by which connectivity is preserved
  and consistency recovered across such traumas. The price of survival is that a
  SturdyRef **cannot directly accept messages** (it cannot guarantee fail-stop
  delivery); see "Handling Partial Failure".

## Distributed equality

Reasoning about distributed reference equality needs yet further distinctions; the
chapter forwards to the **Equality** treatment and in particular "When are two
references the same?" (already ingested as the `web--miller-equality-*` cluster).

## Translation to Endo

| E (refmech) | Endo / Hardened JavaScript |
|---|---|
| Near reference | a present reference: callable synchronously now (`obj.foo()`), and also `E(obj)`-able |
| Eventual reference | a reference reachable only by `E(p)` / `E.sendOnly` (eventual send), never a sync call |
| Broken reference | a rejected promise / a reference that throws its stored problem on use |
| Promise / Resolved | unsettled promise vs settled (fulfilled or rejected) — the HandledPromise lifecycle |
| Far reference | a remote presence (the `Far`/Remotable target reached over CapTP) |
| PassByProxy / PassByCopy | marshal pass-style: remotable (by-proxy presence) vs copyRecord/copyArray (by-copy) |
| SturdyRef | a persistable capability (an OCapN sturdyref / off-line-capable designation) |
| Resolver | the resolve/reject functions of a promise; HandledPromise's resolver |

Source: [elib/concurrency/refmech.html](https://erights.github.io/erights-org-website/elib/concurrency/refmech.html) (canonical `http://erights.org/elib/concurrency/refmech.html`), content SHA-256 `e21219868359f16f811c7d20fd9a07e7df505eacee14b6378e905b934c0f25d6`, fetched via the erights.org GitHub Pages mirror.
