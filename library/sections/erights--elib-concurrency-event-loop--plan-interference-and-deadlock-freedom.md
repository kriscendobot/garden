---
title: "Event Loop Concurrency: plan interference, consistency, and deadlock-freedom"
source_kind: web
source_url: http://erights.org/elib/concurrency/event-loop.html
source_effective_url: https://erights.github.io/erights-org-website/elib/concurrency/event-loop.html
source_fetched_via: mirror
source_content_sha256: 9654ca50ef7eebf4108c9d659e44e98bc517ba42ecf0f81798267623522f31e3
source_authors: [Mark S. Miller]
source_date: 1998-10-03
ingested: 2026-06-28
ingested_by: scholar
topics: [e-language, eventual-send, capability-security]
status: current
notes: >
  Reference-level child chapter of the ELib Event Loop Concurrency hub
  (erights--elib-concurrency-index). The core philosophy chapter: the Hayekian
  plan-interference framing of consistency, the safety/liveness tradeoff that
  dooms thread-based locking, and the catalog of residual liveness hazards
  (livelock, datalock, gridlock, lost signal) that survive into the event-loop
  model. source_date is an era approximation matching the sibling concurrency
  chapters.
---

## Abstract

E's central concurrency-philosophy chapter. It derives capability systems from the
Lambda Calculus by recipe (add message dispatch, add object-local mutable memory),
then argues that once side effects exist, concurrency control must solve two
problems at once: **safety** (preserving consistency) and **liveness** (still
making progress). Drawing on Friedrich Hayek's account of property rights, it
frames the consistency problem as avoiding **plan interference** (and its
concurrent form, **plan interleaving**), distilled to the slogan *avoid stale
stack-frames*. The thread paradigm answers with locks, but locks trade safety for
deadlock-risk: a program with enough locks to trust its safety usually cannot be
trusted for liveness, and one with few enough locks to trust its liveness has too
few to trust its safety. Event loops escape the tradeoff, but still admit residual
liveness hazards: **livelock, datalock, gridlock, and lost signal**. This is the
fullest informal statement of why Endo's event-loop discipline eliminates
classic deadlock.

## Deriving capability systems (the recipe)

All capability systems, including E, could have been derived by a recipe:

1. **Start with the Lambda Calculus.** This gives every property that defines a
   capability system, except that Bob has no way to *retain* a dynamically
   acquired reference to Carol.
2. **Optional: add a message-dispatch mechanism.** Pure lambda calculus defines
   great one-method objects; users want objects that respond to several request
   types. E provides this in the kernel, but Actors, Scheme, KeyKOS, and EROS show
   it need not be primitive.
3. **Add object-local mutable memory and side effects.** Now Bob can retain his
   ability to access Carol. Smalltalk/Java use mutable instance variables;
   Scheme/E bind names to mutable *slots*; KeyKOS/EROS use pages of mutable memory;
   Actors/Joule define an object as a tail-recursive nano-process fetching one
   message at a time from a per-object mailbox.

Much of the charm of pure Lambda Calculus is its blissful ignorance of time and
execution order. Once side effects enter, we must come to terms with these issues;
solutions that let us both avoid confusing ourselves *and* interact with an ongoing
concurrent world are termed **concurrency control**. (Compare Harel and Pnueli's
*transformational* vs *reactive* systems.) The first two problems any concurrency-
control paradigm must solve are **safety** (precautions against confusing
ourselves) and **liveness** (knowing we can still make progress despite those
precautions).

## Safety: preserving consistency (plan interference)

Even sequential programs, once they have side effects, offer many ways to confuse
ourselves; concurrency makes it worse. Hayek's writings on economics reveal the
commonality between concurrency control, pre-object programming, and command
economies: all three suffer from **plan interference**.

