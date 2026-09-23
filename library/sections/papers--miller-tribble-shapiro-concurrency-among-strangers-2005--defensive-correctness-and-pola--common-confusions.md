---
title: Common confusions
source: "Concurrency Among Strangers (TGC 2005, LNCS 3705)"
source_kind: paper
source_authors: [Mark S. Miller, E. Dean Tribble, Jonathan Shapiro]
source_year: 2005
source_venue: "Trustworthy Global Computing (TGC 2005), Springer LNCS 3705"
source_url: https://papers.agoric.com/assets/pdf/papers/concurrency-among-strangers.pdf
source_pdf_sha256: 4ff0c5bd07e1262f8b2541194214b8a62a05d05fb5b443c44dc8f65cabc85ba5
ingested: 2026-05-15
ingested_by: scholar
topics: [capability-theory, capability-security, patterns]
status: current
parent: papers--miller-tribble-shapiro-concurrency-among-strangers-2005--defensive-correctness-and-pola
---

- **"POLA is the same as least privilege."** Closely related but not identical. The paper (and Miller's MS03) argues POLA is about *authority* (the set of effects one can cause via composition through one's reachable capabilities), while least privilege is about *privilege* (the set of operations one is directly authorized to perform). The distinction matters when authority composes through delegates: an agent with read access to a delegate that has write access has *authority* to write (transitively) but no direct *privilege* to write. POLA budgets the transitive authority; least-privilege budgets the direct privilege.
- **"Defensive correctness == bug-free."** No. Defensive correctness means *no client can drive the program away from its specification*. It says nothing about whether the program meets its specification under benign conditions. A defensively-correct program with a bug is still buggy; the property only constrains *who can cause* misbehavior.
- **"Pluribus and CapTP are the same protocol."** Pluribus is the E-era inter-vat protocol; CapTP is the more recent capability-transport-protocol used in OCapN. They are in the same lineage (both enforce reference-integrity over the network using cryptographic unguessability) but are distinct specifications. Pluribus is mostly of historical interest; CapTP and the OCapN-family protocol are what Endo / Agoric use today.

Source: [Concurrency Among Strangers (LNCS 3705)](https://papers.agoric.com/assets/pdf/papers/concurrency-among-strangers.pdf) pages 207-211 (§7 Protection from Misbehavior, §7.1 Defensive Correctness, §7.2 POLA, §7.3 A Taste of E Across a Network); SHA-256 `4ff0c5bd07e1`.
