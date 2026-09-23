---
title: SPA corrects the 330-model search; Reality Check can lack power
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

Abstract: A naive p-value that compares the best observed candidate with GARCH(1,1) ignores that the candidate was selected from 330 models. Hansen and Lunde use Hansen's Superior Predictive Ability (SPA) test and White's Reality Check (RC) to test the benchmark against the full model family. Their IBM results show a practical distinction: SPA detects GARCH's inferiority, while RC can fail to distinguish even ARCH(1) from serious models because erratic candidates inflate its critical values.

The paper does not use a correction to identify one population-best model. It uses a correction to support a limited claim that a benchmark is inferior. That distinction prevents an evaluator from promoting the top row of a leaderboard into a universal choice. The strong conclusion is evidence against a stated baseline, conditional on data, proxy, loss, and candidate family.

This is the empirical worked example for [[data-snooping-bias]]: log every candidate and apply a family-aware comparison before saying a complexity beat GARCH. It complements Welch and Goyal's warning that a selected return-prediction specification needs data beyond the search.
