---
id: e-language
aliases: ["E language", "E programming language", "E (programming language)", "the E language", "E-language", "ERights", "erights.org", "Kernel-E", "E in a Walnut", "ENative", "E grammar", "Original-E"]
topics: [capability-theory, capability-security]
---

# e-language

**E** is Mark S. Miller's object-capability programming language for distributed, secure computation — "Cryptographic Capabilities for Distributed Smart Contracting." E is the canonical first-wave working object-capability language: it introduced the **vat** (heap + thread + pending-delivery queue) as the unit of concurrency, persistence, and partial-failure isolation; **eventual-send** with **promise pipelining**; and a full surface grammar (LALR(1)) defined by expansion to a small **Kernel-E** core. E is the direct lineage ancestor of Endo's `E()` / HandledPromise model and the substrate of the CapDesk / CapMail / Polaris desktop-capability demonstrations. The primary documentation lives at erights.org/elang (reachable via the erights.github.io mirror); the library also holds a secondary-source market-history survey of E's technical success and lack of commercial adoption.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [erights/elang-index/overview](../sections/erights--elang-index--overview.md) | **Primary source.** Mark Miller's own documentation index for E: grammar→Kernel-E expansion, Sameness, primitive types, concurrency/soft-type-checking, historical design goals, tooling (Updoc/Elmer/EBrowser), the ENative project. |
| [ocap-history/market-history](../sections/ocap-history--e-capdesk-polaris-market-history.md) | **Secondary survey.** E (1997), CapDesk, and Polaris as the first wave of working ocap implementations — what each demonstrated technically and why none achieved commercial adoption. |
| [papers/concurrency-among-strangers/history-and-related-work](../sections/papers--miller-tribble-shapiro-concurrency-among-strangers-2005--history-and-related-work.md) | The five-precursor lineage Smalltalk → Actors → Vulcan → Joule → Original-E → E; each precursor's one contributed abstraction. |
| [papers/concurrency-among-strangers/vat-and-event-loop-model](../sections/papers--miller-tribble-shapiro-concurrency-among-strangers-2005--vat-and-event-loop-model.md) | E's vat = heap + thread + pending-delivery queue; near/eventual/broken reference states; the model the elang concurrency docs point at. |

## See also

- [[vat-and-compartment]] — E's vat is the concurrency/persistence unit; Endo's compartment + bundle is the descendant.
- [[promise-pipelining]] — E's eventual-send + message-pipelining, carried forward into Endo's `E()` / HandledPromise.
- [[object-capability]] — the security model E implements; E is one of the canonical Model-4 systems in the Miller-Yee-Shapiro taxonomy.
- [[granovetter-operator]] — the introduction-based connectivity primitive E's reference graph realizes.
