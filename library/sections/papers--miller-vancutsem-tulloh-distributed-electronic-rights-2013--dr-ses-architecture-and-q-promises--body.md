---
title: Body
source: "Distributed Electronic Rights in JavaScript (ESOP 2013, Springer LNCS 7792)"
source_kind: paper
source_authors: [Mark S. Miller, Tom Van Cutsem, Bill Tulloh]
source_year: 2013
source_venue: "ESOP 2013, Springer LNCS 7792, pp. 1-20"
source_url: https://papers.agoric.com/papers/distributed-electronic-rights-in-javascript/abstract/
source_pdf_sha256: 061ab339fb204ad2d609ce44130146bf9cb0897bf7c6d9e21248cac412454593
source_paper_pages: "1-10 (§1 Smart Contracts for the Rest of Us; §2 Dr. SES with §2.1-§2.5)"
ingested: 2026-05-30
ingested_by: liaison-direct-draft
topics: [capability-security, eventual-send, captp, persistence]
status: current
parent: papers--miller-vancutsem-tulloh-distributed-electronic-rights-2013--dr-ses-architecture-and-q-promises
---

### §2.1-§2.2 Just enough JavaScript and the basic concepts

§2.1 introduces two ES6 syntactic conveniences the paper depends on: **arrow functions** (`n => n+n`) and the **eventual-send operator** `!` (proposed for ES7). The paper uses ES5 underneath; expanding away these conveniences would give working ES5 code.

§2.2 frames Dr. SES at a high level for non-expert programmers — three things you don't worry about:

- **SES.** Don't worry about script injection. Mobile code can't do anything it isn't authorized to do. Functions and objects are encapsulated. Objects can invoke objects they have a reference to, but cannot tamper with those objects.
- **Q.** Don't worry about memory races or deadlocks; they can't happen. Objects can be local or remote. The familiar infix dot (`pt.getX()`) accesses the `pt` object *immediately*. Q adds the bang `!` (`pt ! getX()`) to access an object *eventually*. Anywhere you can write a dot, you can use `!`. Eventual operations return promises for what the answer will be. If the object is remote or a promise, you can only use `!` on it.
- **NodeKen.** Don't worry about network partitions or machine crashes. Once the machine comes back up, everything keeps going, so a crash and restart is just a very long (possibly infinite) pause. Likewise, a partitioned network is just a slow network waiting to heal. Once things come back up, every message ever sent will be delivered in order exactly once.

The §2.2 closing observation: *understanding these risks does require a careful reading of the following sections* — the simplifications above are correct only when things go well, and much of the point of erights and smart contracts is to limit the damage when things go badly.

### §2.3 SES — securing JavaScript

§2.3 develops SES as the **ocap subset of ES5**. The §2.3 paper makes four structural claims:

- **Lexically scoped, encapsulated functions.** Lexical scope means free variables in a function are bound at definition site, not call site; encapsulation means an object's properties are not accessible from outside without explicit consent.
- **Whitelisted globals.** Only globals on the whitelist (including all globals defined by ES5) are accessible. Those globals are unassignable, and all objects transitively reachable from them are immutable, *rendering all implicit access powerless*. This is the language-level enforcement of *only connectivity begets connectivity*.
- **Defensive consistency support.** A formal-semantics-supported automated verification of some security properties of SES code [Mettler PhD 2012 cited].
- **Powerless objects.** Under SES rules, granted references are the *sole* representation of permission. An object must not be given any powerful references by default; any references it has implicit access to (such as language-provided global variables) must be powerless.

The §2.3 paper introduces five SES library functions the rest of the paper uses:

```
def(obj)         // returns a *def*ensible object — deep-frozen + tamper-proof methods
confine(exprSrc, // safe mobile-code evaluator — runs source in a new global
        endowments) //   environment of whitelisted globals + endowments
Nat(allegedNumber) // tests for non-negative-integer-within-safe-range; throws or returns
WeakMap()        // ES6 extension; rights amplification via object-identity-keyed table
```

The `def()` function is the operational form of *making defensively consistent objects*: deep-freezes properties so they are read-only, freezes all transitively reachable subobjects, making the resulting object effectively tamper-proof.

`confine()` is the operational form of the 2003 *Paradigm Regained* Cassie-confining-Max factory pattern at the language level: take a source string + endowments record, evaluate the expression in a fresh global environment containing only the SES whitelisted globals + the endowments. The 2013 paper's `confine('x + y', {x: 3, y: 6})` returns 9.

`WeakMap` is the ES6 primitive that provides **rights amplification** (the 2000 paper's §3.3 sealer/unsealer primitive in modern JavaScript form). A WeakMap is an object-identity-keyed table; only the holder of the WeakMap can map an object to a stored value. The §3.4 mint-purse code (in this paper's §4) uses WeakMap to implement the same-currency check that the 2000 paper's `unsealer unseal(src getDecr)(amount)` achieves.

### §2.4 Q — distributed JavaScript objects

§2.4 develops **Q** as the library that extends JavaScript with communicating-event-loop primitives. The §2.4 paper distinguishes three sub-concepts:

