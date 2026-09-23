---
title: Translation block (paper idiom → Endo / Hardened JavaScript surface)
source: "Paradigm Regained: Abstraction Mechanisms for Access Control (ASIAN 2003, LNCS 2896)"
source_kind: paper
source_authors: [Mark S. Miller, Jonathan S. Shapiro]
source_year: 2003
source_venue: "ASIAN 2003, Springer LNCS 2896"
source_url: https://web.archive.org/web/2018/http://erights.org/talks/asian03/paradigm-revised.pdf
source_pdf_sha256: 6053a29e323e4ff49a81645c76f66e9a8ac1ee7b85cda8ab39af1149b90d6cb5
source_paper_pages: "14-19 (§4.5 Access Abstraction, §5 Confinement, §5.1 Non-Discretionary Model, §5.2 The *-Properties)"
ingested: 2026-05-21
ingested_by: liaison-direct-draft
topics: [capability-theory, capability-security, patterns]
status: current
parent: papers--miller-shapiro-paradigm-regained-2003--access-abstraction-and-confinement
---

| Paper concept                              | Endo / Hardened JavaScript equivalent                                                                  |
| ------------------------------------------ | ------------------------------------------------------------------------------------------------------ |
| Trademark / `FactoryStamp`                 | Endo's @endo/marshal *brand* primitive; @endo/exo class shape declarations. Both implement *type-by-fiat* — the holder of the stamp can mark; the holder of the guard can verify. |
| Factory pattern                            | A bundle's `make*` entry point that constructs sub-exos with attenuated authority. |
| Cassie's `acceptProduct(:Factory)` guard   | Type-guarded exo method on the receiving side; rejects any value not carrying the brand. |
| `loader.load(code, [...endowments])`       | `Compartment(globals, modules, options)` constructor with explicit endowments. The bundle's compartment-init is exactly this pattern. |
| Data diode (`diodeWriter` / `diodeReader`) | A pair of exos exposing complementary `write` and `read` methods sharing closed-over mutable state, with input guards enforcing the data-only invariant. |
| `:int` parameter guard                     | @endo/patterns matcher applied as a method-guard; @endo/exo's interface declaration with shape constraints. |
| "Cassie can verify she is the only state-providing parent" | The Endo bundle endowment discipline: the endowment object is built by the parent at compartment-construction time; the child compartment has no other authority unless the parent's endowment objects re-export. |
