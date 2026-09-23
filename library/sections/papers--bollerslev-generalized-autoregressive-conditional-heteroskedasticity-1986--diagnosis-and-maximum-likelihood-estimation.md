---
title: Diagnose squared residuals and estimate the variance recursion
source: "Generalized Autoregressive Conditional Heteroskedasticity"
source_kind: paper
source_authors: [Tim Bollerslev]
source_year: 1986
source_venue: "Journal of Econometrics 31(3):307-327"
source_url: https://doi.org/10.1016/0304-4076(86)90063-1
source_mirror_url: https://public.econ.duke.edu/~boller/Published_Papers/joe_86.pdf
source_pdf_sha256: 60353d437aadda9179df4e7cfcc55f0dd343840b04c6ee7d83285eb33fa17e1a
ingested: 2026-07-17
ingested_by: scholar
topics: [financial-forecasting, forecast-evaluation]
status: current
---

Abstract: GARCH identification starts where a mean-only model fails: residuals can be serially uncorrelated while their squares remain autocorrelated. Bollerslev connects squared-residual autocorrelation and partial autocorrelation to the variance recursion, then sets out likelihood estimation for a regression with GARCH errors. The procedure separates detecting time-varying risk from proving that a fitted risk forecast improves a future decision.

The squared process has an ARMA-like representation, so its autocorrelation and partial autocorrelation functions can guide initial orders and diagnose remaining conditional heteroskedasticity. This is an in-sample adequacy check. It is useful for detecting a variance model that has left predictable scale structure in its standardized residuals, but it cannot establish economic forecasting value by itself.

The likelihood uses the recursively updated h_t and can be optimized iteratively. Under the paper's assumptions, mean and variance parameter estimates are asymptotically independent, allowing a consistent mean estimate and variance recursion to be handled separately for efficiency purposes. Modern implementations should retain the recursion initialization, positivity and stationarity checks, convergence diagnostics, and standardized-residual checks as part of model provenance. Then score actual one-step-ahead forecasts outside the fitting sample. See [[garch-volatility-models]] and [[walk-forward-validation]].

Source: Bollerslev 1986, sections 4-5, doi:10.1016/0304-4076(86)90063-1; author-hosted PDF sha256 `60353d43`.
