---
title: Dr. SES Architecture and the Q Library (Distributed Resilient Secure EcmaScript; communicating event loops; promises with eventual-send; NodeKen orthogonal persistence)
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
---

## Abstract

§1 frames the central proposal: **Dr. SES (Distributed Resilient Secure EcmaScript)** — the platform-for-eright-and-contract that the Miller-Van Cutsem-Tulloh team is building on JavaScript. The architectural claim: JavaScript provides the *ubiquity* (it is already understood and used by many non-expert programmers) but must be *significantly extended* to address (a) security against script injection — the SES sub-platform freezes intrinsics and confines mobile code; (b) distribution — the Q library extends JavaScript with eventual-send (`!`) and promise combinators across communicating event loops; (c) resilience — the NodeKen platform provides distributed orthogonal persistence (consistent snapshots + reliable messaging) so programs survive crashes and partitions without effort. The §2 sections walk these three layers in turn. §2.3 develops **SES** as the ocap subset of ES5: lexically scoped, encapsulated functions, whitelisted globals (immutable when transitively reachable), `def()` for defensible objects (deep frozen + tamper-proof method records), `confine(exprSrc, endowments)` for safe mobile code, `Nat()` for type-checked natural numbers, `WeakMap` for rights amplification via object-identity-keyed tables. §2.4 develops **Q** with the **eventual-send `!` operator**: `pointP ! getX()` enqueues a `getX` call on `pointP`'s remote event loop. Promises designate either local objects (accessed via `.then`) or remote objects (interacted with via `!`). The Q library provides `Q.race`, `Q.all`, `Q.join`, `Q.passByCopy` as composition combinators. Remote object references use **web-keys** — unguessable HTTPS URLs of the form `https://www.example.com/app/#mhbqcmmva5ja3` — for pass-by-reference encoding over RESTful transport. §2.5 develops **NodeKen**: distributed consistent snapshots (Ken protocol) layered on Node.js, so that *every message ever sent will be delivered in order exactly once* after any sequence of crashes and partitions. The architectural payoff: a Dr. SES programmer writes plain JavaScript with the `!` operator and the system handles security + distribution + resilience for them.

## Body

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

## Translation block (paper idiom → contemporary Endo / Hardened JavaScript surface)

| 2013 Dr. SES concept | Contemporary Endo equivalent |
| -------------------- | ---------------------------- |
| Dr. SES (the platform) | The contemporary **Hardened JavaScript** stack: @endo/init + @endo/ses + lockdown; @endo/eventual-send for Q; @endo/static-module-record / module-source for safe mobile code. |
| SES library (def, confine, Nat, WeakMap) | @endo/ses provides lockdown + harden (= def); @endo/init wires the harden discipline; Compartment(...) (= confine); Nat is a community pattern (Agoric ERTP uses it); WeakMap is ES6 native and frozen by SES. |
| Q library (`!` operator, .then, Q.race, Q.all, Q.join, Q.passByCopy) | @endo/eventual-send provides `E()` (the contemporary spelling of `!`) and the HandledPromise primitive; promise-combinators like Q.race / Q.all are now ES native (`Promise.race`, `Promise.all`); Q.join has no Endo counterpart (the eventual-equality operation is less commonly needed in production). |
| Web-keys (unguessable HTTPS URL with fragment) | Endo's formula identifiers + the OCapN protocol family. The unguessable-fragment pattern is the same; the transport differs from RESTful HTTPS to CapTP-over-various-substrates. |
| NodeKen (Ken + Node.js) | The Endo daemon's formula-graph persistence + ocapn-family CapTP wire protocols. Endo's daemon-persistence enacts the consistent-snapshot discipline; the network-reliable-messaging discipline is the @endo/captp + OCapN layer. |
| `confine(exprSrc, endowments)` | `new Compartment(globals, modules, options).evaluate(source)` is the contemporary spelling. The structural pattern (evaluate in a fresh global environment with explicit endowments) is identical. |
| `def(obj)` | `harden(obj)` is the contemporary spelling. Deep-freeze + tamper-proof method records. |

