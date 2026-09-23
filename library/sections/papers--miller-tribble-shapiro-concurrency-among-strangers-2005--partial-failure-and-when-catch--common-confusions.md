---
title: Common confusions
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

- **"A broken reference can be repaired."** No. Broken is a terminal state. References broken by a partition stay broken even after the partition heals. To re-establish connectivity, an offline capability must be re-instantiated as a new live reference; the new reference and the old broken one are *distinct* references.
- **"`_whenBroken` registration is on the broken target."** No. The handler is registered at the **tail end of the reference, within the sending vat**. This is what makes registration survive the broken connection — the registration outlives the partition because it doesn't depend on the broken counterparty's state.
- **"Offline capabilities convey messages."** No. Offline capabilities are pass-by-copy data; they're a *recipe* for re-establishing a live reference. To send a message you make a new live reference from the offline capability and then send through that.
- **"Persistence checkpoints can happen mid-turn."** No. A vat checkpoints only *between turns*, when its stack is empty. This is the architectural reason E's turn boundary serves so many roles (persistence, message-delivery, sequentiality) — they all coincide at the same instant.
