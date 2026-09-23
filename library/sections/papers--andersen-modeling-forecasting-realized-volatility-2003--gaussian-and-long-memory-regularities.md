---
title: Three empirical regularities of returns and realized volatility
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

Abstract: The three stylized facts, established from the DM/$ and yen/$ realized-volatility series, that justify every downstream modeling choice and that a volatility-forecasting system should expect to hold in its own data. (1) Raw daily returns are fat-tailed with volatility clustering (strong serial correlation in squared returns, none in returns), but returns **standardized by realized volatility are approximately Gaussian** with no residual clustering, in sharp contrast to the leptokurtosis that survives when standardizing by an ARCH/SV model forecast. (2) Realized volatilities are severely right-skewed and leptokurtic in levels, but their **logarithms are almost exactly Gaussian**. (3) Realized log volatility exhibits **long memory**: its autocorrelations decay at a slow hyperbolic rate, and the estimated fractional-integration parameter d is about 0.4 (common across the three rates). These are the empirical anchors for using log realized volatility, a Gaussian long-memory model, and a lognormal-normal return mixture.

## Regularity 1: realized-vol-standardized returns are Gaussian

Raw daily DM/$ and yen/$ returns are approximately symmetric and zero-mean but distinctly fat-tailed (high kurtosis, confirmed by kernel densities), with Ljung-Box statistics showing no serial correlation in returns but strong serial correlation in squared returns, the classic fat-tails-and-volatility-clustering signature dating to Mandelbrot (1963) and Fama (1965). But when each return is standardized by its *realized* volatility, the result is close to Gaussian (kurtosis below the normal value of 3) with no evidence of volatility clustering. This is a striking contrast with the standard finding that returns standardized by a one-day-ahead ARCH or stochastic-volatility *forecast* remain leptokurtic (which is why non-Gaussian conditional densities became common). Realized-volatility standardization removes the fat tails because the ex-post realized measure captures the actual within-day volatility, not a filtered estimate of it.

## Regularity 2: log realized volatility is Gaussian

The realized volatilities themselves are severely right-skewed and highly leptokurtic. Taking logarithms (the realized log standard deviations) produces distributions that are remarkably Gaussian, with kernel densities nearly coinciding with the normal reference. The log-normality of realized volatility licenses standard Gaussian distribution theory for modeling and forecasting, and, combined with the Gaussian standardized returns of Regularity 1, implies the unconditional return distribution is well approximated by a **lognormal-normal mixture** (a normal whose variance is itself lognormal), the distribution used later for density and VaR forecasts.

## Regularity 3: long memory in realized log volatility

Realized daily log volatilities show strong, slowly-decaying serial correlation. The autocorrelations out to a quarter (about 70 days) decay at the slow hyperbolic rate symptomatic of **long memory / fractional integration**, not the fast geometric decay of a short-memory ARMA. Log-periodogram (Geweke-Porter-Hudak) estimates put the fractional-integration parameter d significantly above 0 and below 0.5 for all three rates, with a common estimate of about d = 0.401 (a joint test of equal d across the three volatilities is not rejected). A single fractional-differencing filter (1-L)^0.401 removes the bulk of the serial dependence. The volatilities are also strongly contemporaneously correlated across rates (about 0.6-0.7) though not fractionally cointegrated. This long-memory structure is the single most important dynamic feature: the paper notes the one-parameter univariate long-memory models explain roughly 50% of realized-volatility variation, leaving only about 2% for the multivariate VAR to add. It connects to [[garch-volatility-models]] via long-memory GARCH variants (FIGARCH) and is the reason a plain short-memory GARCH under-persists relative to what the data show.

Source: Andersen, Bollerslev, Diebold & Labys, *Modeling and Forecasting Realized Volatility*, Econometrica 71(2):579-625 (2003), Section 4; ingested from the open NBER Working Paper No. 8160 ([nber.org/papers/w8160](https://www.nber.org/papers/w8160)), sha256 `a14e0e5d`.
