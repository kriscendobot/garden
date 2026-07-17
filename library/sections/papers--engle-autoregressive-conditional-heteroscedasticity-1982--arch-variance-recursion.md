---
title: ARCH variance recursion and conditional forecast intervals
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

Abstract: ARCH(q) forecasts conditional variance from a positive constant and q lagged squared innovations. The recursion makes a forecast interval widen after a surprise and contract after quiet observations, which is the basic risk-state mechanism that Bollerslev later compresses with lagged variance in GARCH.

For innovations epsilon_t with standardized conditional shock z_t, ARCH uses epsilon_t = sqrt(h_t) z_t and h_t = alpha_0 + sum(alpha_i epsilon^2_(t-i)). Nonnegative coefficients keep the forecast variance positive. A recent large residual raises h_t, so the next conditional distribution is wider even though the conditional mean may be unchanged.

The model should be implemented as a one-step-ahead recursion: at each forecast origin, compute h_t only from data then known and retain the resulting predicted variance separately from the realized target. This makes the variance forecast auditable and prevents an ex-post volatility estimate from leaking into an apparent forecast. See [[garch-volatility-models]] and [[look-ahead-bias]].

Source: Engle 1982, sections 1-2, canonical stable URL [JSTOR 1912773](https://www.jstor.org/stable/1912773); readable HTML transcription fetched from Docslib, sha256 `0a9966a2`.
