---
title: The 330-model ARCH family and the GARCH(1,1) benchmark
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

Abstract: The comparison expands a GARCH family across dynamics, lag lengths, conditional distributions, mean specifications, and asymmetry, but preserves GARCH(1,1) as the parsimonious benchmark. ARCH(1) is deliberately retained as a weak control: if a multiple-model test cannot reject it, the test is not informative enough to rank serious alternatives.

The candidate universe includes ARCH, GARCH, integrated and threshold variants, power/asymmetric forms, and related extensions with p and q generally one or two. The design distinguishes a statistically significant in-sample extra parameter from an out-of-sample forecasting improvement. The authors note that longer lags rarely improve on their lower-lag counterpart in their experiment, despite many significant fitted parameters.

For a production harness this is a selection discipline: start with GARCH(1,1), include a deliberately inadequate control, and add GJR/EGARCH or richer dynamics only as explicit candidates in the same predeclared race. A candidate family is part of the hypothesis, not a harmless tuning detail. See [[garch-volatility-models]] and [[data-snooping-bias]].
