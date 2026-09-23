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
topics: [capability-theory, eventual-send]
status: current
parent: papers--miller-tribble-shapiro-concurrency-among-strangers-2005--why-not-shared-state-concurrency
---

The paper builds the case against shared-state concurrency by walking the running `statusHolder` example through Java implementations and surfacing **plan interference** at each level. *Even under sequential, benign conditions*, the unsynchronized statusHolder has three hazards: **aborting the wrong plan** (a misbehaving listener's exception terminates the publisher's plan), **nested subscription** (a listener subscribes during notification; whether the new listener sees the current event depends on minor implementation details), and **nested publication** (a listener calls `setStatus` re-entrantly, and notifications arrive out of order). Adding `synchronized` produces a fully-synchronized statusHolder that's deadlock-prone (any object the listener calls under the held lock must be `synchronized` to defend against re-entry, and the resulting wait-graphs deadlock easily). Cloning the listeners list inside the synchronized block avoids the obvious deadlock but allows newer notifications to race ahead of older ones. Each fix opens new hazards: locks added in one place must be removed elsewhere; "Multi-Threaded Hell" (Zooko Wilcox-O'Hearn's term from the Mojo Nation experience report) names the resulting thrashing between deadlock and corruption. The conclusion is that shared-state concurrency cannot reach the (consistency, liveness) corner of the (safety, progress) plane while a sequential-only example can — the paper's *Figure 1* labels six attempted statusHolders by their position on this plane; only **(6) using communicating event-loops** sits in the desirable corner.

Source: [Concurrency Among Strangers (LNCS 3705)](https://papers.agoric.com/assets/pdf/papers/concurrency-among-strangers.pdf) pages 197-202 (§3 The Sequential StatusHolder, §4 Why Not Shared-State Concurrency); SHA-256 `4ff0c5bd07e1`.
