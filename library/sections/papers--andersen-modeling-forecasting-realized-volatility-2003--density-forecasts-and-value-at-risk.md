---
title: Density forecasts and Value-at-Risk from a realized-volatility VAR
source: "Modeling and Forecasting Realized Volatility"
source_kind: paper
source_authors: [Torben G. Andersen, Tim Bollerslev, Francis X. Diebold, Paul Labys]
source_year: 2003
source_venue: "Econometrica 71(2):579-625 (2003); NBER Working Paper No. 8160 (March 2001)"
source_url: https://doi.org/10.1111/1468-0262.00418
source_pdf_sha256: a14e0e5de7e8b13b9218dbe503041a78d9416c49d9a36eafc909333ebfdea7ea
ingested: 2026-07-16
ingested_by: scholar
topics: [financial-forecasting]
status: current
---

Abstract: How the realized-volatility forecasts turn into a full return distribution and a Value-at-Risk (VaR) number, and how that distribution is validated. Combining the long-memory VAR forecast of realized volatility with the two Gaussian regularities (log volatility is normal; realized-vol-standardized returns are normal) gives a **lognormal-normal mixture** predictive density for returns, from which any quantile, and therefore VaR (the quantile of the return-density forecast at a given confidence level and horizon), is read off directly. The density forecasts are validated with the Diebold-Gunther-Tay probability-integral-transform (PIT) test: if the density forecasts are correct, the PIT series should be independent and uniform on the unit interval. Both hold, in and out of sample: the realized coverage matches the model's quantiles closely (correct unconditional calibration) and the PITs show no serial correlation (correct conditional calibration). This is the risk-forecasting payoff of the whole framework and the reason volatility-forecast quality matters for downstream risk sizing.

## From volatility forecast to return density to VaR

Value-at-Risk at confidence level alpha and horizon k is just the alpha-th percentile of the k-step-ahead return-density forecast, so a good VaR requires a good *density* forecast, not merely a point volatility forecast. The paper builds the density by composition: the VAR-RV supplies the forecast of (log) realized volatility, log volatility is Gaussian (Regularity 2), and returns standardized by realized volatility are Gaussian (Regularity 1), so the predictive return density is a lognormal-normal mixture (a normal whose variance is drawn from a lognormal). Quantiles of this mixture give the VaR at any confidence level, and the same density supports other risk objects (shortfall probabilities, expected shortfall) by the same quantile machinery.

## Validating the density: the probability integral transform

Correctness of a density forecast is checked with the method of Diebold, Gunther & Tay (1998). If the sequence of one-step-ahead conditional density forecasts equals the true conditional densities, then the **probability integral transforms** of the realized returns (each return mapped through its own forecast CDF) are independent and uniformly distributed on [0,1]. Uniformity is necessary but not sufficient: the transforms must also be independent, so that violating a quantile on one day carries no information about violating it the next. The paper checks both. A table of the fraction of realized returns below each model quantile matches the model's implied quantiles closely, in and out of sample (correct unconditional calibration / VaR coverage). Autocorrelation functions of the transforms and their squares show no serial correlation (correct conditional calibration). So the realized-volatility VAR plus lognormal-normal mixture is both correctly calibrated overall and correctly calibrated conditionally, meaning the VaR estimates are reliable through changing market conditions. The paper closes by noting directions for refinement: separating jump from continuous variation in the realized measure, and richer predictive-density methods (simulation, Cornish-Fisher, recalibration) for more challenging assets.

Source: Andersen, Bollerslev, Diebold & Labys, *Modeling and Forecasting Realized Volatility*, Econometrica 71(2):579-625 (2003), Sections 7-8; ingested from the open NBER Working Paper No. 8160 ([nber.org/papers/w8160](https://www.nber.org/papers/w8160)), sha256 `a14e0e5d`.
