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
topics: [capability-theory, eventual-send]
status: current
parent: papers--miller-tribble-shapiro-concurrency-among-strangers-2005--abstract-and-introduction
---

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

Source: [Concurrency Among Strangers (LNCS 3705)](https://papers.agoric.com/assets/pdf/papers/concurrency-among-strangers.pdf) pages 195-197 (Abstract, §1 Introduction, §2 Overview); SHA-256 `4ff0c5bd07e1`.
