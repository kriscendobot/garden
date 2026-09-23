---
title: "Financial examples and the risk-direction boundary"
source: "Stepwise Multiple Testing as Formalized Data Snooping"
source_kind: paper
source_authors: [Joseph P. Romano, Michael Wolf]
source_year: 2005
source_venue: "Econometrica 73(4):1237-1282"
source_url: https://doi.org/10.1111/j.1468-0262.2005.00615.x
source_pdf_sha256: ef3ed6fa9c91e2e2bb1f0c8b6bec84d2627941274f92c913e5a9e2f6cebe60ee
ingested: 2026-07-17
ingested_by: scholar
topics: [financial-forecasting, forecast-evaluation]
status: current
---

Abstract: Romano and Wolf's examples show that multiplicity control is about the family of declared comparisons, not a particular financial target. A strategy can be judged by excess mean return, Sharpe-ratio advantage, positive CAPM alpha, or Value-at-Risk performance. For VaR, the proposed contrasts concern calibration of the hit rate to the nominal tail probability or serial independence of hits. These are conditional-risk and distributional calibration targets, not claims that the next return's sign is predictable.

Their empirical illustration compares 100 large-cap stocks with the S&P 500 through CAPM alpha. At FWER level 0.1, the basic single-step procedure identifies three stocks, basic multi-step identifies two more, and studentized StepM identifies six stocks in its first step. This is evidence of benchmark-relative positive alpha under the stated CAPM and resampling setup, not an implementable directional trading rule and not a general result about return predictability. Likewise, applying StepM to a GARCH, EGARCH, HAR, or VaR model family under realized-variance, QLIKE, hit-rate, or coverage loss would select conditional-volatility or tail-risk forecasts, never directional-return forecasts merely because the multiple-testing correction is valid.

Source: Romano and Wolf 2005, Examples 2.1-2.4 and pp. 1260-1262; canonical DOI [10.1111/j.1468-0262.2005.00615.x](https://doi.org/10.1111/j.1468-0262.2005.00615.x); working-paper provenance and sha256 `ef3ed6fa9c91` as recorded in the source index.
