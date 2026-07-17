---
title: LM detection and maximum-likelihood estimation
source: "Autoregressive Conditional Heteroscedasticity with Estimates of the Variance of United Kingdom Inflation"
source_kind: paper
source_authors: [Robert F. Engle]
source_year: 1982
source_venue: "Econometrica 50(4):987-1007"
source_url: https://www.jstor.org/stable/1912773
source_mirror_url: https://docslib.org/doc/3199579/autoregressive-conditional-heteroscedasticity-with-estimates-of-the-variance-of-united-kingdom-inflation-author-s-robert-f
source_content_sha256: 0a9966a2ac558e580b2bd5c03019b4bde476dfe2d510348a0101dea2c975075e
source_fetched_via: direct
ingested: 2026-07-17
ingested_by: scholar
topics: [financial-forecasting, forecast-evaluation]
status: current
---

Abstract: The ARCH LM test detects predictable scale left in squared OLS residuals, and maximum likelihood estimates the resulting mean and variance equations jointly. These are model-diagnosis and fitting tools, not a substitute for a held-out test of whether a volatility forecast is useful.

Engle's Lagrange-multiplier test regresses squared residuals on their lagged values; serial correlation in those squares rejects the constant-variance null. The result gives a simple screen for ARCH structure after fitting a conditional mean. It is especially valuable because ordinary residual autocorrelation can be absent while variance dynamics remain pronounced.

The paper then gives likelihood and scoring-iteration machinery for ARCH regressions and compares it with ordinary least squares. Modern fitting should record the chosen order, initialization, convergence, coefficient constraints, and post-fit standardized-residual diagnostics. Those records establish implementation validity; a walk-forward loss comparison establishes forecast quality. See [[garch-volatility-models]] and [[walk-forward-validation]].

Source: Engle 1982, sections 4-5, canonical stable URL [JSTOR 1912773](https://www.jstor.org/stable/1912773); readable HTML transcription fetched from Docslib, sha256 `0a9966a2`.
