---
title: "Message Passing: the six primitives, immediate call vs eventual send, resolve/smash outcomes"
source_kind: web
source_url: http://erights.org/elib/concurrency/msg-passing.html
source_effective_url: https://erights.github.io/erights-org-website/elib/concurrency/msg-passing.html
source_fetched_via: mirror
source_content_sha256: 953aab5fa6dedb1f6f6b2fc077e549dfc18f931aa7e5fa45527ed4931bcf1988
source_authors: [Mark S. Miller]
source_date: 1998-10-03
ingested: 2026-06-28
ingested_by: scholar
topics: [e-language, eventual-send]
status: current
notes: >
  Reference-level child chapter of the ELib Event Loop Concurrency hub
  (erights--elib-concurrency-index). The six message-passing primitives: the
  synchronous immediate `.` call, its three outcomes (success/failure/escape via
  resolve/smash/eject), and the asynchronous eventual `<-` send in its sendOnly and
  pipelined forms. The pipelined send's continuation is a promise's Resolver rather
  than a stack-frame; this is the direct ancestor of `@endo/eventual-send`'s
  `E()` / `E.sendOnly` and the promise-as-continuation model. source_date is an era
  approximation matching the sibling concurrency chapters.
---

## Abstract

The chapter that enumerates E's **six message-passing primitives** and explains how
return values come back. The synchronous **immediate call** (`.`) is allowed only on
a **NEAR** reference; it carries a hidden **continuation** pointing at the caller's
stack-frame, suspends that frame, and the callee's completion implicitly sends one
of three **outcome** messages back: `resolve(result)` for **success**,
`smash(problem)` for **failure** (a `throw`), or `eject(ejector, value)` for
**escape** (a non-local exit via an ejector). The asynchronous **eventual send**
(`<-`) comes in two forms: **sendOnly** (the value is statically unused, so a pure
one-way message with no continuation) and the **pipelined send** (the value may be
used, so the message carries a continuation that is **not a stack-frame but the
Resolver of a promise**). Because the pipelined send returns a promise immediately,
"eventual-ness" is contagious: once you must send rather than call, you get back
another eventual reference, and the **Layers of When** are how you turn that
semi-data-flow back into control flow. This is the model `@endo/eventual-send`
implements: `E(x).m()` returns a promise whose resolver is the continuation.

## Taxonomy of messaging primitives

E has six message-passing primitives:

1. The synchronous **immediate (`.`) call** (carries a continuation).
2. The synchronous **outcome**, with three sub-cases:
   - **Success**: evaluation to a result.
   - **Failure**: `throw`ing a problem report.
   - **Escape**: like `break()` or `continue()`.
3. The asynchronous **eventual (`<-`) send**, where an outcome report is either
   - not expected: the **sendOnly**, or
   - may be expected: the **pipelined-send** (carries a continuation).

Every message conveys to an individual recipient at least a **verb** (a String) and
a **list of arguments**. A message often represents a request (identified by verb and
argument count, not argument types), so the recipient generally knows why it is
receiving new authority; this facilitates programming **non-confusable deputies**.
For the call and the pipelined-send, the message additionally carries an implicit
**continuation**: the object to which the outcome of performing the request is
reported.

E computation occurs only within a **stack-frame** (drawn as a lightning bolt within
an object). A stack-frame happens when an object receives an immediate call or an
eventual send. As an object is an instance of a behavior description plus its
instantiating state, a stack-frame is an instance of the matched method/matcher plus
state from matching the incoming message; it can accumulate more state as it runs.
All messages are emitted only from stack-frames.

## i) The immediate call

```
def alice {
    to doSomething() {
        def result := bob.foo(carol)
        ... # stuff after call
    }
}
```

The call is allowed only if the recipient reference is **NEAR**; otherwise the
attempt throws an appropriate exception. Beyond the components shared by all
messages, a synchronous call contains a special **continuation** argument pointing at
the caller's stack-frame, and turns the calling frame from **active** to
**suspended**. Computation occurs only in active frames; a suspended frame must be
pointed at by exactly one continuation argument. There is at most **one active
stack-frame in a vat**, and all frames form a linear chain between it and a **top
stack-frame** (one directly spawned to service an eventual send). Between turns there
are no stack-frames (the queue is empty, or the vat sits on disk awaiting revival).
The message in a call need not be allocated separately, since no time passes between
departure and arrival; calling simultaneously creates the receiving frame. The
continuation is not explicitly accessible to the E program (continuations are reified
only in the model, like the denotational semantics, unlike Actors or Scheme).

