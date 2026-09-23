---
title: ARCH makes one-step forecast uncertainty predictable
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

Abstract: Engle's ARCH paper establishes that the uncertainty around a one-step forecast can itself be forecast from past shocks. It is the direct predecessor of GARCH: conditional variance is an information-set-dependent state, while unconditional variance can remain stable. For financial forecasting, ARCH supplies a baseline risk forecast, not a directional-return prediction or proof of trading value.

Conventional time-series work improved conditional-mean forecasts while usually holding their forecast variance constant. ARCH instead writes an innovation as a conditionally mean-zero shock with variance h_t, where h_t is a function of information available at t-1. Large and small forecast errors may therefore cluster without making the innovations serially correlated in mean.

This distinction is the conceptual foundation for volatility forecasting. A model can add useful uncertainty intervals, risk limits, or volatility-scaled exposure even when it has no demonstrated ability to predict the sign of the next return. Its value still requires a future-only evaluation against a simple variance baseline and an appropriate variance-proxy loss. See [[garch-volatility-models]] and [[walk-forward-validation]].

Source: Robert F. Engle, *Autoregressive Conditional Heteroscedasticity with Estimates of the Variance of United Kingdom Inflation*, Econometrica 50(4):987-1007 (1982), canonical stable URL [JSTOR 1912773](https://www.jstor.org/stable/1912773); readable HTML transcription fetched from Docslib, sha256 `0a9966a2`.