**Communicating event-loop concurrency.** JavaScript's de-facto concurrency model is *shared-nothing communicating event loops*. The processing of a single event is a *turn* of the event loop; turns are the smallest unit of interleaving. A system of communicating event loops consists of multiple event loops (in the same or distributed address spaces) that communicate solely by means of asynchronous message passing. Web Workers + Node.js + browser-frame interaction are existing JavaScript enactments.

**Promises.** A promise represents both the outcome of an asynchronous operation and a remote reference. A promise may be:

- **Pending.** Not yet determined what the promise designates.
- **Resolved.**
  - **Fulfilled.** Resolved to successfully designate some object.
  - **Rejected.** Will never designate an object, for an alleged reason represented by an associated error.

`Q(target)` returns a promise for `target` (or `target` itself if it's already a promise). `Q.promise((resolve, reject) => ...)` returns a fresh pending promise + the resolution functions. `.then(onFulfilled, onRejected)` registers callbacks to be called in a later turn after the promise resolves.

**The Q combinators**:

- `Q.race(answerPs)` — returns a promise for the resolution of whichever promise resolves first.
- `Q.all(answerPs)` — returns a promise for an array of fulfilled values; ready when *all* resolve fulfilled; rejected when *any* rejects.
- `Q.join(xP, yP)` — eventual equality operation. If both resolve to the same target, the joined promise is fulfilled with that target. Otherwise rejected.
- `Q.passByCopy(record)` — overrides the pass-by-reference default for a record, marking it as pass-by-copy.

The §2.4 closing paper develops the **`!` eventual-send operator**:

| Immediate syntax | Eventual syntax | Expansion |
| `p.m(x, y)` | `p ! m(x, y)` | `Q(p).send("m", x, y)` |
| `p(x, y)` | `p ! (x, y)` | `Q(p).fcall(x, y)` |
| `p.m` | `p ! m` | `Q(p).get("m")` |

Anywhere a dot operator works, the `!` operator works. The semantic difference: dot is *immediate* (synchronous, within the current turn); `!` is *eventual* (asynchronous, returns a promise resolved in a later turn).

**Web-keys.** Remote object references over RESTful transport use **unguessable HTTPS URLs** of the form `https://www.example.com/app/#mhbqcmmva5ja3`. The fragment after `#` is a random unguessable string. The paper notes: *we use unguessable secrets for remote object references because of a key similarity between secrets and object references — if you do not know an unguessable secret, you can only come to know it if somebody else who knows the secret chooses to share it with you*. This is the 2000 paper's swiss-number framing applied at the URL level.

### §2.5 NodeKen — distributed orthogonal persistence

§2.5 develops the resilience layer. **Rights, to be useful, must persist over time** — since object references are the representation of rights, object references and the objects they designate must persist.

Dr. SES builds upon the **Ken platform** [Yoo et al. USENIX ATC 2012]. Ken applications are distributed communicating event loops aligned with JavaScript's de-facto execution model. Ken provides:

- **Distributed consistent snapshots.** Ken provides a persistent heap for storing application data; all objects stored in this heap are persistent; Ken ensures snapshots of two or more communicating processes cannot grow inconsistent, by recording messages in flight as part of a process's snapshot.
- **Reliable messaging.** Under the assumption that all Ken processes eventually recover, *all messages transmitted between Ken processes are delivered exactly once, in FIFO order*.

The §2.5 paper details the Ken algorithm:

> Ken achieves distributed consistent snapshots as follows:
>
> - During a turn, accumulate all outgoing messages in an outgoing message queue. These messages are not yet released to the network.
> - At the end of each turn, make an (incremental) checkpoint of the persistent heap and of all outgoing messages.
> - After the end-of-turn checkpoint is made, release any new outgoing messages to the network and acknowledge the incoming message processed by this turn.
> - Number outgoing messages with a sequence number (for duplicate detection and message ordering).
> - Periodically retry sending unacknowledged outgoing messages (with exponential back-off) until an acknowledgement is received.
> - Check incoming messages for duplicates. When a duplicate message is detected, it is dropped (not processed) and immediately acknowledged.

The key invariant: outgoing messages are released, and incoming messages are acknowledged, *only after the message has been fully processed by the receiver and the heap state has been checkpointed*. The snapshot of a Ken process consists of both the heap and the outgoing message queue. It does *not* include the runtime stack (which is always empty between turns) nor the incoming message queue.

**NodeKen** is the integration of Ken with Node.js — at the time of paper writing, NodeKen *does not yet exist*; the team was working on integrating Ken with the v8 JavaScript VM (https://github.com/supergillis/v8-ken). The §2.5 paper distinguishes two types of Dr. SES environments: *ephemeral* (Dr. SES in the browser, ceases to exist when the user navigates away or closes the page) and *persistent* (Dr. SES on NodeKen, JavaScript objects born in such an environment are persistent by default). Following the Waterken philosophy, ephemeral and persistent environments are expected to communicate; the ephemeral environment handles UI; the persistent environment stores durable application state. A distributed form of the Model-View-Controller pattern.
