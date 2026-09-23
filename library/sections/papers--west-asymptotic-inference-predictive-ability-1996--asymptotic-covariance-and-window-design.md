---
title: Asymptotic covariance and window design
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

Abstract: The corrected standard error combines time-series dependence in the evaluation moments with uncertainty from the fitted parameters, so forecast-window design changes the asymptotic problem. In particular, parameter estimation can become negligible only under conditions that make the evaluation sample small relative to the estimation sample or make the evaluation moment locally insensitive to the parameters. A report must record its rolling or recursive window scheme rather than treating it as an interchangeable backtest detail.

West's limiting distribution is normal under regularity conditions, but its covariance is the covariance of the full first-order expansion: ordinary serial dependence in the evaluation moment plus the influence of parameter estimation and their joint dependence. The result supports standard asymptotic testing only after that covariance has been estimated consistently. A horizon with overlapping forecast errors already requires long-run covariance care; re-estimating regression models adds a separate channel.

Two useful diagnostics follow from the framework. If the expected gradient of the evaluation moment with respect to the parameter is zero, the first-order estimation contribution can vanish. It may also vanish when the evaluation sample grows slowly relative to the estimation sample. Neither condition should be presumed. Recursive expanding windows, rolling fixed windows, and infrequent refits encode different parameter-error behavior, so they belong with the loss function and horizon in the forecast-evaluation record.

Source: West 1996, main asymptotic theorem and applications, canonical DOI [10.2307/2171956](https://doi.org/10.2307/2171956); readable PDF [Wisconsin Econ 718 course copy](https://users.ssc.wisc.edu/~bhansen/718/West1996.pdf), sha256 `6c22ad3cb108`.
