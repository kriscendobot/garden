---
title: Translation
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

| Paper idiom | Endo equivalent |
| ----------- | --------------- |
| vat | Endo's *compartment + bundle + event-loop* unit. An Endo agent runs as one compartment hosting one async event loop, which serves the role of a vat. |
| heap of objects | the compartment's object graph |
| pending delivery queue | the JS host's microtask + task queues plus the daemon's cross-agent message queue |
| turn | "promise reaction" or "microtask" in JS terminology; in Endo this is one synchronous run-to-completion of a queued reaction |
| near reference | an in-compartment object reference (normal JS `.`) |
| eventual reference | a reference reached via `E()` — supports `E(remote).foo()` but not `remote.foo()` |
| `<-` (eventual-send) | `E(remote).foo(args)` returns a promise; `E.sendOnly` is the fire-and-forget form |
| `.` (immediate-call) | the normal JS `.` (only valid on near references) |
| `def x { to foo() { ... } }` | a JS object literal with a method, or an `exo` defined by `defineExoClass({ foo() { ... } })` |
| machine | host (one OS process); a machine can host many vats / compartments |

Source: [Concurrency Among Strangers (LNCS 3705)](https://papers.agoric.com/assets/pdf/papers/concurrency-among-strangers.pdf) pages 202-207 (§5 A Taste of E, §6 Communicating Event-Loops); SHA-256 `4ff0c5bd07e1`.
