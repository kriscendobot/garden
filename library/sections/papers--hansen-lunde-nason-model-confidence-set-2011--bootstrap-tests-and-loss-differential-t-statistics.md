---
title: Bootstrap implementation — loss-differential t-statistics, the range and max statistics
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

Abstract: The feasible MCS is built on exactly the loss-differential t-statistic that Diebold-Mariano and West use, extended from a pair to a whole set. Define relative performance variables `d_ij,t = L_i,t − L_j,t` for every pair, form the standardized `t_ij = d̄_ij / sqrt(v̂ar(d̄_ij))` (this is precisely the two-forecast DM/West statistic) and the model-versus-average `t_i· = d̄_i· / sqrt(v̂ar(d̄_i·))`, and combine them into one of two equivalence-test statistics for `H0,M`: the *range* statistic `T_R = max_{i,j} |t_ij|` or the *max* statistic `T_max = max_i t_i·`. Their null distributions are non-standard (they depend on the unknown correlation of the loss differentials), so the paper obtains critical values and p-values by a *block bootstrap* over the loss-differential series, which implicitly handles that nuisance-correlation problem. Each statistic pairs with a coherent elimination rule that removes the model contributing most to the rejection — the model with the largest standardized excess loss relative to the set average. This is the concrete machinery a practitioner runs; it is the pairwise DM test wrapped in a search-aware sequential procedure.

Assumption 2 places the regularity conditions on the *relative performance variables* `{d_ij,t}`, not on the raw losses: for some `r > 2`, `E|d_ij,t|^{r+γ} < ∞`, and `{d_ij,t}` is strictly stationary with positive variance and `α`-mixing at the stated rate. Crucially the losses `{L_i,t}` themselves need not be stationary — a non-stationary loss level is fine as long as all models are affected similarly so the *differences* stay stationary, which accommodates some structural breaks. This is the same "work on the differential, not the level" move that makes DM loss-agnostic.

The `t`-statistic route (rather than a quadratic-form statistic) has two advantages the authors highlight: it avoids having to estimate and invert the full covariance matrix of the contrasts, and it makes the coherent elimination rule easy to state. The equivalences `μ_{i1} = ⋯ = μ_{im} ⇔ μ_ij = 0 for all i,j ⇔ μ_i· = 0 for all i` let the same hypothesis `H0,M` be tested through either `T_R` (built from pairwise `t_ij`) or `T_max` (built from `t_i·`). For `T_max` the natural elimination rule is `e_{max,M} = argmax_i t_i·` (drop the model whose standardized loss most exceeds the set average); for `T_R`, `e_{R,M} = argmax_i sup_j t_ij`. Proposition 1 shows both test-plus-rule combinations are *coherent* in the sense §2 requires, and Theorem 4 gives the limit theory: under `H0,M`, `T_max` converges to the distribution of the maximum of a correlated Gaussian vector `N(0, ϱ)`, and under the alternative it diverges while the eliminated model is an inferior one. Because that limit depends on the correlation matrix `ϱ`, a plug-in critical value is unavailable, but the bootstrap consistently estimates the required quantile — the same device White (2000), Hansen (2005), and others use for the Reality Check and SPA nuisance-parameter problems. A companion web appendix (Hansen, Lunde & Nason 2010) gives the detailed block-bootstrap resampling scheme.

A separate branch (§3.2) constructs the MCS for *in-sample regression models* under likelihood-based criteria (a quasi-likelihood/KLIC criterion, AIC, or BIC on effective degrees of freedom), which is the machinery behind the Taylor-rule application; the object compared there is model fit, not an out-of-sample forecast loss, underscoring that the MCS is a general comparison procedure whose meaning is set by the criterion supplied.

Source: Hansen, Lunde & Nason 2011, §3 Bootstrap Implementation (relative performance variables, quadratic-form and t-statistic tests `T_R`/`T_max`, elimination rules, Assumption 2, Proposition 1, Lemma 2, Theorem 4, and §3.2 regression-model MCS), canonical DOI [10.3982/ECTA5771](https://doi.org/10.3982/ECTA5771); readable PDF is the CREATES Research Paper 2010-76 working-paper version [`rp10_76.pdf`](https://repec.econ.au.dk/repec/creates/rp/10/rp10_76.pdf), sha256 `c4abc4759af8`.
