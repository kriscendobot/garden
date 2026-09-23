---
title: Parameter-estimation uncertainty
source: "Asymptotic Inference About Predictive Ability"
source_kind: paper
source_authors: [Kenneth D. West]
source_year: 1996
source_venue: "Econometrica 64(5):1067-1084"
source_url: https://doi.org/10.2307/2171956
source_pdf_sha256: 6c22ad3cb108c62d9534e1173bc4fd70cddfd84122dc03b0dfcd15d07508fa33
ingested: 2026-07-17
ingested_by: scholar
topics: [financial-forecasting, forecast-evaluation]
status: current
---

Abstract: A forecast-comparison test can be wrongly sized when it ignores the uncertainty introduced by fitting the models that produced the forecasts. West handles that extra randomness by a first-order expansion of a smooth evaluation moment around its population parameter, then includes the influence of the estimation error in the limiting covariance. This is the key correction that takes the framework beyond the given-forecast case of Diebold-Mariano.

Let an evaluation moment depend on data and the population parameter, written schematically as `f(Z, beta*)`, while the observed forecast uses `beta_hat`. The sample average based on `beta_hat` differs from the population-parameter average by a derivative term times `beta_hat - beta*`, to first order. That term is not a cosmetic adjustment: it can be the same asymptotic order as ordinary sampling variation when the estimation and evaluation samples grow together. A standard long-run variance of the realized loss series alone can therefore omit a material source of uncertainty.

The smoothness requirement has an operational consequence. West's general result is designed for differentiable forecast-evaluation moments. Later work broadens the treatment for nonsmooth losses, but a modern implementation should first identify the loss, estimator, and parameter-update schedule before declaring a familiar forecast-comparison statistic valid. Estimation error is part of the evidence contract, not an implementation detail.

Source: West 1996, introduction and asymptotic-inference development, canonical DOI [10.2307/2171956](https://doi.org/10.2307/2171956); readable PDF [Wisconsin Econ 718 course copy](https://users.ssc.wisc.edu/~bhansen/718/West1996.pdf), sha256 `6c22ad3cb108`.
