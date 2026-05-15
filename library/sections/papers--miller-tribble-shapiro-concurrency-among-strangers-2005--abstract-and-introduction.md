---
title: Abstract and Introduction (plan coordination, plan interference, the statusHolder example)
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
---

## Abstract

The paper opens with the framing that programmers write *plans* for machines to execute, and the central problem is **plan coordination**: simultaneously enabling plans to cooperate while avoiding *destructive plan interference*. For sequential single-machine computation, object programming supports plan coordination well — encapsulation limits one plan's ability to disrupt another's assumptions. The paper's thesis is that for **concurrent computation, locking destroys cooperation along with interference**, and the right answer is to change a few concepts of conventional sequential object programming rather than to bolt on locks. Specifically: replace the immediate-call operator with a pair (immediate-call `.` and eventual-send `<-`); replace shared-state concurrency with **communicating event-loops** in *vats*; introduce **promises** for eventual results and **promise pipelining** to tolerate network latency; introduce **broken-reference contagion** and **partial-failure** semantics to handle network partitions; and use the **when-catch** expression to turn data-flow exceptions back into control-flow when needed.

The paper also stakes out the engineering premise that **encapsulation + object programming successes-in-the-small carry over to the large** when the interstitial fabric (the dynamic reference graph that carries messages between objects) is itself engineered. The Hayekian aside (Footnote 1) parallels object encapsulation with *property rights* protecting human plans from interference; "trade brings about their cooperative alignment."

## Body

### The fundamental constraint is complexity

The opening claim:

> The fundamental constraint we face as programmers is complexity. It might seem that we could successfully formulate plans only for systems we can understand. Instead, every day, programmers successfully contribute code towards working systems too complex for anyone to understand *as a whole*. We make use of modularity and abstraction mechanisms to construct systems whose component plans we can understand piecemeal, and whose compositions we can understand without fully understanding each plan being composed.

The Perlis epigraph: "Programmers are not to be measured by their ingenuity and their logic but by the completeness of their case analysis."

### Plans, assumptions, and inconsistency

Plans depend on *assumptions* about future situations. When separately-formulated plans compose, conflicting assumptions can cause the run-time situation to become *inconsistent* with a given plan's assumptions, leading it awry. Object encapsulation limits outside interference and extends the range of assumptions one's program may safely rely upon. Under concurrency, asynchrony and partial failure further limit local knowledge of relevant facts; under confidentiality, knowledge is hidden; under malice, deceit is a further source of interference. Each dimension threatens an explosion of cases.

### Previous papers vs. this paper

> Previous papers have focused on E's support for limited trust within the constraints of distributed systems [MMF00, MYS03, MS03, MTS04]. This paper focuses on E's support for concurrent and distributed programming within the constraints of limited trust.

The companion paper **MYS03 = Capability Myths Demolished (2003)** is already in the library — see [[papers--miller-capability-myths-demolished-2003]]. *Concurrency Among Strangers* (2005) is the natural sequel: cap-myths grounds the security model; this paper grounds the concurrency model that operationalizes it.

### The running example: statusHolder

The paper's running example is a `statusHolder` implementing the **listener pattern** (Eng97):

> A `statusHolder` object is used to coordinate a changing status between *publishers* and *subscribers*. A subscriber can ask for the current status of a `statusHolder` by calling `getStatus`, or can subscribe to receive notifications when the status changes by calling `addListener` with a listener object. A publisher changes the status in a `statusHolder` by calling `setStatus` with the new value. This in turn will call `statusChanged` on all subscribed listeners.

The motivating concrete scenario: a bank account manager publishes an account balance to an analysis spreadsheet and a financial application. Deposits and withdrawals cause a new balance to be published. The spreadsheet updates a display; the finance application initiates trading when the balance falls below a threshold. The three clients (manager, spreadsheet, finance app) interact cooperatively while knowing very little about each other. Footnote 2: the *observer pattern* (GHJV94) is similar, but "the analysis which follows would be quite different if we starting from the observer pattern" — the listener-vs-observer distinction matters for the case analysis.

### The roadmap

The Overview enumerates ten downstream sections, each motivated by one coordination challenge. Numbered for reference:

