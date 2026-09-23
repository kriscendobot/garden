---
title: Common confusions
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

- **"Vats and Actors are the same."** No. Actors require asynchronous-only messaging; vats add a sequential-immediate-call substrate (near references) that Actors deliberately lack. The §11 narrative makes this explicit: "the asynchronous-only subset of E is an Actors language" — but E itself is more.
- **"Pipelining is an E invention."** No. Pipelining was first invented by Liskov and Shrira (LS88) and improved by Bogle (BL94). E (and now Endo) inherits the technique; its contribution is the *combination* of pipelining with promise multicast (from Joule channels) and broken-reference contagion (E's own addition).
- **"E inherits KeyKOS resource management."** No. §11 names this as an explicit open issue: "Joule's resource management is based on abstractions from KeyKOS. E vats do not yet address this issue." Endo, twenty years later, still does not have a complete story here.
