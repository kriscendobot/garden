---
title: Translation block (paper idiom → Endo / Hardened JavaScript surface)
source: "Paradigm Regained: Abstraction Mechanisms for Access Control (ASIAN 2003, LNCS 2896)"
source_kind: paper
source_authors: [Mark S. Miller, Jonathan S. Shapiro]
source_year: 2003
source_venue: "ASIAN 2003, Springer LNCS 2896"
source_url: https://web.archive.org/web/2018/http://erights.org/talks/asian03/paradigm-revised.pdf
source_pdf_sha256: 6053a29e323e4ff49a81645c76f66e9a8ac1ee7b85cda8ab39af1149b90d6cb5
source_paper_pages: "7-14 (§4 The Object-Capability Paradigm, including §4.1 Model, §4.2 A Taste of E, §4.3 Redell's Caretaker, §4.4 Analysis and Blind Spots)"
ingested: 2026-05-21
ingested_by: liaison-direct-draft
topics: [capability-theory, capability-security, patterns]
status: current
parent: papers--miller-shapiro-paradigm-regained-2003--object-capability-model-and-redells-caretaker
---

| Paper concept                              | Endo / Hardened JavaScript equivalent                                                                  |
| ------------------------------------------ | ------------------------------------------------------------------------------------------------------ |
| Object-capability model (lambda + local side effects) | The compartment + exo + lockdown discipline; SES is the substrate that *adds the inabilities* to JS. |
| `loader.load(code, ["x" => x, ...])`       | A compartment's `Compartment(...)` constructor with explicit endowments; or a bundle's compartment-init endowment object. |
| Caretaker pattern (`carol2`, `carol2Rvkr`) | An exo wrapping a target reference; a separate revoker exo holding the assignable variable. The library's `caretaker-pattern` concept. |
| Filtering facet                            | An exo exposing a narrower method surface than the underlying target; the *attenuation* discipline. |
| `var` (mutable variable shared across closures) | Plain JavaScript `let` inside a shared lexical scope. |
| Matcher / `E.call(target, verb, args)`     | Generic `Reflect.apply` on a proxy / membrane; the @endo/exo class with method-name dispatch. |
| Forged pointers, mutable static state (the *inabilities*) | SES lockdown freezes the realm; `harden()` deep-freezes objects; no `globalThis` mutation. |
