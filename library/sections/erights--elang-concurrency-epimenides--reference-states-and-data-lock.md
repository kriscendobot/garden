---
title: "The Epimenides Paradox: reference states and data-lock"
source_kind: web
source_url: http://erights.org/elang/concurrency/epimenides.html
source_effective_url: https://erights.github.io/erights-org-website/elang/concurrency/epimenides.html
source_fetched_via: mirror
source_content_sha256: 02342f70c87a06b27aff896def2e9d8ca8081437c2e71a903fcdb19ed8602bf7
source_authors: [Mark S. Miller]
source_date: 1998-10-03
ingested: 2026-06-28
ingested_by: scholar
topics: [eventual-send, e-language, references]
status: current
notes: >
  Primary erights.org tutorial chapter (Concurrency in E, child of the concurrency
  hub). The historical primary source for E's three reference states (near,
  eventual, broken) and for "data-lock" — E's closest analog to deadlock, an
  unresolvable circular promise definition that simply never resolves rather than
  hanging the machine. Reachable via the erights.org GitHub Pages mirror.
  source_date is an era approximation matching the sibling concurrency chapters.
---

## Abstract

The E tutorial's **Epimenides' Paradox** chapter uses the Liar Paradox ("This
sentence is false") to motivate two things Endo inherits: E's **three reference
states** (near, eventual, broken) and **data-lock**, E's closest analog to
deadlock. Trying to define the self-negating value `def liar := !liar`
synchronously fails ("not synchronously callable") because the right-hand side
runs while `liar` is still an **eventual reference** (a **promise**) — a reference
whose arrow tail exists but whose head is not yet attached to an object. A
synchronous "do it now" call needs a **near** reference (head and tail in the same
vat, head already attached to an object; a near reference is forever near and
always delivers). Using the **eventually-operator** `<-` instead, `def liar :=
liar <- not()` succeeds in the sense that it returns a promise — but the `not()`
message stalls forever waiting for the very object that the message itself is
supposed to produce, so `liar` is permanently unresolved. The chapter names this
**data-lock** ("Doctor, it hurts when I take this inference step." "Then don't take
that inference step."): an unresolvable circular promise definition that, unlike a
threaded deadlock, hangs nothing — it just stays a `<Promise>` forever. Use this
to ground the near/eventual/broken reference-state vocabulary, the
synchronous-call-needs-a-near-reference rule, and the data-lock concept that
explains why E's deadlock-freedom claim is about not blocking the machine, not
about every circular definition resolving.

## The three reference states

A reference in E is "an arrow whose tail is the reference as a value and whose head
is attached to an object"; messages ride from tail to head until they reach the
object that should process the message. A reference is in one of three states:

- **Near.** Both arrow head and tail are in the same **vat**, and the head is
  *already attached to an object*. Only a near reference supports a synchronous
  "do it now" call. **Once near, forever near**: it will always be attached to the
  same object and will never fail to deliver a message to it. Conventional
  single-address-space object-oriented programming (which the chapter abbreviates
  **sasoop**) has only the equivalent of near references.
- **Eventual.** A reference that crosses between machines, *or* a reference whose
  arrow head is not yet attached to an object. This second case is exactly a
  **promise**: when you use a variable on the right side of a definition that will
  be defined on the left, during that right-side execution the variable's value is
  an eventual reference designating the object it will become. An eventual
  reference rejects synchronous calls; you message it with the eventually-operator
  `<-`, which returns a promise for the result.
- **Broken.** The reference will never deliver — for instance, a live reference
  whose connection partitioned, or a promise deliberately broken (the sibling
  Concurrency Races chapter's `timeBomb` produces one).

## The paradox and data-lock

The chapter recalls circular initialization from *Defining Variables* (the
model/view/controller mutual reference, where a variable appears on the right side
of the very `def` that defines it on the left). That works because the variable is
an eventual reference during right-side evaluation. The question: can we exploit
this to define something **paradoxically**?

```e
? def liar := !liar
# problem: Failed: not synchronously callable

? def liar := liar.not()
# problem: Failed: not synchronously callable
```

Both fail synchronously: `liar` is an eventual reference (a promise) during the
right-side evaluation, and there is "not yet an object on the other side of the
arrow," so a synchronous call cannot be delivered. Switching to the eventually-send
operator changes the outcome:

```e
? def liar := liar <- not()
# value: <Promise>
? liar
# value: <Promise>
```

The `not()` message is now stalled until there is an object to deliver it to — but
the object it waits for **is the result of that same `not()` message**. The
variable is stuck unresolved forever, "never being able to decide if it's true or
false, and therefore never having to deal with the paradox." The chapter names
this **data-lock**: "Such unresolvable circular definitions are the closest E comes
to conventional deadlock." The crucial difference from a threaded deadlock is that
nothing blocks — no thread is stuck, the machine keeps running, and the
unresolvable value is simply a permanent `<Promise>`. This is the flip side of E's
deadlock-freedom: eventual-send never blocks a vat, so a genuinely circular data
dependency manifests as a never-resolving promise rather than a hung process.

## Translation (E to Endo)

| E term | Endo / Hardened JavaScript equivalent |
|---|---|
| near reference | a local reference to a present object (synchronously callable) |
| eventual reference / promise | an unresolved `HandledPromise` (message with `E()`, not a sync call) |
| broken reference | a rejected promise / a severed remote presence |
| "not synchronously callable" | calling a method on a promise instead of awaiting / `E()`-ing it |
| data-lock | a promise that never settles because its resolution depends on itself |
| vat | compartment / per-agent event-loop domain |
| eventually-operator `<-` | `E(target).method(args)` |

## See also

- [erights--elang-concurrency-index--event-loop-concurrency-map](erights--elang-concurrency-index--event-loop-concurrency-map.md): the concurrency hub that lists this chapter.
- [erights--elang-concurrency-race--racing-joining-and-timeouts](erights--elang-concurrency-race--racing-joining-and-timeouts.md): the sibling chapter whose `timeBomb` produces a broken reference.
- [data-lock](../concepts/data-lock.md): the concept page this chapter grounds.
- [erights--elang-concurrency-introducer--remote-objects](erights--elang-concurrency-introducer--remote-objects.md): the chapter where eventual (cross-machine) references and the eventually-operator are introduced for distribution.
- [papers--miller-tribble-shapiro-concurrency-among-strangers-2005--vat-and-event-loop-model](papers--miller-tribble-shapiro-concurrency-among-strangers-2005--vat-and-event-loop-model.md): the 2005 formalization of the vat and the near/eventual/broken reference states.

Source: [elang/concurrency/epimenides.html](https://erights.org/elang/concurrency/epimenides.html), fetched 2026-06-28 via the erights.org GitHub Pages mirror ([erights.github.io/erights-org-website/elang/concurrency/epimenides.html](https://erights.github.io/erights-org-website/elang/concurrency/epimenides.html)), content SHA-256 `02342f70c87a`.
