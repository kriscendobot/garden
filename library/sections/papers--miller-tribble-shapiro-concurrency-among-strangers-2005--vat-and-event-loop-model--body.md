---
title: Body
source: "Concurrency Among Strangers (TGC 2005, LNCS 3705)"
source_kind: paper
source_authors: [Mark S. Miller, E. Dean Tribble, Jonathan Shapiro]
source_year: 2005
source_venue: "Trustworthy Global Computing (TGC 2005), Springer LNCS 3705"
source_url: https://papers.agoric.com/assets/pdf/papers/concurrency-among-strangers.pdf
source_pdf_sha256: 4ff0c5bd07e1262f8b2541194214b8a62a05d05fb5b443c44dc8f65cabc85ba5
ingested: 2026-05-15
ingested_by: scholar
topics: [capability-theory, eventual-send, compartments]
status: current
parent: papers--miller-tribble-shapiro-concurrency-among-strangers-2005--vat-and-event-loop-model
---

### A taste of E: the sequential statusHolder

The same statusHolder, written in E:

```
def makeStatusHolder(var myStatus) {
    def myListeners := [].diverge()
    def statusHolder {
        to addListener(newListener) {
            myListeners.push(newListener)
        }
        to getStatus() { return myStatus }
        to setStatus(newStatus) {
            myStatus := newStatus
            for listener in myListeners {
                listener.statusChanged(newStatus)
            }
        }
    }
    return statusHolder
}
```

The paper notes:

> E has no classes. Instead, the expression beginning with "def statusHolder" is an object definition expression. ... As with Smalltalk or Actors, all values are objects, and all computation proceeds only by delivering messages to objects.

From a λ-calculus perspective, an object-definition expression is a λ that closes over a method-selection-by-message mechanism. This view goes back to Smalltalk-72 and Actors, and is hinted at in Hoare 1965.

### Two ways to postpone plans

When statusHolder is executing plan X and discovers it needs to engage plan Y, there are two options:

> **Immediately:** Put X aside, work on Y until complete, then go back to X.
> **Eventually:** Put Y on a "to-do" list and work on it after X is complete.

The "immediate" option corresponds to conventional call-return control flow (the `.` operator). The "eventual" option queues the item for later execution; E represents it with `<-`:

```
to setStatus(newStatus) {
    myStatus := newStatus
    for listener in myListeners {
        listener <- statusChanged(newStatus)
    }
}
```

Using eventual-send for the notification:

> Errors, new subscriptions, and additional status changes caused by listeners will all take place after all notifications for a published event have been scheduled. Publishers' plans and subscribers' plans are temporally isolated — so these plans may unfold with fewer unintended interactions.

**This is the paper's main move.** The sequential hazards of §3 (aborting the wrong plan, nested subscription, nested publication) vanish because the publisher's plan and each subscriber's plan run in *separate turns*; the publisher finishes its `for`-loop before any listener's `statusChanged` runs.

### Simple E execution: turns, vats, pending deliveries

The paper's *Figure 2* (page 204) shows an E vat: a heap of objects, a thread of control, a *stack* of call frames for immediate-call descendants, and a *queue* of pending deliveries.

> An immediate-call pushes a new frame on top of the stack, representing the delivery of a message (arrow) to a target object (dot). An eventual-send enqueues a new pending delivery on the right end of the queue. The thread proceeds from top to bottom and then from left to right.

Each pending delivery represents the eventual delivery of a particular message to a particular object. The unit:

> This is called a *turn*. When a pending delivery completes, the next one is dequeued, and so forth. This is the classic event-loop model, in which all of the events are pending deliveries. Because each event's turn runs to completion before the next is serviced, they are temporally isolated.

The combined definition:

> The combination of a stack, a pending delivery queue, and the heap of objects they operate on is called a *vat*. ... Each E object lives in exactly one vat and a vat may host many objects. Each vat lives on one machine at a time and a machine may host many vats. **The vat is also the minimum unit of persistence, migration, partial failure, resource control, and defense from denial of service.**

The italicized list defines the vat's role as **the atomic isolation unit** for almost every property a system might want to preserve under failure.

### Communicating event-loops: near and eventual references

When the account manager runs in `VatA` on one machine and the spreadsheet in `VatS` on another:

