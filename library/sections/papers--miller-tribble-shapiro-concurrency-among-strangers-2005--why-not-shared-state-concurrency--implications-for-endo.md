---
title: Implications for Endo
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

The Endo model **does not have any of the hazards in this section** by construction:

- **Aborting the wrong plan** does not happen across vat boundaries: an eventual-send to a listener cannot interrupt the publisher's plan; it queues a new turn on the listener's vat. The listener's exception breaks the *promise*, not the publisher's stack.
- **Nested subscription** does not happen because `addListener` from inside `statusChanged` would be an eventual-send back to the statusHolder's vat, which executes in a later turn (not re-entrantly).
- **Nested publication** likewise: `setStatus` from inside `statusChanged` queues a later turn rather than re-entering the publisher's loop.
- **Deadlock** is structurally impossible: no Endo vat blocks on a synchronous call from outside; cross-vat communication is via eventual-send only.
- **Race conditions** between near references do not exist (turn-isolation); cross-vat ordering is FIFO per pair of vats, which the paper notes is "stronger than FIFO and weaker than Causal, but FIFO is adequate for all points we make in this paper" (Footnote 9).

This is why Endo's daemon-side handles can be designed without locks, without `volatile`, without `synchronized`, without any of the thread-safety machinery that dominates Java daemon code: the *isolation* is structural, not disciplined.

The paper's *Figure 1* is a useful frame when explaining to a newcomer why Endo's `E()`-based API is what it is: it occupies the same corner Java cannot reach because Java does not have first-class turn-isolation.

Source: [Concurrency Among Strangers (LNCS 3705)](https://papers.agoric.com/assets/pdf/papers/concurrency-among-strangers.pdf) pages 197-202 (§3 The Sequential StatusHolder, §4 Why Not Shared-State Concurrency); SHA-256 `4ff0c5bd07e1`.
