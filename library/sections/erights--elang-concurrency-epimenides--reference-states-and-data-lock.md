---
title: "E's three reference states (near / eventual / broken) and data-lock"
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
  Primary-source HTML via the erights.org GitHub Pages mirror. The Epimenides /
  Liar Paradox chapter of the elang concurrency tutorial. Captures the three
  reference states (near / eventual / broken) and data-lock — E's closest analog
  to deadlock — which this section grounds for the `data-lock` concept page.
  source_date is an era approximation matching the sibling concurrency chapters.
---

## Abstract

The **Epimenides' Paradox** chapter uses the Liar Paradox ("this sentence is
false") to motivate two ideas at the heart of E's concurrency model: the three
**reference states** a value's pointer can be in — **near**, **eventual**, and
**broken** — and **data-lock**, the unresolvable circular promise that is "the
closest E comes to conventional deadlock." The decisive lesson is that a
self-negating definition does not hang the machine: the synchronous form is
simply rejected ("not synchronously callable"), and the eventual-send form
returns a `<Promise>` that can never resolve because it waits on itself — yet
nothing blocks, because eventual-send never blocks a vat. This section captures
the paradox walkthrough, the reference-state taxonomy, and the Endo translation.

## The Liar Paradox, encoded in E

E can define data in terms of itself — the chapter recalls the circular
model/view/controller definition from *Defining Variables*, where variables on
the right of a `def` are bound on the left:

```
def model := modelMaker(...)
def [view, controller] := [
  viewMaker(model, controller),
  controllerMaker(model, view)]
```

The question the chapter asks is whether we can define data *paradoxically*. The
Liar sentence is true if and only if it is false, so we try to bind a variable to
the opposite of itself:

```
? def liar := !liar
# problem: Failed: not synchronously callable

? def liar := liar.not()
# problem: Failed: not synchronously callable
```

Both forms fail the same way, and the error message is the key to the whole
chapter.

## The three reference states

In E the value of a variable or expression is an **object reference** — diagrammed
as an arrow whose tail is the reference-as-value and whose head is attached to an
object. A reference is in one of three states:

- **near** — both the arrow's head and tail are in the same vat *and* the head is
  already attached to an object. Only a near reference can take a **synchronous**
  call (`bob.foo(carol)` — "do it *now*"): the target processes the message and
  returns control before the caller continues. Once near, a reference is forever
  near, always attached to the same object, and will never fail to deliver.
  Conventional single-address-space object-oriented programming has only the
  equivalent of near references.
- **eventual** — a reference that crosses between machines, *or* a reference whose
  arrow head is not yet attached to an object. A variable used on the right of a
  definition before it is bound on the left is exactly this: during the right
  side's execution its value is an eventual reference — a **promise** for the
  value the variable will hold once the head is hooked up (which does not happen
  until the right side finishes).
- **broken** — the third state: a reference that will never deliver (severed /
  rejected).

Because `liar` is still an eventual reference (a promise) while its own definition
is executing, a synchronous "do it now" call against it cannot be delivered —
hence *not synchronously callable*.

## Data-lock: the eventual-send form that never resolves

The fix for "there is no object yet" is E's "do it *eventually*" message pass, the
asynchronous send operator `<-`:

```
? def liar := liar <- not()
# value: <Promise>

? liar
# value: <Promise>
```

This asks whatever object the `liar` arrow comes to point at to compute its own
`not()`, then resolves `liar` to that eventual result. But the `not()` message is
stalled until there is an object to deliver it to — and the object it waits for is
the *result of the not() message itself*. So `liar` is stuck forever unresolved,
never deciding true or false, and therefore never confronting the paradox.

> "Doctor, it hurts when I take this inference step." "Well then, don't take that
> inference step."

Such unresolvable circular definitions are **the closest E comes to conventional
deadlock**; the chapter names them **data-lock**. The point that distinguishes
data-lock from a threaded deadlock is implicit but decisive: nothing is blocked.
Because eventual-send never blocks a vat, a genuinely circular *data* dependency
surfaces as a permanently-pending `<Promise>` rather than as a hung process — the
vat keeps running other turns, and only that one value is forever undecided.

## Why this matters for Endo (the model in one paragraph)

The three reference states and data-lock are inherited directly by Hardened
JavaScript / Endo. A near reference is an ordinary in-vat object reference; an
eventual reference is a `HandledPromise` (or a remote presence reached through
`E()`); a broken reference is a rejected/severed promise. Endo's eventual-send,
`E(target).method(args)`, is the `<-` operator, and it never blocks the event
loop — so a `HandledPromise` whose settlement depends on itself simply never
settles, exactly as `liar` stays a permanent `<Promise>`. Data-lock is thus the
flip side of E's (and Endo's) deadlock-freedom: the price of never blocking a vat
is that a circular data dependency becomes a never-resolving promise instead of a
wedged process.

## Translation (E to Endo)

| E term | Endo / Hardened JavaScript equivalent |
|---|---|
| near reference | ordinary in-vat object reference |
| eventual reference / promise | `HandledPromise`; a remote presence via `E()` |
| broken reference | rejected / severed promise |
| synchronous call (`bob.foo(carol)`) | a direct in-vat method call (only on a near ref) |
| eventual-send (`liar <- not()`) | `E(target).method(args)` |
| data-lock (unresolvable circular promise) | a `HandledPromise` whose settlement depends on itself — never settles, blocks nothing |

## Source

Source: [elang/concurrency/epimenides.html](https://erights.github.io/erights-org-website/elang/concurrency/epimenides.html) (mirror of `http://erights.org/elang/concurrency/epimenides.html`), last modified 1998-10-03, content SHA-256 `02342f70c87a06b27aff896def2e9d8ca8081437c2e71a903fcdb19ed8602bf7`, fetched via the erights.org GitHub Pages mirror.
