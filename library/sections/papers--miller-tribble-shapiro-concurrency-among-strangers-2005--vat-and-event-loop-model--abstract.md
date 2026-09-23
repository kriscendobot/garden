---
title: Abstract
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

The paper introduces E's two-primitive concurrency model: **immediate-call** (`.` or *immediate-call operator*) for synchronous in-vat invocation, and **eventual-send** (`<-` or *eventual-send operator*) for asynchronous queue-the-message invocation. Section 5 ("A Taste of E") presents the sequential E statusHolder and the two postponement options ("immediate" vs "eventual"); section 5.2 ("Simple E Execution") defines the **vat** as "a heap of objects + a thread of control + a pending-delivery queue" and characterizes the unit of operation as a **turn** (run a pending delivery to completion, including all immediate-call descendants). Section 6 ("Communicating Event-Loops") extends to multi-vat: **near references** (direct, in-vat) carry both immediate-calls and eventual-sends; **eventual references** carry only eventual-sends and cross vat boundaries; immediate-calling an eventual reference throws an exception. Pending deliveries are serialized on encrypted, order-preserving byte streams between vat pairs. The model achieves **temporal isolation**: a running turn is a sequential call-return program with mutually exclusive access to everything it can synchronously reach. The vat is named as "the minimum unit of persistence, migration, partial failure, resource control, and defense from denial of service." Section 6.1 ("Issues with Event-Loops") notes the constraint cost: no threads or coroutines; recursive algorithms must either complete in one turn or be redesigned (e.g., table-driven parsing); thread-pool patterns adapt to vat granularity instead.

Source: [Concurrency Among Strangers (LNCS 3705)](https://papers.agoric.com/assets/pdf/papers/concurrency-among-strangers.pdf) pages 202-207 (§5 A Taste of E, §6 Communicating Event-Loops); SHA-256 `4ff0c5bd07e1`.
