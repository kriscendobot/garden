---
title: The MCS algorithm — equivalence test, elimination rule, and MCS p-values
source: "The Model Confidence Set"
source_kind: paper
source_authors: [Peter R. Hansen, Asger Lunde, James M. Nason]
source_year: 2011
source_venue: "Econometrica 79(2):453-497"
source_url: https://doi.org/10.3982/ECTA5771
source_pdf_sha256: c4abc4759af8a10ab68dbca077bafb51db3ad2b7142b280f5151eadddabfed00
ingested: 2026-07-17
ingested_by: scholar
topics: [forecast-evaluation]
status: current
---

Abstract: The MCS is produced by a sequence of significance tests, alternating a single "are the models in this set equally good?" test with a rule that drops the worst survivor. Two ingredients define it: an *equivalence test* `δ_M` for the hypothesis `H0,M : E(L_i,t − L_j,t) = 0 for all i,j ∈ M`, and an *elimination rule* `e_M` that names the model to remove when `H0,M` is rejected. Start with `M = M0`; test at level `α`; if accepted, the current `M` is the confidence set `M̂*_{1−α}`; if rejected, eliminate `e_M` and repeat. The elegant part is the error control: because the sequence *stops at the first acceptance*, the familywise error rate — the probability of wrongly discarding any truly-best model — is bounded by the single test level `α`, so the procedure does not accumulate Type-I error the way naive sequential testing does. Each model also receives an *MCS p-value* (a running maximum of the stage p-values), so a reader can read off, for any confidence level, whether a model is in the set without rerunning the procedure.

Under Assumption 1 the pair `(δ_M, e_M)` must satisfy: (a) asymptotic level of `δ_M` no larger than `α`; (b) asymptotic power one; and (c) a truly-best model `i* ∈ M*` is not the one eliminated as long as inferior models remain in `M`. Theorem 1 then gives the two guarantees that justify the name "confidence set": (i) `liminf P(M* ⊂ M̂*_{1−α}) ≥ 1 − α` (the set covers all best models with the chosen confidence), and (ii) `lim P(i ∈ M̂*_{1−α}) = 0` for every inferior `i` (asymptotically only the best models survive). The reason the FWE is bounded by the level, not inflated by the number of stages, is that in informative data the elimination rule never questions a superior model until every inferior model has already been removed; the first time a best model is even at risk is the test applied to `M*` itself, whose false-rejection probability is the test size. Because the sequence halts on the first *acceptance*, the Leeb-Pötscher worry that sequential testing "accumulates" Type-I errors does not apply. When `M*` is a single model, Corollary 1 sharpens this: that one model is selected with probability `1 − α` asymptotically.

The authors stress a distinction from ordinary model selection: a model is discarded *only if it is found significantly inferior to another model* — "models remain in the MCS until proven inferior." A large MCS is therefore not a failure but an honest report that the data cannot separate the candidates, and not every model in a finite-sample MCS need be a good model. This is the deliberate inversion of an information criterion, which always returns one model regardless of how weakly the data supports the pick.

The MCS p-values make the output easy to consume. Let `P_{H0,Mi}` be the stage p-value at the `i`-th elimination (with the last, single-model stage set to 1). The MCS p-value of the `j`-th eliminated model is `p̂_{eMj} ≡ max_{i ≤ j} P_{H0,Mi}` — the running maximum along the elimination order. Theorem 3 shows the clean consequence: model `i` is in `M̂*_{1−α}` if and only if its MCS p-value `p̂_i ≥ α`, for any `α`. The interpretation parallels a classical p-value against a `(1 − α)` confidence interval: an MCS p-value is *not* the probability that a given model is the best (just as a classical p-value is not the probability the null is true); the probability statement attaches to the random, data-dependent set, which contains `M*` with the stated coverage. Coherency between the test and the elimination rule (the elimination rule must remove a model the test has actually flagged) is what carries Theorem 1's asymptotic guarantee down to finite samples and rules out "absurd combinations" of test and rule.

Source: Hansen, Lunde & Nason 2011, §2 General Theory (Definitions 1-4, the MCS Algorithm, Theorems 1-3, Corollary 1, and MCS p-values), canonical DOI [10.3982/ECTA5771](https://doi.org/10.3982/ECTA5771); readable PDF is the CREATES Research Paper 2010-76 working-paper version [`rp10_76.pdf`](https://repec.econ.au.dk/repec/creates/rp/10/rp10_76.pdf), sha256 `c4abc4759af8`.
