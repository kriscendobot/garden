---
title: Abstract
source: "Concurrency Among Strangers (TGC 2005, LNCS 3705)"
source_kind: paper
source_authors: [Mark S. Miller, E. Dean Tribble, Jonathan Shapiro]
source_year: 2005
source_venue: "Trustworthy Global Computing (TGC 2005), Springer LNCS 3705"
source_url: https://papers.agoric.com/assets/pdf/papers/concurrency-among-strangers.pdf
source_pdf_sha256: 4ff0c5bd07e1262f8b2541194214b8a62a05d05fb5b443c44dc8f65cabc85ba5
source_paper_pages: "221-227 (§11 History, §12 Related Work)"
ingested: 2026-05-15
ingested_by: scholar
topics: [capability-theory]
status: current
parent: papers--miller-tribble-shapiro-concurrency-among-strangers-2005--history-and-related-work
---

The paper's history and related-work coda traces E's design lineage through five precursor languages — Smalltalk, Actors, Vulcan, Joule, Original-E — and surveys contemporary distributed-programming systems that share parts of E's model. The lineage is not just citation tracking: each precursor contributed *one specific abstraction* that survived into E, and the §11 narrative names which. Smalltalk gave object references and message passing as the substrate; Actors added asynchronous-only message delivery and the data-flow / control-flow split (futures vs continuations) that E's promises vs when-catch later inherits; Vulcan added concurrent-logic data-flow postponement and named the "merge problem" (clients can only share access to a stateful object by explicit pre-arrangement) that the *Channels* abstraction was designed to solve; Joule (the immediate ancestor) added capability security, channels-as-generalized-promises (with multicasting), tanks (the unit of separate failure / persistence / migration / resource management that E rebrands as **vats**), and the Joule→KeyKOS resource-management model that E does not yet inherit; Original-E added the cryptographic securing of the Joule-style network extension and the sequential-immediate-call / asynchronous-eventual-send mix; E itself contributes the distinct reference *states* (near, eventual, broken) and the transitions among them — exactly the Harel statechart partition the rest of the paper expounds. Related work splits cleanly: §12 surveys systems with overlapping but different goals (MIT Promises and Batched Futures, group-membership / Paxos systems, Croquet and TeaTime), §12.1 surveys systems explicitly influenced by E's concurrency control (Web-Calculus, Oz-E, Twisted Python).
