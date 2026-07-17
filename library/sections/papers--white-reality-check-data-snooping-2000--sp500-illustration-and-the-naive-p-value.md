---
title: The S&P 500 illustration and the naive p-value
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

Abstract: White demonstrates the Reality Check by searching for a technical-indicator model that forecasts one-day-ahead S&P 500 returns and beats a constant-only *efficient-markets* benchmark. From 29 technical indicators (lagged returns, momentum measures, local trends, relative-strength indexes, moving-average oscillators) he builds all `l = C(29,3) = 3,654` linear models using a constant and exactly three indicators, over `n = 758` out-of-sample days (June 1991–May 1994). The result is the paper's central lesson: the **naive p-value** — computed as if the best model had been the only one considered — is a dangerously small `.0036` for directional accuracy, while the search-corrected **Bootstrap Reality Check p-value** is `.2040`. Neither performance measure rejects the efficient-markets null once the search is accounted for, and the gap between the naive and Reality Check p-values is a *direct estimate of the data-mining bias*.

**Setup.** Daily returns `y_t = (p_t - p_{t-1})/p_{t-1}` on the S&P 500 cash index. Estimation window `R = 803`, `T = 1560`, so `n = 758` predictions. The benchmark (`k = 0`) is a constant only — the simple efficient-markets hypothesis that excess returns are a martingale difference and thus unforecastable. Two performance measures are searched: negative mean squared prediction error, and *directional accuracy* (whether the model predicts the sign of the next return better than a naive average-behavior predictor). The Bootstrap Reality Check is applied with `N = 500` resamples and stationary-bootstrap smoothing `q = .5`; recursive least squares makes the 3,654-model search tractable.

**Results (the two tables).**
- **Prediction MSE (Table I).** Best model RMSE `.006373` versus benchmark `.006410` — a difference in prediction MSE of `.4791×10⁻⁶`. Reality Check p-value `.3674`; naive p-value `.1068`. We fail to reject the null that the MSE-best model beats the benchmark. Without the Reality Check there would be no way to tell whether the observed superiority should be surprising.
- **Directional accuracy (Table II).** Best model predicts direction correctly `54.75%` of the time versus the benchmark's `50.79%` — an impressive-looking `.0396` gain. Reality Check p-value `.2040`; naive p-value **`.0036`**. Anyone relying on the naive p-value would conclude the strategy is highly significant and be "seriously misled." Once the search over 3,654 models is accounted for, the gain is not significant.

**The naive p-value and how the p-value evolves.** Conducting inference without accounting for the specification search — applying the bootstrap to the best specification *alone* — yields the naive p-value. The difference between it and the Reality Check p-value directly estimates the data-mining bias, which is substantial here. As experiments accumulate, the Reality Check p-value *drops* each time a new best performance is observed (a new tail event) and otherwise *creeps up* as proper account is taken of data re-use; because the candidate forecasts are highly correlated, it stays flat for stretches — so considering even a large number of models need not dramatically erode the p-value. White notes a one-way shortcut: the naive p-value is always a *lower bound* on the Reality Check p-value, so if the naive p-value is large there is no need to compute the Reality Check at all; only when it is small must the search-corrected value be computed to assess the real evidence.

Source: White 2000, section 4 (An Illustrative Example), Tables I–II and Figures 1–3, canonical DOI [10.1111/1468-0262.00152](https://doi.org/10.1111/1468-0262.00152); readable PDF [Wisconsin Econ 718 course copy](https://www.ssc.wisc.edu/~bhansen/718/White2000.pdf), sha256 `675eb3226dee`.
