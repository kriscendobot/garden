---
title: The framework and the maximum statistic
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

Abstract: White builds directly on Diebold and Mariano 1995 and West 1996 on testing predictive ability, and generalizes their pairwise comparison to `l` models at once. Forecasts are made for `n` out-of-sample periods (indexed `R` through `T`), each based on a parameter estimate `β̂_t` formed from data through `t`. For each candidate model `k` there is a relative-performance moment `f_k = f(Z, β*)` — its performance *minus* the benchmark's — and the sample statistic is the vector of averages `f̄ = n^{-1} Σ f̂_{t+τ}`. The null of no predictive superiority is the multiple hypothesis `H0: max_{k=1..l} E[f_k*] ≤ 0`: the best model is no better than the benchmark. The test statistic is the extreme value `V̄_l = max_{k=1..l} √n f̄_k`, and its large-sample distribution — the maximum of a correlated normal vector — is obtained by enforcing the null at its *least-favorable configuration*, `E[f_k*] = 0` for all `k`.

**The moment as both loss differential and selection criterion.** The framework is deliberately loss-agnostic, inherited from Diebold–Mariano. `f_k` is any relative-performance measure; three worked examples set the pattern: (2.1) negative mean squared prediction error, `f = -(y - x'β̂_1)² + (y - x'β̂_0)²`, so a positive mean favors model 1 over the benchmark (the models need not be nested); (2.2) a trading-strategy return differential, `f = log(1 + y·S_1) - log(1 + y·S_0)`, where the signal functions `S` map indicators into long/neutral/short positions set a priori (no estimated parameters — squarely the Diebold–Mariano case); (2.3) a predictive-log-likelihood differential. Crucially, the *same* moment doubles as a **model-selection criterion**: assign one `f_k` to each of `l` models, select the model with the best criterion value, and the appropriate null is exactly "the selected best is no better than the benchmark." A complexity penalty (for example AIC's parameter count) is folded in by subtracting `p_k - p_0` from `f_k`, selecting on penalized performance.

**Why the maximum, and why the least-favorable configuration.** West's Main Theorem 4.1 gives conditions under which `√n(f̄ - E[f*]) → N(0, V)`, where `V` is the long-run covariance of the relative-performance vector (and the estimated-parameter contribution vanishes when the moment's expected gradient `F = 0`, as in Examples 2.1 and 2.3, or when `n/R → 0`). West's own chi-squared statistic tests the point null `E[f*] = 0`; White's interest in the *inequality* null `E[f*] ≤ 0` leads instead to a statistic based on `max_k f̄_k`. Proposition 2.1 shows the search correctly identifies the best model when one exists (a beating model is eventually revealed by a positive estimated relative performance; the best model eventually has the best estimate). Proposition 2.2 gives the extreme-value limit: `max_k √n(f̄_k - E[f_k*]) → max_k Z̄_k`, where `Z̄ ~ N(0, V)`. Enforcing the null least favorably (all `E[f_k*] = 0`) makes the distribution of `V̄_l = max_k √n f̄_k` known approximately for large `T`, permitting asymptotic p-values — akin to inverting a confidence interval for `max_k E[f_k*]`. Under the alternative the statistic diverges at rate `√n` (Proposition 2.5), so the test's level can be driven to zero while power approaches one. **Any method for consistently estimating a p-value for `H0: E[f*] ≤ 0` in a specification search White calls a "Reality Check."**

Source: White 2000, section 2.a (Basic Framework) and section 2.b (Basic Theory), Propositions 2.1–2.5, canonical DOI [10.1111/1468-0262.00152](https://doi.org/10.1111/1468-0262.00152); readable PDF [Wisconsin Econ 718 course copy](https://www.ssc.wisc.edu/~bhansen/718/White2000.pdf), sha256 `675eb3226dee`.