1. **The Sequential StatusHolder** (§3) — sequential plan-interference hazards exist even with no concurrency: abort-the-wrong-plan, nested subscription, nested publication.
2. **Why Not Shared-state Concurrency** (§4) — searching for a Java thread-safe statusHolder that prevents interference without preventing cooperation; "Multi-Threaded Hell".
3. **A Taste of E** (§5) — the sequential-E statusHolder, plus the *immediate-call vs eventual-send* primitive split (`.` vs `<-`).
4. **Communicating Event-Loops** (§6) — vats, near references, eventual references, turn semantics, distribution.
5. **Protection from Misbehavior** (§7) — defensive correctness, defensive consistency, POLA, the statusGetter/statusSetter split.
6. **Promise Pipelining** (§8) — promises for eventual results; pipelining tolerates latency; broken-promise contagion lets programs handle eventually-thrown exceptions.
7. **Partial Failure** (§9) — partition, broken references, offline capabilities (sturdyrefs), persistence.
8. **The When-Catch Expression** (§10) — turning data-flow back into control-flow; `asyncAnd`.
9. **From Objects to Actors and Back Again** (§11) — Smalltalk → Actors → Vulcan → Joule → Original-E → E.
10. **Related Work** (§12) — group membership / Paxos, Croquet/TeaTime, Web-Calculus, Oz-E, Twisted Python.
11. **Discussion and Conclusions** (§13) — engineering premise and lessons.

## Translation

| Paper idiom | Endo equivalent |
| ----------- | --------------- |
| plan | program (or sub-program / agent) |
| plan coordination | cooperation between agents / programs |
| plan interference | unintended cross-program corruption (race, deadlock, confused-deputy) |
| `<-` (eventual-send operator) | `E(remote).method(args)` and `E.sendOnly` |
| `.` (immediate-call operator) | the normal JS `.` (only valid on near references, i.e., same-compartment objects) |
| vat | compartment + event-loop unit; one Endo agent often = one compartment hosting one vat |
| statusHolder | not directly named in Endo; the closest analogue is a daemon-side handle that vends `subscribe(handler)` to remote consumers |
| listener pattern | observer / subscriber pattern; in Endo this surfaces as `whenBroken` handler registration and `subscribe`-style daemon APIs |

## Implications for Endo

This paper is the upstream root for the **eventual-send / vat / promise-pipelining** triad that Endo's `@endo/eventual-send` package realizes. Endo's API differs in surface (JS function-style `E(remote).foo()` vs E's infix `remote <- foo()`) but is semantically the same: the paper's primitive split (immediate-call vs eventual-send) is the same split JS makes between synchronous `.` and `await E(...)`.

The paper's framing of plan-coordination-as-the-real-problem grounds an Endo design discipline: when designing a daemon-facing API, the question is not "is this thread-safe" but "does this API let independent agents' plans cooperate without forcing them to know about each other's internal state". The `statusHolder` example's translation into Endo would be a daemon-side handle holding a `setStatus` capability + a `subscribe(handler)` capability — the same separation the paper introduces in §7.2 (statusGetter/statusSetter) as a POLA refinement.

The Hayekian aside (Footnote 1) prefigures a recurring theme in Endo / Agoric / OCapN: *encapsulation of authority is to plan coordination what property rights are to human cooperation*. This is the philosophical scaffold for the principle-of-least-authority discipline running through later sections and through the entire Endo lineage.

## See also

- [[eventual-send]] — the topic page collecting Endo API sections about `E()`, `HandledPromise`, and the `<-` semantics this paper introduces.
- [[vat-and-compartment]] — new concept this cycle pinning the paper-side *vat* to Endo's *compartment* + *bundle* isolation unit.
- [[promise-pipelining]] — new concept this cycle covering §8's argument that pipelining is the latency-reducing mechanism at the core of `E()`-chains.
- [[papers--miller-capability-myths-demolished-2003]] — the cited companion paper (MYS03) that grounds the security model this paper's concurrency model operationalizes.

Source: [Concurrency Among Strangers (LNCS 3705)](https://papers.agoric.com/assets/pdf/papers/concurrency-among-strangers.pdf) pages 195-197 (Abstract, §1 Introduction, §2 Overview); SHA-256 `4ff0c5bd07e1`.
