---
source_kind: paper
source_authors: [Halbert White]
source_title: "A Reality Check for Data Snooping"
source_year: 2000
source_venue: "Econometrica 68(5):1097-1126"
source_url: https://doi.org/10.1111/1468-0262.00152
source_mirror_url: https://www.ssc.wisc.edu/~bhansen/718/White2000.pdf
source_jstor_url: https://www.jstor.org/stable/2999518
source_pdf_sha256: 675eb3226dee3af4dfa8089410f9bbf0a2798c7b58985c8334c42fb4983a9743
source_fetched_via: direct
source_pdf_pages: 30
ingested: 2026-07-17
ingested_by: scholar
section_count: 5
status: current
notes: |
  Readable PDF is the copy hosted on Bruce Hansen's University of Wisconsin
  Economics 718 course page; its running heads and pagination are those of the
  Econometrica 68(5):1097-1126 original. Cited canonically as White 2000
  (Econometrica). Fetched direct; sha256 pins the ingested bytes. Manuscript
  received June 1997, final revision July 1999.
---

Abstract: White introduces the **Reality Check** — the first practical, rigorously founded test of the null hypothesis that *the best model found in a specification search has no predictive superiority over a given benchmark*, correcting inference for the fact that many models were searched. It is the direct multiple-model generalization of the pairwise [Diebold–Mariano test](papers--diebold-comparing-predictive-accuracy-1995.md): building on Diebold and Mariano 1995 and West 1996, it forms an `l`-vector of relative-performance moments `f̄` (one per candidate model versus the benchmark) and tests `H0: max_k E[f_k*] ≤ 0` via the extreme-value statistic `V̄_l = max_k √n f̄_k`, enforcing the null at its least-favorable configuration (all models tie the benchmark). Because the limiting distribution is the maximum of correlated normals, the p-value is obtained by simulation: the **Monte Carlo Reality Check** (sample from the estimated covariance) or the preferred **Bootstrap Reality Check** (Politis–Romano stationary bootstrap of `f̄`, with the appealing feature that the coefficient estimates need not be recomputed under resampling). An S&P 500 illustration searches 3,654 linear technical-indicator models against a constant-only efficient-markets benchmark: the naive p-value that ignores the search is a dangerously small `.0036` for directional accuracy, while the search-corrected Reality Check p-value is `.2040` — the gap is a direct estimate of the data-mining bias, and neither experiment rejects the efficient-markets null. It is the foundational correction the Diebold–Mariano test does not make, and the ancestor of Hansen's SPA test and the Model Confidence Set.

| Section | Topics | Status |
|---------|--------|--------|
| [overview-and-the-data-snooping-null](../sections/papers--white-reality-check-data-snooping-2000--overview-and-the-data-snooping-null.md) | forecast-evaluation, financial-forecasting | current |
| [framework-and-the-max-statistic](../sections/papers--white-reality-check-data-snooping-2000--framework-and-the-max-statistic.md) | forecast-evaluation, financial-forecasting | current |
| [monte-carlo-and-bootstrap-reality-checks](../sections/papers--white-reality-check-data-snooping-2000--monte-carlo-and-bootstrap-reality-checks.md) | forecast-evaluation, financial-forecasting | current |
| [sp500-illustration-and-the-naive-p-value](../sections/papers--white-reality-check-data-snooping-2000--sp500-illustration-and-the-naive-p-value.md) | forecast-evaluation, financial-forecasting | current |
| [placement-and-the-correction-lineage](../sections/papers--white-reality-check-data-snooping-2000--placement-and-the-correction-lineage.md) | forecast-evaluation, financial-forecasting | current |
