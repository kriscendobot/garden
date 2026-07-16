---
title: A Simple Approximate Long-Memory Model of Realized Volatility (estimation and out-of-sample forecast performance)
source: "A Simple Approximate Long-Memory Model of Realized Volatility"
source_kind: paper
source_authors: [Fulvio Corsi]
source_year: 2009
source_venue: "Journal of Financial Econometrics 7(2):174-196 (2009)"
source_url: https://doi.org/10.1093/jjfinec/nbp001
source_pdf_sha256: 18c305635feefc152a0522791de67677b5db037dd10958a09134c7d55cf222e5
ingested: 2026-07-16
ingested_by: scholar
topics: [financial-forecasting, forecast-evaluation]
status: current
---

Abstract: The empirical payoff of HAR-RV, from Corsi 2009 section 3 -- the estimation recipe and the out-of-sample forecast comparison that made HAR the standard realized-volatility baseline. On three long tick-by-tick series (USD/CHF spot, S&P500 futures, 30-year T-Bond futures) HAR(3) is estimated by ordinary least squares with a Newey-West correction; all three horizon coefficients are highly significant (one exception: the daily coefficient on the noisier T-Bond). Out of sample, with models daily re-estimated on a rolling 1000-observation window (proper [[walk-forward-validation]]), HAR(3) *steadily outperforms* AR(1) and AR(3) at one-day, one-week, and two-week horizons and is *comparable to* the true long-memory ARFIMA -- while being far simpler to implement. The forecasts are scored by RMSE, MAE, and the R-squared of Mincer-Zarnowitz regressions. The gap over short-memory AR grows with horizon, because AR(1)/AR(3) revert to the unconditional mean too fast.

## Data and estimation

The empirical study uses three long high-frequency series: USD/CHF spot (14 years, Dec 1989 to Dec 2003, 3599 daily observations), S&P500 futures (Jan 1990 to Jul 2007, 4344 observations), and 30-year US T-Bond futures (Jan 1990 to Oct 2003, 3391 observations). Daily realized volatility is computed with the two-scales estimator of Zhang, Ait-Sahalia & Mykland (2005) (a microstructure-noise-robust estimator using the slower frequency of ten-tick returns), then aggregated to weekly and monthly averages.

Estimation is deliberately trivial: because every term in the HAR regression is observed, the coefficients are fit by **ordinary least squares**, which is consistent and asymptotically normal, with a **Newey-West** covariance correction for serial correlation (order 5). In-sample all three realized-volatility coefficients are highly significant (t-statistics in the 6-to-13 range). The single exception is the *daily* coefficient for the T-Bond (t = 1.67, insignificant): the T-Bond realized-volatility series is noisier (lower tick arrival frequency, higher microstructure impact), so the noisy daily component loses significance while the smoother weekly and monthly averages, carrying less noise and more information, receive higher weight -- a nice illustration that averaging over longer windows denoises the volatility signal.

A by-product of the OLS fit: the daily/weekly/monthly coefficients read directly as **market-component weights** (the relative contribution of each horizon's traders), and a moving-window regression traces their evolution over time.

## HAR is a restricted AR(22): does the restriction hold?

Since the monthly term spans 22 trading days, the natural unrestricted comparison is AR(22). Corsi runs an F-test comparing the restricted HAR(3) against the unrestricted AR(22), plus AIC and BIC. The F-tests reject the restrictions for all three series (unsurprising given 19 restrictions and thousands of observations, and the rejection cause is asset-specific: minor extra frequencies for the S&P, a weekly periodicity in USD/CHF coefficients, unstable high lags for the T-Bond). But the information criteria tell the practical story: AIC is essentially tied between AR(22) and HAR(3), while **BIC -- which penalizes extra parameters more -- clearly prefers HAR(3)**. So the parsimonious three-coefficient restriction is well justified on a parameter-count-aware basis.

## The out-of-sample result

This is the headline. Models are **daily re-estimated on a rolling window of 1000 observations** (genuine out-of-sample [[walk-forward-validation]]; the ARFIMA is the partial exception -- its fractional coefficient d is pre-estimated on the whole sample, so its numbers slightly flatter it). Forecasts are made at three horizons -- one day, one week, two weeks -- with multi-step forecasts evaluated on the aggregated realized-versus-predicted volatility over the horizon. Accuracy is scored by RMSE, MAE, and the R-squared of the Mincer-Zarnowitz regression of ex-post realized volatility on the model forecast.

The finding: **HAR(3) steadily outperforms the short-memory AR(1) and AR(3) at all three horizons, and is comparable to the true long-memory ARFIMA(5,d,0)** (slight HAR edge at daily and weekly, slight ARFIMA edge at biweekly). Two points sharpen the result:

1. The HAR/ARFIMA advantage over AR(1)/AR(3) is already visible at the daily horizon but becomes **striking at the weekly and two-week horizons**. The reason is that AR(1)/AR(3) have a memory too short relative to the forecast horizon, so they revert to the unconditional mean too quickly; the long-memory-mimicking models keep their persistence out to the longer horizons. This is a concrete demonstration of *why* long memory matters for volatility forecasting.
2. HAR matches ARFIMA at a fraction of the trouble: HAR is "extremely simple and straightforward to implement even on a daily moving window," whereas ARFIMA is "cumbersome and complicated," and its results are sensitive to the fractional-difference Taylor-expansion cutoff and the GPH frequency cutoff. And ARFIMA's out-of-sample numbers are not even truly out of sample (d is fitted on the full sample).

That combination -- near-long-memory accuracy from a three-regressor OLS model that is trivial to roll forward -- is why HAR became the default realized-volatility forecaster and the baseline any newer volatility model is expected to beat. Corsi closes by noting how easily HAR extends: add jump components, add leverage terms (lagged signed returns), combine with smooth-transition or tree-structured nonlinearity, or build a multivariate Vector-HAR -- all keeping the additive-cascade skeleton.

## Evaluation notes for a forecasting harness

The metrics are worth cataloguing as evaluation practice (see [`forecast-evaluation`](../topics/forecast-evaluation.md)): RMSE and MAE for point-forecast error, and the **Mincer-Zarnowitz regression** (regress ex-post realized volatility on a constant and the forecast; a good forecast has intercept ~0, slope ~1, and high R-squared) as the standard forecast-optimality check. The rolling-1000-observation re-estimation is the correct walk-forward protocol; the honest caveat Corsi flags about ARFIMA's whole-sample d-estimation is exactly the kind of subtle look-ahead a rigorous evaluation must police.

Source: Fulvio Corsi, *A Simple Approximate Long-Memory Model of Realized Volatility*, Journal of Financial Econometrics 7(2):174-196 (2009), section 3, doi:10.1093/jjfinec/nbp001; ingested from an open-access PDF copy, sha256 `18c30563`.
