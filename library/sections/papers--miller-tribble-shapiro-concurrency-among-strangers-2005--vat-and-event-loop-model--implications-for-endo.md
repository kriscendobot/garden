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
topics: [capability-theory, eventual-send, compartments]
status: current
parent: papers--miller-tribble-shapiro-concurrency-among-strangers-2005--vat-and-event-loop-model
---

The paper's vat definition is the **upstream of Endo's compartment-as-isolation-unit**. Endo refines the model with:

1. **Bundles** as the deployable unit (a compartment is instantiated from a bundle; the bundle is the disk-persisted recipe).
2. **The Endo daemon as a host of multiple bundle/compartment pairs**, with the daemon process owning the cross-vat encrypted message stream (E's "Pluribus" protocol; Endo's [[captp]] / OCapN successor).
3. **Formula-graph persistence**: vats in E persisted via traversal from persistent roots (§9.3); Endo persists *construction* (formulas) rather than *state* (heap snapshots). This is a *substantive divergence* from the paper, worth its own concept page; see [[formula-graph]] for the Endo design and [[formula-persistence-thesis]] for why Endo chose this path.
4. **Per-agent keypairs** (Endo) rather than per-vat keypairs (paper §9.3) — an Endo agent's identity is finer-grained than an E vat's, because Endo supports multiple agents per daemon.

The §6 "constraints on programming" — no threads, no coroutines — translate cleanly to Endo: JS's single-threaded execution model already enforces this. The "redesign recursive parsers as table-driven" advice maps to JS's "generator + iterator" or "promise chain" idioms.

The "vat as minimum unit of resource control and defense from denial of service" claim is the upstream of Endo's *meter* and *resource-management* designs. An Endo daemon's metering operates at the compartment boundary, not below it, for the same reason the paper says E's resource control operates at the vat boundary.

Source: [Concurrency Among Strangers (LNCS 3705)](https://papers.agoric.com/assets/pdf/papers/concurrency-among-strangers.pdf) pages 202-207 (§5 A Taste of E, §6 Communicating Event-Loops); SHA-256 `4ff0c5bd07e1`.
