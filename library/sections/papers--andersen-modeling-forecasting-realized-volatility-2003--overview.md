---
title: Modeling and Forecasting Realized Volatility (overview)
source: "Modeling and Forecasting Realized Volatility"
source_kind: paper
source_authors: [Torben G. Andersen, Tim Bollerslev, Francis X. Diebold, Paul Labys]
source_year: 2003
source_venue: "Econometrica 71(2):579-625 (2003); NBER Working Paper No. 8160 (March 2001)"
source_url: https://doi.org/10.1111/1468-0262.00418
source_pdf_sha256: a14e0e5de7e8b13b9218dbe503041a78d9416c49d9a36eafc909333ebfdea7ea
ingested: 2026-07-16
ingested_by: scholar
topics: [financial-forecasting, forecast-evaluation]
status: current
---

Abstract: The paper's central move is to treat return volatility as *observed* rather than *latent*, by constructing **realized volatility** (the sum of cross-products of high-frequency intraday returns) as a nearly error-free ex-post measure of each day's variability. Because volatility is then an observable variable, it can be modeled and forecast with simple, standard time-series tools instead of the filtering that ARCH and stochastic-volatility models require. Applied to nearly thirteen years (1986-1999) of 30-minute DM/$ and yen/$ spot exchange-rate returns, a simple long-memory Gaussian vector autoregression (VAR) for the daily logarithmic realized volatilities produces one- and ten-day-ahead forecasts that dominate GARCH(1,1), RiskMetrics EWMA, and daily-absolute-return models out of sample, and yields well-calibrated return-density and Value-at-Risk forecasts. This is the canonical realized-volatility reference for [[garch-volatility-models]] and a clean demonstration of why a superior estimate of *current* volatility translates directly into superior forecasts.

## What the paper argues

Traditional volatility forecasting (ARCH/GARCH, stochastic volatility, RiskMetrics) treats the day's variance as a latent state that must be inferred by filtering past daily squared returns. Two limits had stalled the field by the late 1990s: high-frequency intraday data made little impact on daily-volatility modeling, and the models stayed low-dimensional (usually univariate) because multivariate ARCH suffers a curse of dimensionality.

The paper's answer is to change the object being modeled. Under a continuous-time arbitrage-free price process, the theory of quadratic variation shows that the sum of squared (and cross-) high-frequency intraday returns over a day converges to that day's integrated volatility, and so provides an ex-post estimate that is asymptotically free of measurement error. Treating this **realized volatility** as observed collapses the hard latent-variable problem into an ordinary observed-variable time-series problem: model and forecast realized volatility directly with a VAR.

## The three empirical regularities the modeling rests on

From the in-sample DM/$ and yen/$ data (established in companion ABDL papers), three facts drive every modeling choice (see the [gaussian-and-long-memory-regularities](papers--andersen-modeling-forecasting-realized-volatility-2003--gaussian-and-long-memory-regularities.md) section):

1. Raw daily returns are fat-tailed, but returns **standardized by realized volatility are approximately Gaussian**.
2. Realized volatilities are right-skewed, but their **logarithms are approximately Gaussian**.
3. The **long-run dynamics of realized logarithmic volatility are well described by a long-memory (fractionally-integrated) process**, with a fractional-integration parameter d near 0.4.

Together these motivate a Gaussian long-memory VAR for log realized volatility, and a lognormal-normal mixture for the return distribution.

## Headline result

Comparing one-day-ahead and ten-day-ahead forecasts out of sample, the long-memory realized-volatility VAR (VAR-RV) systematically beats GARCH(1,1), RiskMetrics, and an otherwise-identical VAR built on daily absolute returns (VAR-ABS). The reason is not that GARCH is a bad model of daily volatility (it explains about as much of future volatility variation as is theoretically feasible from daily data) but that daily squared returns are a **noisy** proxy for the current volatility innovation, whereas realized volatility gives a sharp, quickly-adapting estimate of *current* conditions, which is what a good forecast is built on.

Source: Andersen, Bollerslev, Diebold & Labys, *Modeling and Forecasting Realized Volatility*, Econometrica 71(2):579-625 (2003); ingested from the open NBER Working Paper No. 8160 ([nber.org/papers/w8160](https://www.nber.org/papers/w8160)), sha256 `a14e0e5d`.
