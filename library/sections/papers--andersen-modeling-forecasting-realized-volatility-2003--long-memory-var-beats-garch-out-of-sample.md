---
title: Long-memory realized-volatility VAR beats GARCH out of sample
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

Abstract: The paper's headline forecasting result and its explanation, and a worked example of forecast-evaluation methodology. A simple trivariate Gaussian **long-memory VAR on realized log volatility** (VAR-RV) is compared out of sample against the three dominant daily-data alternatives: GARCH(1,1) (Engle-Bollerslev), RiskMetrics EWMA (an IGARCH with fixed smoothing 0.94), and an otherwise-identical VAR on daily absolute returns (VAR-ABS). Evaluated with Mincer-Zarnowitz regressions (regress the ex-post realized volatility on a constant and each forecast), VAR-RV systematically dominates at both one-day and ten-day horizons: its forecasts pass the unbiasedness test (intercept 0, slope 1) while the daily-data models generally fail it, and adding a daily-data forecast alongside VAR-RV barely raises R-squared. The lesson generalizes beyond this dataset: GARCH is not a bad model of daily volatility (it extracts about as much as daily data allow) but daily squared returns are a **noisy proxy for the current volatility innovation**, so they adapt only gradually, whereas realized volatility gives a sharp, quickly-adapting estimate of *current* conditions, which is what a forecast is built from.

## The model and the competitors

The forecasting model is a simple trivariate VAR for the three realized log volatilities with the common long-memory structure imposed: A(L)(1-L)^d (y - mu) = eps, with d fixed at the estimated 0.401 and a one-week (five-day) lag, estimated by OLS equation by equation. Impulse responses dissipate at the slow hyperbolic rate k^(d-1). The competitors, all estimated on the same 2,449-day in-sample period: GARCH(1,1) (the leading academic model, Engle 1982 and Bollerslev 1986; the estimated volatility persistence is high, autoregressive roots 0.986-0.990); RiskMetrics (the leading practitioner model, exponentially-weighted moving average of daily return cross-products with smoothing 0.94, equivalent to a zero-intercept IGARCH(1,1)); and VAR-ABS (the same VAR structure but on daily absolute returns instead of realized volatility, a controlled comparison isolating the value of the high-frequency measure).

## The evaluation: Mincer-Zarnowitz forecast regressions

There is no universally accepted loss function for comparing nonlinear volatility forecasts, so the paper follows the Mincer-Zarnowitz tradition: regress the ex-post realized volatility on a constant and one or more model forecasts, and test whether a forecast is unbiased (intercept b0 = 0, slope b1 = 1) and whether a competing forecast adds explanatory power. For one-day-ahead forecasts, the VAR-RV regression R-squared is always highest, and for none of the VAR-RV forecasts can the unbiasedness hypothesis be rejected; in contrast, the unbiasedness hypothesis is rejected for most RiskMetrics, GARCH, and VAR-ABS forecasts, both in and out of sample. When VAR-RV and a competitor are entered together, the VAR-RV slope stays near 1 and the competitor's near 0, and the competitor adds little R-squared. The ten-day-ahead results are qualitatively identical. This is notable because prior work had found daily GARCH(1,1) hard to beat for exchange-rate volatility with more complicated multivariate or high-frequency-fitted ARCH models.

## Why realized volatility wins (the transferable lesson)

The superiority is not a failure of GARCH per se: Andersen-Bollerslev (1998) show GARCH explains about as much future volatility variation as is theoretically feasible from daily data. The point is measurement. The essence of forecasting is mapping the present into the future, so a superior estimate of *present* volatility yields superior forecasts. Realized volatility, using all of a day's intraday information, jumps immediately when volatility spikes on day T; GARCH and RiskMetrics depend only on squared returns from days T-1, T-2, ..., which are a long, slowly-decaying weighted average, so they move only gradually and lag the true volatility. The noise in daily squared returns necessarily makes the current volatility innovation imprecise no matter how correct the daily model is. For a forecasting system this argues for measuring the target as precisely as possible (here, from higher-frequency data) rather than only refining the model form, and for evaluating volatility forecasts against a low-noise realized measure rather than against daily squared returns. See [[garch-volatility-models]] for the model family and [[mean-absolute-scaled-error]] for the loss-function side of volatility-forecast evaluation.

Source: Andersen, Bollerslev, Diebold & Labys, *Modeling and Forecasting Realized Volatility*, Econometrica 71(2):579-625 (2003), Sections 5-6; ingested from the open NBER Working Paper No. 8160 ([nber.org/papers/w8160](https://www.nber.org/papers/w8160)), sha256 `a14e0e5d`.
