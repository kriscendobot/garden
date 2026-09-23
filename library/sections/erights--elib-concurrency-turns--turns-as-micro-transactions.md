---
title: "Vat Turns as Micro-Transactions: atomicity without locks, chronological encapsulation"
source_kind: web
source_url: http://erights.org/elib/concurrency/turns.html
source_effective_url: https://erights.github.io/erights-org-website/elib/concurrency/turns.html
source_fetched_via: mirror
source_content_sha256: 27ef8ef7ad81d3a24ce7839f92e06bde9f2804b87517e6bbed4e874497af6df7
source_authors: [Mark S. Miller]
source_date: 1998-10-03
ingested: 2026-06-28
ingested_by: scholar
topics: [e-language, eventual-send]
status: current
notes: >
  Reference-level child chapter of the ELib Event Loop Concurrency hub
  (erights--elib-concurrency-index). The atomicity argument: a turn runs to
  completion with mutually-exclusive access to its vat's state, so E's turns are
  atomic serializable micro-transactions and E preserves consistency under
  concurrency without fine-grained locking; the chronological-encapsulation
  principle isolates conceptually separate plans into separate turns. This is the
  invariant `@endo/eventual-send` enforces (run-to-completion turn = JS microtask)
  and the reason agent code needs no locks. source_date is an era approximation
  matching the sibling concurrency chapters.
---

## Abstract

The chapter ("Game Turns as Micro-Transactions") that states E's atomicity
properties. Because E's message-passing rules impose a LIFO stack discipline within a
turn, all synchronously-accessible side effects of a callee complete before the
caller continues. A **turn** is the synchronous processing of one pending delivery;
like turns on a game board, a vat's state evolves only through a sequence of turns,
each executing with **mutually exclusive access** to that state and running **to
completion** before the next begins. Although other vats run concurrently, a caller
sees only its callee's synchronous side effects, and a turn implicitly has full
mutual exclusion on all state it can synchronously reach (only its own vat's state).
So E execution is **not observably distinguishable** (except for timing and infinite
loops) from a universe in which only one vat takes a turn at a time: turns are
**atomic serializable micro-transactions**, and E is strongly consistency-preserving
under concurrency **without error-prone fine-grained locking**. The companion
principle, **chronological encapsulation**, uses the eventual send to isolate
conceptually separate plans into separate atomic turns, avoiding plan interference.
This is the invariant `@endo/eventual-send` preserves: a JavaScript microtask runs to
completion, so agent code never needs locks.

## Turns as micro-transactions

Taken together, E's message-passing rules impose the familiar **LIFO stack
discipline** within a turn: all synchronously-accessible side effects brought about
by the callee are done before the caller continues. A `result` is not bound until
and unless the callee returns successfully, and the code after a call executes in the
context of whatever synchronous side effects the callee caused.

The synchronous processing of one pending delivery (an event of the event loop) is a
**turn**. If a vat's state is like a game board's, then in both cases the state
evolves only through a sequence of turns; **each turn executes with mutually
exclusive access** to that state and **runs to completion before the next turn
starts**. Because vats are only asynchronously coupled, a caller sees only its
callee's synchronous side effects, and an E turn implicitly has **full mutual
exclusion on all state to which it has synchronous access** (only state within its
vat). As a result E execution is not observably distinguishable (except for timing
and the effects of infinite loops) from an implementation in which, across the whole
universe, only one vat at a time takes a turn. **E's turns are therefore atomic
serializable micro-transactions**, and E is strongly consistency-preserving in the
face of concurrency, **without any error-prone fine-grained locking**.

It is a **micro**-transaction because E deliberately unbundles the features the
classic ACID transaction combines: a vat is committed to stable storage
(checkpointed) only **between** turns, and (because disk seeks are expensive relative
to computation) much **less often than once per turn**. E does not claim distributed
atomic transactions; since these are provably unimplementable (the **Coordinated
Attack Problem**), this may be no great loss. One can build distributed mutual
exclusion on top of E, but good E style avoids it; the authors report encountering
only one practical application demanding it. (Recovering distributed consistency
after partitions or rollbacks is the separate subject of "Handling Partial
Failures".) There is **no facility for aborting a turn and automatically undoing its
side effects**; one manually uses `try`-`finally` to undo some side effects while
unwinding a non-local exit.

## Chronological encapsulation

Event loops are claimed to be **better even than purely sequential programming** at
maintaining consistency. The illustration is the classic **Observer** pattern
("Listener" in Java, "Dependent" in Smalltalk): an observer asks an observable to
notify it when a condition occurs. An observable slot in E:

```
def observableSlot {
    to makeSlot(var value, _) :near {
        var observers := []
        def self {
            to addObserver(observer) {
                observers += [observer]
            }
            to getValue() :any {value}
            to setValue(newValue) {
                for observer in observers {
                    observer <- valueChanged(newValue)
                }
                value := newValue
            }
        }
    }
}
```

Two peculiarities are deliberate and instructive. First, the notification uses a
**send** (`observer <- valueChanged(...)`), not a call, even though the problem does
not mention concurrency. Were it a call, the observers' side effects would run before
the assigner returned from the assignment, and the code containing the assignment was
written without anticipating such side effects. The maxim: when Alice passes a message
to Bob to **subcontract** part of her plan, she invokes Bob on her own behalf and
often wants to wait for his side effects and outcome (the immediate call does
exactly this); when Alice passes a message to Bob **on Bob's behalf** (as an
observable notifying an observer), this courtesy should be **minimally disruptive** to
Alice. The send queues, on the **observer's vat's** queue, a pending delivery of
`valueChanged`, which happens in its **own separate turn** and cannot affect the turn
that sent it.

Second, the actual assignment is placed **after** the notification loop, harmlessly,
**because** it is a send. Were the observers being called, one would have to remember
to change to the new state first, lest an observer interact with the observable before
the internal assignment. Even without concurrency, that worry has the form "what if,
while I'm proceeding with plan X, someone else proceeds with a conflicting plan Y
that messes me up?" The need for such worries makes programming too hard (and makes it
harder for security reviews to check for **TOCTTOU** errors).

The eventual send lets us **isolate conceptually separate plans into separate atomic
turns**, avoiding more cases of **plan interference**. This is the **principle of
chronological encapsulation**.

## Translation to Endo

| E (turns) | Endo / Hardened JavaScript |
|---|---|
| turn (one pending delivery, run to completion) | one JavaScript microtask / one `E()` reaction running to completion |
| atomic serializable micro-transaction | the no-interleaving guarantee a JS turn gives agent code (no locks needed) |
| checkpoint between turns | vat snapshot / transcript boundary (Agoric); orthogonal-persistence point |
| chronological encapsulation | preferring `E(observer).notify()` over a synchronous callback so plans run in separate turns |
| plan interference / TOCTTOU | reentrancy hazards avoided by deferring effects to a later turn |

Source: [elib/concurrency/turns.html](https://erights.github.io/erights-org-website/elib/concurrency/turns.html) (canonical `http://erights.org/elib/concurrency/turns.html`), content SHA-256 `27ef8ef7ad81d3a24ce7839f92e06bde9f2804b87517e6bbed4e874497af6df7`, fetched via the erights.org GitHub Pages mirror.
