---
title: United Kingdom inflation example and the evaluation boundary
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

Abstract: Engle's United Kingdom inflation application finds significant ARCH effects and markedly higher estimated uncertainty during the 1970s. It demonstrates that conditional-variance forecasts can track changing uncertainty, while also making clear that an in-sample fit is not evidence that a financial strategy or later GARCH specification wins out of sample.

The application estimates inflation's conditional mean and variance, with an ARCH effect that captures episodes of clustered large errors. The fitted variance rises substantially in the turbulent 1970s, producing time-varying forecast intervals where a homoskedastic regression would issue a constant interval.

For a financial forecaster, the transferable result is methodological: model the predictable second moment and evaluate it as its own target. Refit only on the information available at each origin, compare against ARCH, GARCH, or simple EWMA baselines using a robust variance loss such as QLIKE, and distinguish variance-score improvement from directional P&L claims. See [[garch-volatility-models]] and [[walk-forward-validation]].

Source: Engle 1982, section 6, canonical stable URL [JSTOR 1912773](https://www.jstor.org/stable/1912773); readable HTML transcription fetched from Docslib, sha256 `0a9966a2`.
