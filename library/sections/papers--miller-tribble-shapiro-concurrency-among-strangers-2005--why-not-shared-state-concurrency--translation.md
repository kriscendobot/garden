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
parent: papers--miller-tribble-shapiro-concurrency-among-strangers-2005--why-not-shared-state-concurrency
---

| Paper idiom | Endo equivalent |
| ----------- | --------------- |
| plan | program / agent / actor (the unit whose internal logic must remain consistent) |
| plan interference | "agent A's action corrupts agent B's invariants"; in Endo, the daemon's turn-isolation prevents this by construction |
| `synchronized` | no Endo equivalent — Endo runs single-threaded per compartment, so there are no locks to hold |
| race condition | also no Endo equivalent — Endo cannot have intra-vat races; cross-vat ordering is FIFO per the paper |
| Multi-Threaded Hell | not applicable in the Endo model; the paper's argument is precisely *why* Endo avoids the hell |

Source: [Concurrency Among Strangers (LNCS 3705)](https://papers.agoric.com/assets/pdf/papers/concurrency-among-strangers.pdf) pages 197-202 (§3 The Sequential StatusHolder, §4 Why Not Shared-State Concurrency); SHA-256 `4ff0c5bd07e1`.
