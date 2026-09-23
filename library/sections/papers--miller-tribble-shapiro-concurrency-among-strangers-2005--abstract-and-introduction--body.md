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
parent: papers--miller-tribble-shapiro-concurrency-among-strangers-2005--abstract-and-introduction
---

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

Source: [Concurrency Among Strangers (LNCS 3705)](https://papers.agoric.com/assets/pdf/papers/concurrency-among-strangers.pdf) pages 195-197 (Abstract, §1 Introduction, §2 Overview); SHA-256 `4ff0c5bd07e1`.
