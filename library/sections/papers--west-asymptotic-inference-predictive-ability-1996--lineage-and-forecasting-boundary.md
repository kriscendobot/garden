---
title: Lineage and forecasting boundary
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

Abstract: West and Diebold-Mariano are complementary foundations, not alternative ways to correct a model search. Diebold-Mariano supplies the loss-differential comparison for two given forecasts; West supplies inference when those forecasts depend on estimated parameters; White's Reality Check then corrects the further error created by choosing a winner from many searched models. The same lineage applies to volatility forecasts, but it does not turn an accurate conditional-variance forecast into a directional-return forecast.

For two predeclared models, a comparison should start with the relevant out-of-sample loss differential and account for serial dependence. If either forecast is model-fitted, the West question follows: does parameter uncertainty change the sampling distribution of the evaluation moment? If the comparison instead selected the best from a catalogue, neither a pairwise DM p-value nor a West-corrected single-comparison p-value accounts for the selection event. White's Reality Check, SPA, or a Model Confidence Set addresses that separate multiplicity problem.

The object evaluated fixes the economic interpretation. With QLIKE or another variance loss, this pipeline assesses relative conditional-volatility and risk-forecast quality. With squared return error or a direction score, it assesses mean or directional forecast quality. A significance result in the first category supports risk sizing or interval calibration, not a claim to forecast the sign of returns. This distinction is especially important when comparing GARCH-family models, whose core target is conditional variance.

Source: West 1996, introduction and predictive-ability framework, canonical DOI [10.2307/2171956](https://doi.org/10.2307/2171956); readable PDF [Wisconsin Econ 718 course copy](https://users.ssc.wisc.edu/~bhansen/718/West1996.pdf), sha256 `6c22ad3cb108`.