## Implications for Endo

This section is the **historical-link citation** for the entire contemporary Hardened JavaScript stack. The library can cite this paper whenever a design needs to ground:

1. **The Hardened JavaScript lineage.** Dr. SES → @endo/ses + lockdown. The contemporary stack is the direct successor of the §2 1988 design.
2. **The Q library lineage.** Q → @endo/eventual-send. The `!` operator → `E()`; the HandledPromise primitive is the modern realization.
3. **The OCapN lineage.** Web-keys → formula identifiers; RESTful pass-by-reference → CapTP wire protocols.
4. **The persistence lineage.** Ken → @endo daemon's formula-graph + cycle-47 daemon-persistence design.
5. **The contract-host lineage.** The §6 Contract Host (covered in `escrow-exchange-and-contract-host`) → Agoric Zoe contract framework.

The library's existing `vat-and-compartment` concept page anchors the structural-isolation primitive; this section is the *JavaScript-implementation* citation for that primitive's contemporary realization. The library's `smart-contract` concept page now has a clear lineage anchor between the 2000 paper's E-language smart contracts and Agoric Zoe's JavaScript contracts.

## See also

- [[vat-and-compartment]] — the structural-isolation primitive. Dr. SES compartments are the JavaScript realization; the concept page now spans both vintages.
- [[principle-of-least-authority]] — POLA at the SES whitelisted-globals layer is the architectural enforcement.
- [[brand-and-trademark]] — WeakMap in SES is the rights-amplification primitive; ES6 native, frozen by lockdown.
- [[smart-contract]] — §6 Contract Host is the smart-contract layer this paper develops. The cycle-77 concept page now has the Dr. SES lineage anchor.
- [[mint-purse-money]] — §4 makeMint code in §4 of this paper is the JavaScript realization of the 2000 mint-purse pattern.
- [[promise-pipelining]] — Q's `!` and promise combinators are the substrate that makes pipelining possible in JavaScript.
- `papers--miller-tribble-shapiro-concurrency-among-strangers-2005--partial-failure-and-when-catch` — the 2005 paper's offline-capabilities + vat-checkpoint machinery is the structural ancestor of NodeKen.
- `papers--miller-morningstar-frantz-capability-based-financial-instruments-2000--mint-purse-money-and-six-security-properties` — the 2000 paper's mint-purse example reappears in §4 of this paper, in JavaScript.

## Common confusions

- **"Dr. SES is Agoric."** Closer to *Dr. SES → @endo + Agoric lineage*. The Dr. SES platform proposal (2013) became the contemporary @endo / Hardened JavaScript stack (lockdown + harden + Compartment + eventual-send + marshal + captp); Agoric is the company building on this stack at the contract-execution + value-transfer layer. Dr. SES is the platform; Agoric is one production deployment.
- **"NodeKen exists."** Not as of the 2013 paper. The team was working on integrating Ken with v8 (`supergillis/v8-ken`). The contemporary realization is the Endo daemon's formula-graph persistence + OCapN messaging — structurally equivalent properties but realized through different machinery.
- **"`!` is the same as `await`."** No — `!` is *eventual-send* (an operation), not *await* (a control-flow primitive). `p ! m(x)` enqueues a method call on `p`'s event loop and returns a promise; it does *not* suspend the current code. The modern Endo equivalent is `E(p).m(x)` which returns a promise; you can `await` that promise *separately* in an async function. The eventual-send is the operation; the await is the suspension.
- **"Web-keys are cryptographic capabilities."** The unguessable-fragment is *structurally* a capability (you can only learn it by being told); it is not *cryptographically* unforgeable. Web-keys depend on TLS for confidentiality in transit and on the URL-fragment-is-not-sent-to-the-server property for confidentiality at the server. The contemporary CapTP wire protocol uses cryptographic-key pairs at the substrate.
- **"Dr. SES requires ES7."** The paper uses two ES6/ES7 conveniences (arrow functions and `!`) but works in ES5 underneath. Modern Hardened JavaScript runs on modern engines; the architectural argument is independent of any specific ES version.
