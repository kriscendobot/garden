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
topics: [capability-theory, eventual-send]
status: current
parent: papers--miller-tribble-shapiro-concurrency-among-strangers-2005--why-not-shared-state-concurrency
---

### Even sequential code has plan interference

The Java statusHolder is the textbook listener pattern: `private Object myStatus; private final ArrayList<Listener> myListeners; ... public void setStatus(Object newStatus) { myStatus = newStatus; for (Listener listener : myListeners) listener.statusChanged(newStatus); }`. The paper lists three sequential hazards:

> **Aborting the wrong plan:** If a listener throws an exception, this prevents some other listeners from being notified of the new status and possibly aborts the publisher's plan.
>
> **Nested subscription:** The actions of a listener could cause a new listener to be subscribed. ... Whether that new listener sees the current event, fails to see the current event, or fails to be subscribed depends on minor details of the listener implementation.
>
> **Nested publication:** Similarly, a listener may cause a publisher to publish a new status, possibly unknowingly due to aliasing. ... Some of the listeners would receive the notifications *out of order*. As a result, the spreadsheet might leave the display showing the wrong balance, or worse, the finance application might initiate transactions based on incorrect information.

The paper draws attention to *plans* rather than *programs or processes* precisely because these hazards arise even in a single-threaded program: the publisher's plan and the subscriber's plan interfere through the listener pattern even without genuine concurrency.

### Shared-state concurrency: serializability and mutual exclusion

The paper characterizes a concurrency-control paradigm by two questions:

> **Serializability:** What are the coarsest-grain units of operation, such that we can account for all visible effects of concurrency as equivalent to some fully ordered interleaving of these units?
>
> **Mutual exclusion:** What mechanisms can eliminate the possibility of some interleavings, so as to preclude the hazards associated with them?

For shared-state, the unit is finer than a memory access; the dominant mutual-exclusion mechanisms are **monitors** (Java, Hoa74) and **rendezvous** (Concurrent ML, Ada, π-calculus). Distributed programming uses message-delivery order restrictions instead.

### The fully-synchronized statusHolder deadlocks

Adding `synchronized` to all methods makes the statusHolder act like a monitor. It is "as good at preserving its own consistency as our original sequential statusHolder was." But:

> However, it is generally recommended that Java programmers avoid this fully synchronized pattern because it is prone to deadlock [Eng97]. Although each listener is called from some publisher's thread, its purpose may be to contribute to a plan unfolding in its subscriber's thread. To defend itself against such concurrent entry, the objects at this boundary may themselves be synchronized. If a `statusChanged` notification gets blocked here, waiting on that subscriber's thread, it blocks the statusHolder, as well as any other objects whose locks are held by that publisher's thread. If the subscriber's thread is itself waiting on one of these objects, we have a classic deadly embrace.

### Cloning before notification: avoids deadlock, opens race

Englander's recommended fix is to clone the listener list inside `synchronized` and exit the block before the `for`-loop. This avoids holding a lock during notification but does not avoid the underlying hazard:

> For example, if the account manager holds a lock on the bank account during a withdrawal, a deposit attempt by the finance application thread may result in an equivalent deadlock, with the account manager waiting for the notification of the finance application to complete, and the finance application waiting for the account to unlock.

Worse, races appear:

> If `setStatus` is called from two threads, the order in which they update `myStatus` will be the order they enter the synchronized block above. However, the for-loop notifying listeners of a later status may race ahead of one that will notify them of an earlier status. As a result, even a single subscriber may see updates out of order ...

The further fix (spawning a thread per notification) avoids deadlock but adds new races. The paper:

> But a formerly trivial pattern has now exploded into a case-analysis minefield. Actual systems contain thousands of patterns more complex than the statusHolder. Some of these will suffer from less obvious minefields.

### Multi-Threaded Hell

The paper quotes Bryce "Zooko" Wilcox-O'Hearn's experience report from Mojo Nation:

> This is "Multi-Threaded Hell". As your application evolves, or as different programmers encounter the sporadic and non-reproducible corruption or deadlock bugs, they will add or remove locks around different data structures, causing your code base to veer back and forth ..., erring first on the side of more deadlocking, and then on the side of more corruption. This kind of thrashing is bad for the quality of the code, bad for the forward progress of the project, and bad for morale.

This is the negative-side argument that motivates the rest of the paper: the conventional paradigm cannot reach a consistency-AND-liveness point in the design space, so the paper proposes an alternative paradigm.

### Figure 1 and the safety/progress plane

The paper's *Figure 1* (page 200, conceptual diagram) plots six statusHolders on a (Consistency = safety) × (Progress = liveness) plane:

| # | StatusHolder | Position |
|---|---|---|
| 1 | sequential statusHolder | upper-right (consistent + makes progress, *in single-threaded setting only*) |
| 2 | sequential statusHolder in concurrent environment | upper-left (lacks consistency under concurrency) |
| 3 | fully-synchronized statusHolder | lower-right (consistent but deadlocks; loses progress) |
| 4 | for-loop outside synchronized block (clone the list) | mid-right (some progress, some consistency) |
| 5 | spawning a new thread per listener notification | upper-left-ish (gains progress but loses ordering) |
| 6 | communicating event-loops | upper-right (consistent AND progress) |

Only #6 sits in the "good" corner under concurrency. The paper's claim is that a *different concurrency-control paradigm* — communicating event-loops + eventual-send + promises — gets there.

Source: [Concurrency Among Strangers (LNCS 3705)](https://papers.agoric.com/assets/pdf/papers/concurrency-among-strangers.pdf) pages 197-202 (§3 The Sequential StatusHolder, §4 Why Not Shared-State Concurrency); SHA-256 `4ff0c5bd07e1`.