Hayek's explanation of the primary virtue of property rights parallels the
rationale for **encapsulation** in object-oriented systems: provide a domain (an
object's encapsulation boundary) in which an agent (the object) executes plans
(methods) using resources (private state) whose proper functioning depends on
those resources not being used simultaneously by conflicting plans. Dividing a
system's state into separately owned chunks (private object states) lets a massive
number of plans use a massive number of resources without resolving a massive
number of conflicting assumptions.

Concurrency introduces a new kind of interference, **plan interleaving**. While a
procedure call is in progress, the delicacy of in-flight assumptions is much
greater; concurrent procedures can interfere with them. The Java `myCounter++`
example reads the value into a register, increments, and writes back; two threads
calling `incr()` at once can lose an update. A plan with a **stale assumption** may
proceed to cause damage because its proper functioning depends on facts no longer
true. Classically phrased as preserving object invariants, it is better focused as
avoiding stale assumptions; since the assumptions most likely broken by
interleaving live in stack frames, the slogan is **avoid stale stack-frames**.

## Liveness: avoiding deadlock (the lock tradeoff)

The thread paradigm avoids stale assumptions with **locking**: while one part of
the program holds delicate assumptions about another, it also holds a lock to keep
that other part from changing underneath it (Java's `synchronized`). For a single
counter this is unproblematic, but in general a method body calls other methods on
other objects, so the thread holds some locks while waiting to obtain others: a
formula for **deadly embrace**. To write correct thread-based programs, one must
avoid any cyclic locking dependency, which means an abstraction's interface
contract must state everything about its locking behavior needed to use it
correctly. This is simply too hard, and very few succeed.

A correct program must both preserve consistency *and* be free of deadlocks. In
the thread paradigm, for a complex program composed from separately written
modules: enough locks to have high confidence in safety usually means low
confidence in liveness; few enough locks to be confident in liveness means too few
to be confident in safety. By contrast, **you can easily write event-loop programs
in which you have high confidence in both safety and liveness.**

## Other liveness issues (residual hazards)

Event loops banish classic deadlock but not every progress bug. E still has:

- **Livelock** (infinite loops steal the vat's thread): an infinite loop prevents
  this vat incarnation from making progress, just as it would a conventional
  thread; it does not prevent other vats. Since each E object lives in one vat,
  livelocking a vat locks up all objects in it. For a *persistent* vat this locks
  only the incarnation, not the vat: killing the incarnation lets the vat roll back
  to its last checkpoint and reincarnate (though it may livelock again; Turing's
  halting problem shows the ultimate unsolvability). 
- **Datalock** (recursive data definition with no bottom): includes when-catches
  "waiting" on promises that the other would resolve. The non-blocking analog of
  deadlock.
- **Gridlock** (messages need space to move): technically looks like classic
  deadlock but is caused by lack of outgoing buffers. The distinction: if more
  buffer space would have kept you from locking up *yet*, it is gridlock rather
  than deadlock.
- **Lost signal** (overslept, forgot to set the alarm): a when-catch waiting on a
  promise that the resolving code forgets to `resolve` in some applicable case.

Darius Bacon's summary captures the nuance: the claim of eliminating deadlock bugs
is like the claim functional languages make to eliminate side-effect bugs. You can
still write code where the same interference occurs, but the language leads you
naturally away from it, so event-loop concurrency is a good idea a lot of the time
even in languages that do not support it directly.

## Why this matters for Endo

This chapter is the argument for the entire `@endo/eventual-send` discipline.
"Avoid stale stack-frames" is exactly why an eventual-send never resumes an old
stack frame: it enqueues a fresh turn instead. The safety/liveness lock tradeoff is
the reason Endo (and JavaScript at large) has no `synchronized`: there is nothing
to lock because a turn runs to completion and cross-agent calls are non-blocking.
The residual hazards survive into JavaScript almost verbatim: **livelock** is a
runaway synchronous loop wedging the event loop, **datalock** is a circular
promise dependency that never resolves (a `HandledPromise` waiting on itself),
**lost signal** is a `makePromiseKit()` whose `resolve` is never called on some
path. Knowing the taxonomy is how an Endo author diagnoses a "stuck" promise.

## Translation (E to Endo)

| E concurrency term | Endo / Hardened JavaScript equivalent |
|---|---|
| plan interference / interleaving | shared-state data race (absent by construction in Endo) |
| avoid stale stack-frames | a turn runs to completion; eventual-send enqueues a fresh turn |
| `synchronized` lock / deadly embrace | (no equivalent; Endo has no locks to deadlock on) |
| datalock | an unresolvable circular promise / `HandledPromise` waiting on itself |
| lost signal | a `makePromiseKit()` whose `resolve` is never called |
| livelock | a runaway synchronous loop wedging the event loop |

## Cross-references

- Parent hub: [erights--elib-concurrency-index--event-loop-reference-map](erights--elib-concurrency-index--event-loop-reference-map.md).
- Motivating essay: [erights--elib-concurrency-overview--why-threads-are-evil](erights--elib-concurrency-overview--why-threads-are-evil.md).
- The datalock hazard is given its own tutorial treatment in
  [erights--elang-concurrency-epimenides--reference-states-and-data-lock](erights--elang-concurrency-epimenides--reference-states-and-data-lock.md).
- The Hayekian agoric framing is developed in the agoric-systems papers under
  topic `capability-theory`.

## Source

Source: [elib/concurrency/event-loop.html](https://erights.github.io/erights-org-website/elib/concurrency/event-loop.html) (mirror of `http://erights.org/elib/concurrency/event-loop.html`), last modified 1998-10-03 (era approximation), content SHA-256 `9654ca50ef7eebf4108c9d659e44e98bc517ba42ecf0f81798267623522f31e3`, fetched via the erights.org GitHub Pages mirror.
