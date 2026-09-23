---
title: Abstract
source: "Concurrency Among Strangers (TGC 2005, LNCS 3705)"
source_kind: paper
source_authors: [Mark S. Miller, E. Dean Tribble, Jonathan Shapiro]
source_year: 2005
source_venue: "Trustworthy Global Computing (TGC 2005), Springer LNCS 3705"
source_url: https://papers.agoric.com/assets/pdf/papers/concurrency-among-strangers.pdf
source_pdf_sha256: 4ff0c5bd07e1262f8b2541194214b8a62a05d05fb5b443c44dc8f65cabc85ba5
source_paper_pages: "215-221 (§9 Partial Failure, §10 The When-Catch Expression)"
ingested: 2026-05-17
ingested_by: liaison-direct-draft
ingested_via: orchestrator-direct-draft (subagent path twice filtered on this content)
topics: [capability-theory, eventual-send, persistence]
status: current
parent: papers--miller-tribble-shapiro-concurrency-among-strangers-2005--partial-failure-and-when-catch
---

§9 extends the reference-state machinery from §7's Harel statechart to handle the realities of distributed execution: networks have outages, machines crash, partitions occur. The mechanism is uniform — a vat-crossing reference *breaks* when the partition between its endpoints is detected, and broken is a terminal state. A handler-registration protocol (`_whenBroken`, `_whenMoreResolved`, `_reactToLostClient`) lets an object register a continuation that will be called when a reference's state next changes; importantly, the handler is registered *within the sending vat*, so the registration outlives the broken connection. Delivery semantics are fail-stop FIFO: messages flow in order until the first failure, then no further delivery occurs on that reference. Reconnection across partition uses **offline capabilities** — the `captp://...` URI string and the encapsulated `SturdyRef` object — which carry the vat's public-key fingerprint, TCP/IP location hints, and an unguessable *swiss number*. Persistence is layered on top: a vat may checkpoint between turns; revival creates a new *incarnation* of the same vat from the persistent state reached by traversal from persistent roots; vat-crossing references stored at checkpoint time are revived as already-broken, which is precisely correct since their counterparties cannot be assumed to have matching state. §10 introduces the **when-catch expression** — the surface syntax `when (promise) -> {...} catch ex {...}` that pairs a "promise resolved" continuation with an exception handler; the worked example `asyncAnd` shows how when-catch composes multiple independent validity checks into one logical conjunction without serializing them. The §10 closing line summarizes the architectural payoff: *"Promise-chaining postpones plans efficiently by data-flow; the 'when-catch' postpones plans until the data needed for control-flow is available."*
