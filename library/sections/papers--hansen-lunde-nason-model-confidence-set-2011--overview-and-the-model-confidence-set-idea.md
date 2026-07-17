---
title: The model confidence set idea and how it differs from picking one winner
source: "The Model Confidence Set"
source_kind: paper
source_authors: [Peter R. Hansen, Asger Lunde, James M. Nason]
source_year: 2011
source_venue: "Econometrica 79(2):453-497"
source_url: https://doi.org/10.3982/ECTA5771
source_pdf_sha256: c4abc4759af8a10ab68dbca077bafb51db3ad2b7142b280f5151eadddabfed00
ingested: 2026-07-17
ingested_by: scholar
topics: [financial-forecasting, forecast-evaluation]
status: current
---

Abstract: The Model Confidence Set is the answer to a different question than pairwise Diebold-Mariano or best-of-N Reality Check/SPA ask. Those ask "are these two forecasts equally accurate?" or "does the best searched model beat this benchmark?"; the MCS asks "which models can I not distinguish from the best, given how informative this data is?" and returns a *set* of models, `M*`, that contains the best model(s) with a chosen confidence level `1 − α`. The set is analogous to a confidence interval for a parameter: informative data yields a small MCS (few models survive), uninformative data yields a large MCS (many or all models survive), so the size of the set itself reports how much the data can say. The procedure needs no benchmark and makes no assumption that any candidate is the true model, and it explicitly allows more than one model to be best. It is a general loss-based comparison, so what the MCS speaks to is fixed by the loss it is run on, not by the procedure.

The paper introduces the MCS for the situation econometricians routinely face: several models or methods are available for one empirical problem, and "which is the best?" is a question most data cannot answer unequivocally when the set of alternatives is large. Rather than force a single choice, the MCS reduces the initial collection `M0` to a smaller data-dependent set `M̂*` that contains the best model(s) with a given probability, in the same sense that a confidence interval covers a population parameter.

Each object `i` is scored by a user-specified loss `L_i,t` (for a point forecast `Ŷ_i,t` of `Y_t`, `L_i,t = L(Y_t, Ŷ_i,t)`). The set of superior objects is `M* ≡ {i ∈ M0 : E(L_i,t − L_j,t) ≤ 0 for all j ∈ M0}` — the models no other model beats in expected loss. The MCS is any subset of `M0` that contains all of `M*` with at least its coverage probability. Two properties distinguish the MCS from ordinary model-selection criteria. First, it acknowledges the limits of the data: less informative data makes models hard to tell apart and returns a larger set, whereas a criterion like AIC or BIC picks one model regardless of how weakly the data supports that choice. Second, it makes significance statements that are valid in the traditional sense, which reporting a table of pairwise p-values does not. Because it can return several models, "if more than one model lands in the MCS, prefer the simplest" is the natural operating rule.

The MCS is silent about anything outside `M0`: it is specific to the candidate set, exactly as a Reality Check or an SPA test is specific to the alternatives searched. It also inherits the object-agnosticism of the loss-differential machinery it is built on — it can compare forecasts, in-sample regression models under a likelihood criterion, or "more general objects, beyond the comparison of models." That generality is why the risk-forecast-versus-directional distinction still has to be tracked at the loss: an MCS run on a variance loss (QLIKE, hMSE) is a statement about relative conditional-volatility and risk-forecast quality, while an MCS run on a squared-return or directional loss is a statement about mean or directional quality. The procedure does not convert one into the other.

Source: Hansen, Lunde & Nason 2011, abstract and introduction (§1), canonical DOI [10.3982/ECTA5771](https://doi.org/10.3982/ECTA5771); readable PDF is the CREATES Research Paper 2010-76 working-paper version [`rp10_76.pdf`](https://repec.econ.au.dk/repec/creates/rp/10/rp10_76.pdf), sha256 `c4abc4759af8`.
