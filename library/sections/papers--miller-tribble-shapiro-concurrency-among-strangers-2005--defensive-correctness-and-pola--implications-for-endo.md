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
topics: [capability-theory, capability-security, patterns]
status: current
parent: papers--miller-tribble-shapiro-concurrency-among-strangers-2005--defensive-correctness-and-pola
---

The §7.2 statusGetter/statusSetter split is the **canonical small-example POLA construction**. Endo's `defineExoClassKit` is the API form: defining several facets that share state but expose disjoint method sets is exactly what `makeStatusPair` does in this paper. Whenever an Endo design discusses "splitting the authority into a HandleControl + Handle pair" (delegates and epithets) or "returning [reader, writer]" or "having the daemon retain the credential while vending the action facet to the agent", it is doing this section's construction.

The **defensive consistency vs defensive correctness** distinction is the right framing for many Endo daemon designs. The daemon supports defensive consistency for its clients (an agent cannot corrupt another agent's view of its own state by misbehaving); it cannot support defensive correctness because any agent can monopolize a turn and prevent the daemon from servicing others. Endo's resource-management work is precisely about *converting same-vat mutual-reliance into something closer to mutual independence* by limiting how much CPU/memory one compartment can consume.

The **Pluribus / unguessable-large-numbers** assumption is what Endo's *formula identifier* unguessability rides on. The 256-bit-or-larger random formula key is the cap-talk-era *swiss number* generalized to the formula graph; if the paper's assumption breaks (large random numbers become guessable), Endo's whole capability model breaks at the same point E's does. This is a *shared* cryptographic foundation, not an Endo-specific risk.

The **reliance-set / TCB-minimization** vocabulary is the upstream of Endo's design discipline that the daemon should be **the smallest reliance set possible** for the agents it hosts. Each new daemon feature is a candidate for the TCB; the question is "what fraction of agents' correctness now depends on this code". Designs like [[TCB-minimization-via-revocation]] (still a deferred concept page) build on this framing.

Source: [Concurrency Among Strangers (LNCS 3705)](https://papers.agoric.com/assets/pdf/papers/concurrency-among-strangers.pdf) pages 207-211 (§7 Protection from Misbehavior, §7.1 Defensive Correctness, §7.2 POLA, §7.3 A Taste of E Across a Network); SHA-256 `4ff0c5bd07e1`.
