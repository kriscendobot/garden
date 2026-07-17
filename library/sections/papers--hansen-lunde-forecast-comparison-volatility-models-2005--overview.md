---
title: A 330-model volatility horse race (overview)
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

Abstract: Hansen and Lunde make the GARCH(1,1) baseline an empirical claim rather than a convention. They compare 330 ARCH-type specifications by one-day-ahead conditional-variance forecasts, against realized variance, over held-out Deutsche-mark/dollar and IBM-return samples. The answer is conditional: no model significantly beats GARCH(1,1) for the exchange rate, while IBM volatility favors models with a leverage effect. The paper also makes the model-search correction load-bearing: a best raw score among 330 candidates is not evidence until the SPA test accounts for the searched family.

The study is a useful constraint on both a forecasting implementation and its evaluation harness. Conditional volatility is forecastable, but additional architecture should be earned separately for each market and loss target. Fit candidates on an estimation sample, score the held-out forecasts against a realized-variance proxy with several defensible losses, and test relative losses while correcting for the full candidate set. It does not license the slogan that GARCH always wins.

Source: Peter R. Hansen and Asger Lunde, *A Forecast Comparison of Volatility Models: Does Anything Beat a GARCH(1,1)?*, Journal of Applied Econometrics 20(7):873-889 (2005), doi:10.1002/jae.800; full publisher HTML fetched through the Internet Archive original-bytes capture, sha256 `3eeed601`.