> A direct reference between two objects in the same vat is a *near reference*. As we have seen, near references carry both immediate-calls and eventual-sends. Only *eventual references* may cross vat boundaries, so the spreadsheet holds an eventual reference to the statusHolder, which in turns holds an eventual reference to the spreadsheet's listener. Eventual references are first class — they can be passed as arguments, returned as results, and stored in data structures, just like near references. However, eventual references carry only eventual-sends, not immediate-calls — an immediate-call on an eventual reference throws an exception.

The paper's *Figure 3* (page 206) traces the five steps of a cross-vat eventual-send:

1. `manager`: `balance.setStatus(33)` — *immediate-call* within `VatA`.
2. `VatA` immediately delivers the message; the statusHolder's `for`-loop runs.
3. Inside that loop, `balance: listener <- statusChanged(33)` — *eventual-send* to a listener in `VatS`. `VatA` enqueues this as a pending delivery destined for `VatS`.
4. `VatA` serializes (marshals) the pending delivery onto an encrypted, order-preserving byte stream read by `VatS`. `VatS` queues it on arrival.
5. `VatS` eventually services the pending delivery, invoking the listener's `statusChanged`, which updates the cell-viewer.

Because *only eventual references span between vats*, the spreadsheet can only affect `VatA` by eventual-sending: "the spreadsheet cannot affect any turn already in progress in `VatA` — `VatA` only queues the pending delivery, and will service it sometime after the current turn and turns for previously queued pending deliveries complete."

### Turn isolation as the fundamental guarantee

The paper formalizes:

> Only near references provide one object synchronous access to another. Therefore an object has synchronous access to state only within its own vat. Taken together, these rules guarantee that a running turn — a sequential call-return program — has mutually exclusive access to everything to which it has synchronous access. In the absence of real-time concerns, this provides all the isolation that was achieved by temporal isolation in the single-threaded case.

The serialization model:

> The net effect is that a turn is E's unit of operation. We can faithfully account for the visible effects of concurrency without any interleaving of the steps within a turn. Any actual multi-vat computation is equivalent to some fully ordered interleaving of turns.

Footnote 5: a turn that never terminates is hard to account for in this simple model of serializability; CL85 (Chandy-Lamport) provides formal models for non-terminating events but is outside the paper's scope.

### No deadlock; the "datalock" trade

> Because E has no explicit locking constructs, computation within a turn can never block — it can only run, to completion or forever. ... Because computation never blocks, it cannot deadlock.

The paper later (§8.3) discusses *datalock*: circular data dependencies that cannot be resolved (e.g., a promise whose resolution depends on itself). Datalock is a form of lost-progress bug, but it manifests reproducibly like a normal program bug rather than the sporadic, hard-to-reproduce way deadlocks manifest. "Anecdotally, in many years of programming in E and E-like languages and a body of experience spread over perhaps 60 programmers and two substantial distributed systems, we know of only two datalock bugs."

### Initial-state notification: the listener-side fix

When the listener can only eventual-send to subscribe, it cannot know the current state at the time it subscribed. The fix is in the statusHolder:

```
to addListener(newListener) {
    myListeners.push(newListener)
    newListener <- statusChanged(myStatus)
}
```

The statusHolder eventual-sends an initial `statusChanged` notification to a new listener so the listener sees an initial valid state.

### Issues with event-loops

The paper acknowledges the cost:

> This architecture imposes some strong constraints on programming (e.g., no threads or coroutines), which can impede certain useful patterns of plan cooperation. In particular, recursive algorithms, such as recursive-descent parsers, must a) happen entirely within a single turn, b) be redesigned (e.g., as a table-driven parser), or c) if it needs external non-prompt input (e.g., a stream from the user), be run in a dedicated vat. E programs have used each of these approaches.

Thread-pool patterns adapt to vat granularity: "different vats would simply run at different processor priorities. For example, if a user-interaction vat *could* proceed (has pending deliveries in its queue), it should; a helper 'background' vat (e.g., spelling check) should consume processor resources only if no user-directed action could proceed." A divide-and-conquer approach for multi-processing runs a vat on each processor.

The model is unsuitable for problems that don't adapt to message-passing — fluid dynamics is the cited example.

Source: [Concurrency Among Strangers (LNCS 3705)](https://papers.agoric.com/assets/pdf/papers/concurrency-among-strangers.pdf) pages 202-207 (§5 A Taste of E, §6 Communicating Event-Loops); SHA-256 `4ff0c5bd07e1`.