## ii) Synchronous outcome of stack-frame completion

The callee uses the continuation only by **completing** its stack-frame (which
discards it); the manner of completion implicitly passes an **outcome message**.
Outcome messages have no hidden continuation argument. The three outcomes:

- **Success**: "falling off the end", represented by `resolve(result)` to the
  continuation. The caller's suspended call expression evaluates to that result.
- **Failure**: from executing `throw(problem)`, represented by `smash(problem)`.
  Execution in the caller skips to the nearest enclosing `try`-`catch` or
  `try`-`finally`; if there is none, the caller's frame also completes in failure and
  forwards the `smash` to its own continuation.
- **Escape**: invoking an enabled **ejector** calls the current continuation with
  `eject(ejector, value)`. An ejector is enabled at the start of an `escape`
  expression and disabled on exit (dynamic extent only); each escape expression's
  continuation recognizes its own ejector. Failure and Escape are both forms of
  **non-local exit**.

Other than by invoking its continuation, a callee **cannot stop executing, even on
I/O**: blocking I/O is instead handled by requesting (via a send) that notification
be delivered to a designated object. As a result E is **strongly deadlock-free**
(though still subject to live-lock by infinite loops).

## iii) The eventual send

There are two forms of eventual send, written the same way but distinguished by
whether the value of the send expression appears to be needed.

- **sendOnly**: when it is statically apparent the value is unused (e.g. to the left
  of a semicolon, `bob <- foo(carol); ...`), the message is a pure one-way message
  containing only the verb and explicit arguments. The only feedback Alice can get is
  what she explicitly arranges; when Bob finishes, he reports the outcome to no one.
- **The pipelined send**: when static analysis cannot rule out the value being used
  (e.g. `def promise := bob <- foo(carol);`), the message, like a call, carries a
  continuation. Unlike a call, the continuation is **not a stack-frame but the
  Resolver of a promise** (the arrowhead with the gray halo). The reported outcome is
  the outcome of a top-level stack-frame, which is the outcome of **a turn as a
  whole**.

## Turning control-flow into semi-data-flow (and back)

Because ejectors are only dynamic in extent, the outcome of a turn can only be
success or failure, so the Resolver need respond only to `resolve(result)` and
`smash(problem)`. On `resolve`, the promise becomes equivalent to the result; on
`smash`, the promise becomes **broken** and the problem is its reason. A
stack-frame-as-continuation distinguishes `resolve(brokenRef)` (successful evaluation
to a broken reference) from `smash(problem)` (exceptional control flow), but a
**Resolver reacts to both identically**, so Alice cannot distinguish the two ways Bob
reported a problematic outcome.

All messages on a reference arrow move toward the arrowhead to be delivered; messages
on an unresolved promise wait behind the unbound arrowhead until resolution, then may
all be delivered to the resolution. This is **semi-data-flow**: the message (not the
sender) waits for the recipient to be determined. (It is "semi" because conventional
data flow would also wait for all *arguments* to resolve, which cannot be reconciled
with E's partial-ordering constraints; where wanted, the `promiseAllDone` pattern
programs it explicitly.) The puzzling **contagion of eventual-ness** (once you have a
maybe-eventual reference you must send, and get back another eventual reference) is
resolved by the **Layers of When**, which arrange immediate control flow when a
reference becomes fulfilled or broken.

## Translation to Endo

| E (msg-passing) | Endo / Hardened JavaScript |
|---|---|
| immediate `.` call (NEAR only) | synchronous method call `obj.m()` on a present reference |
| eventual `<-` send | `E(obj).m()` (`@endo/eventual-send`) |
| sendOnly | `E.sendOnly(obj).m()` (one-way, no result promise) |
| pipelined send | `E(promiseForObj).m()` — pipelining a message onto an unresolved promise |
| continuation = promise Resolver | the `resolve` / `reject` of the returned promise |
| `resolve(result)` / `smash(problem)` | promise fulfilled / promise rejected |
| escape / ejector | a non-local exit (no direct Endo analog; closest is throw plus catch) |
| Layers of When | `E.when(p, onFulfilled, onRejected)` reaction combinators |

Source: [elib/concurrency/msg-passing.html](https://erights.github.io/erights-org-website/elib/concurrency/msg-passing.html) (canonical `http://erights.org/elib/concurrency/msg-passing.html`), content SHA-256 `953aab5fa6dedb1f6f6b2fc077e549dfc18f931aa7e5fa45527ed4931bcf1988`, fetched via the erights.org GitHub Pages mirror.
