---
title: Volatility Forecast Comparison Using Imperfect Volatility Proxies (robust loss functions and QLIKE)
source: "Volatility Forecast Comparison Using Imperfect Volatility Proxies"
source_kind: paper
source_authors: [Andrew J. Patton]
source_year: 2011
source_venue: "Journal of Econometrics 160(1):246-256"
source_url: https://doi.org/10.1016/j.jeconom.2010.03.034
source_pdf_sha256: 2b85bc30f188dc19d0ac7dbfe854929148d27c42e3f73d2b16605558daf60cee
ingested: 2026-07-16
ingested_by: scholar
topics: [forecast-evaluation, financial-forecasting]
status: current
---

Abstract: Patton's central theorem characterizes the losses that preserve the expected-loss ranking of volatility forecasts when evaluation uses a conditionally unbiased noisy variance proxy. The class includes **MSE** and **QLIKE**. QLIKE, L(y,h) = y/h - log(y/h) - 1 up to irrelevant constants, is scale invariant and penalizes under-prediction more heavily than comparable over-prediction; its required proxy conditions are weaker than MSE's. That combination makes QLIKE the default loss for comparing positive variance forecasts in the library's walk-forward volatility harness.

## The robustness criterion

The necessary-and-sufficient condition constrains the derivative of the loss with respect to the proxy. Intuitively, taking conditional expectation over a noisy but conditionally unbiased proxy must leave the forecast-ordering signal intact. The resulting family is broad enough to encode meaningful asymmetry between under- and over-forecasting, so robustness does not force a forecaster into one arbitrary utility shape.

Among familiar special cases, MSE is the unique robust loss that passes through the forecast error in the usual additive way. QLIKE is the unique robust member satisfying the corresponding scale-invariant form. Both have conditional variance as their optimal forecast under the paper's setup, but they react differently to tails and units.

## Why prefer QLIKE in practice

QLIKE is homogeneous of degree zero: rescaling returns and variances does not change its loss. It is asymmetric, with a heavier penalty for a forecast that is too low than for one that is comparably too high. More importantly for real market data, Patton notes that QLIKE needs weaker proxy moment conditions than MSE and evidence from related forecast-comparison tests finds greater power for QLIKE. MSE remains valid when its stronger conditions are credible, but its squared scale makes extreme realizations more influential.

The operational rule is not "QLIKE proves a model is good." It is: evaluate all candidates on the same strictly out-of-sample proxy sequence, report mean QLIKE differences alongside a baseline, and use a forecast-comparison procedure for uncertainty. A model selected after a large search still faces [[data-snooping-bias]].

Source: Andrew J. Patton, *Volatility Forecast Comparison Using Imperfect Volatility Proxies*, section 3, doi:10.1016/j.jeconom.2010.03.034; open author PDF sha256 `2b85bc30`.
