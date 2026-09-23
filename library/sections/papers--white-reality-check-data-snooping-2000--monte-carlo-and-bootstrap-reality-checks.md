---
title: The Monte Carlo and Bootstrap Reality Checks
source: "A Reality Check for Data Snooping"
source_kind: paper
source_authors: [Halbert White]
source_year: 2000
source_venue: "Econometrica 68(5):1097-1126"
source_url: https://doi.org/10.1111/1468-0262.00152
source_pdf_sha256: 675eb3226dee3af4dfa8089410f9bbf0a2798c7b58985c8334c42fb4983a9743
ingested: 2026-07-17
ingested_by: scholar
topics: [forecast-evaluation, financial-forecasting]
status: current
---

Abstract: The distribution the Reality Check needs — the extreme value of a vector of correlated normals — has no analytic form, so White gives two feasible ways to obtain the p-value. The **Monte Carlo Reality Check** estimates the long-run covariance `V̂` (for example by a Politis–Romano block estimator), draws many samples from `N(0, V̂)`, and reads the p-value off the distribution of the *extremes*; its storage and manipulation grow with `l²`. The **Bootstrap Reality Check** instead resamples the relative-performance series itself with the Politis–Romano *stationary bootstrap* and compares `V̄_l` to the quantiles of `V̄*_l = max_k √n(f̄*_k - f̄_k)`; it is the preferred method — storage grows only with `l`, and it is well-suited to the recursive specification searches done in practice. The headline convenience is that the coefficient estimates `β̂_t` **do not have to be recomputed under resampling**.

**Monte Carlo Reality Check.** Compute a consistent estimator `V̂` of the `l × l` covariance, draw `Z̄_i ~ N(0, V̂)` for `i = 1..N` (via the Cholesky factor `Ĉ`, `Z̄_i = Ĉ η_i` with `η_i` standard normal), and form the p-value from the order statistics of `z_{i,l} = max_k Z̄_{i,k}`. Adding one more model appends a row to `V̂` and a row to the triangular `Ĉ`, so the running maximum can be updated recursively as models arrive. The cost: storage and manipulation scale with `l²`, and to account for the data-snooping efforts of *others* one needs their full `f̂` matrix.

**Bootstrap Reality Check.** For time-series data the resampling must respect dependence. White uses the Politis–Romano **stationary bootstrap**: like the moving-blocks bootstrap but with blocks of *random* length drawn from a geometric distribution with mean block length `1/q` (the smoothing parameter `q ∈ (0, 1]`, smaller for more dependence; `q = 1` recovers the standard i.i.d. bootstrap when the relative-performance series is a martingale difference under the null). Resampled indexes `{u_i(t)}` are generated once at the outset; the resampled statistic is `f̄*_i = n^{-1} Σ f̂_{u_i(t)+τ}`. **Theorem 2.3** (White's main result) establishes that, conditional on the sample, the bootstrap distribution of `√n(f̄* - f̄)` converges to that of `√n(f̄ - E[f*])`, and **Corollary 2.4** carries this to the extreme values `V̄_l` and its minimum analogue. The "appealing and somewhat remarkable" feature is that `β̂_t` need not be recomputed under the resampling — a condition on the estimator's law of the iterated logarithm (Assumption C) makes the estimation aspect vanish. When neither regularity condition holds the conclusion still holds if `f̄*` is modified by a term estimating the parameter-uncertainty contribution.

**Practical advantages and reach.** Because only the scalars `V̄_{l,i}` (and the seed of an agreed random-number generator) are needed — not the `n × l` data matrix, which may be unavailable or proprietary — the Bootstrap Reality Check can be carried out by researchers at separate locations and times, and even chained across a *sequence* of studies to account for cumulative data snooping by the profession. Storage scales with `l` rather than `l²`. A recommended `N` is 500 or 1000 resamples. Corollaries 2.6–2.7 extend everything to selection criteria that are smooth functions of averages — the prediction-sample `R²` for forecasts or the **Sharpe ratio** for investment strategies — via the delta method, so a Reality Check on realized Sharpe is well-defined. Less-frequent parameter updates, in-sample estimates applied to a hold-out set, and rolling/moving windows all leave the results intact.

Source: White 2000, section 2.b (Monte Carlo and Bootstrap Reality Check p-values, Theorem 2.3, Corollary 2.4), section 2.c (Extensions and Variations, Corollaries 2.6–2.7), and section 3 (Implementing the Bootstrap Reality Check), canonical DOI [10.1111/1468-0262.00152](https://doi.org/10.1111/1468-0262.00152); readable PDF [Wisconsin Econ 718 course copy](https://www.ssc.wisc.edu/~bhansen/718/White2000.pdf), sha256 `675eb3226dee`.
