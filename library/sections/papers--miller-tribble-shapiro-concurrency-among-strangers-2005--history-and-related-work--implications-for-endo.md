---
title: Implications for Endo
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

The history-and-related-work section is the library's **lineage anchor** for the Endo stack. When a future designer needs to cite where eventual-send came from, where vats came from, where pipelining was first published, or where the secure cryptographic-capability network extension was first realized in practice, this section is the answer. Of particular note for Endo:

- **Joule → E vat** is the direct lineage that Endo's compartment / bundle isolation extends. The [[vat-and-compartment]] concept page (still to be written) anchors the translation; this section is the historical anchor.
- **LS88 → BL94 → Udanax → E → Endo** is the promise-pipelining lineage. Endo's `E(E(x).foo()).bar()` reduction in `handled-promise.js` is the JavaScript enactment of the same pattern Liskov and Shrira published in 1988 and that Bogle's "Batched Futures" (BL94) significantly improved upon.
- **KeyKOS resource management** is the open issue named in §11 (and inherited from Joule) that E and Endo still do not address; this is a *gap* for future Endo work to consider.
