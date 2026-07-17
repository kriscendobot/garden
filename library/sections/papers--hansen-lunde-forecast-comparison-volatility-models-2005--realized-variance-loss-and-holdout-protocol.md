---
title: Realized variance, six losses, and the holdout protocol
source: "A Forecast Comparison of Volatility Models: Does Anything Beat a GARCH(1,1)?"
source_kind: paper
source_authors: [Peter R. Hansen, Asger Lunde]
source_year: 2005
source_venue: "Journal of Applied Econometrics 20(7):873-889"
source_url: https://doi.org/10.1002/jae.800
source_pdf_sha256: 3eeed6014f705dc0a192cc47822921b1d59a062267ca96ee25c6ee24f54c8099
ingested: 2026-07-17
ingested_by: scholar
topics: [financial-forecasting, forecast-evaluation]
status: current
---

Abstract: Each model is maximum-likelihood fitted on an estimation sample, then produces one-step-ahead forecasts for a separate evaluation sample. Six loss functions compare those forecasts with realized variance, not daily squared returns. This target choice matters because squared returns are so noisy that they can distort the population ranking and select an inferior variance model even as sample size grows.

The exchange-rate evaluation uses October 1987-September 1992 for estimation and the following 260 days for evaluation. IBM uses 1990-May 1999 for estimation and June 1999-May 2000 for evaluation. Intraday observations construct realized variance, with alternative constructions used as a robustness check for IBM. The paper therefore separates time ordering, target measurement, scoring rule, and model comparison rather than calling a fitted likelihood a forecast result.

This is a concrete [[walk-forward-validation]] template, albeit a single fixed holdout rather than repeated origins. The target and loss must be reported with the winner: a volatility claim cannot be understood independently of its proxy. Patton 2011 supplies the stronger proxy-robust-loss result for choosing QLIKE or MSE.
