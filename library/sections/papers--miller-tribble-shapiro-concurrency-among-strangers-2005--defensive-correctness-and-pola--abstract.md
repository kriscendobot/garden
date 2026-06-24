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
topics: [capability-theory, capability-security, patterns]
status: current
parent: papers--miller-tribble-shapiro-concurrency-among-strangers-2005--defensive-correctness-and-pola
---

Section 7 introduces the **defensive correctness** and **defensive consistency** properties, then refines the statusHolder example to obey the **Principle of Least Authority (POLA)** by splitting it into a *statusGetter* facet (for subscribers) and a *statusSetter* facet (for publishers). The split is the same forwarder/revoker construction the companion paper [Capability Myths Demolished (2003)](papers--miller-capability-myths-demolished-2003--irrevocability-myth.md) formalizes, applied here to authority management rather than revocation. The section also names the **reliance set / TCB** (Footnote 6) and the relationship `P relies on R`: P's correctness depends on R's correctness, and Q's authority over P is bounded by the *relevant authority* (what Q can actually cause given P's reliance set). Defensive correctness is too strong a target across the Internet (cryptographic protocols support defensive consistency only); the realistic goal is *defensively consistent* — corruption may be possible, but the object will never give incorrect service to well-behaved clients. Section 7.3 ("A Taste of E Across a Network") names E's network protocol, **Pluribus**, which runs between vats and enforces E's reference-integrity properties even between vats running on unsafe languages — at the cost of relying on standard cryptographic assumptions (unguessable large random numbers; non-broken algorithms).

Source: [Concurrency Among Strangers (LNCS 3705)](https://papers.agoric.com/assets/pdf/papers/concurrency-among-strangers.pdf) pages 207-211 (§7 Protection from Misbehavior, §7.1 Defensive Correctness, §7.2 POLA, §7.3 A Taste of E Across a Network); SHA-256 `4ff0c5bd07e1`.
