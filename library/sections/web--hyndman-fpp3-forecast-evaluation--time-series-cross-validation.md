---
title: Time series cross-validation (rolling forecasting origin)
source_kind: web
source_url: https://otexts.com/fpp3/tscv.html
source_content_sha256: b43150210f1be352edf57c5fd83ebecdae7d540f0050e3b931412cc9718e351b
source_authors: [Rob J Hyndman, George Athanasopoulos]
source_date: 2021-01-01
ingested: 2026-07-16
ingested_by: scholar
topics: [forecast-evaluation, financial-forecasting, testing]
status: current
---

Abstract: The time-series-correct generalization of a single train/test split — the canonical **walk-forward** backtest. There is a *series* of test sets, each one observation; the corresponding training set consists **only of observations prior to** the test observation, so **no future observations can ever be used in constructing the forecast**. Accuracy is averaged over all test sets. Because the forecast origin advances through time, this is also called **"evaluation on a rolling forecasting origin."** It extends naturally to multi-step (e.g. 4-step-ahead) evaluation, and to an **expanding window** (start from a small initial training set and grow it one step at a time). This is the exact discipline a trading backtest must follow to avoid look-ahead bias.

## Time series cross-validation

A more sophisticated version of training/test sets is **time series cross-validation**. In this procedure there are a series of test sets, each consisting of a single observation. The corresponding training set consists **only of observations that occurred prior to the observation that forms the test set. Thus, no future observations can be used in constructing the forecast.** Since a reliable forecast is not possible from a very small training set, the earliest observations are not used as test sets.

The forecast accuracy is computed by **averaging over the test sets**. This procedure is sometimes known as **"evaluation on a rolling forecasting origin"** because the "origin" at which the forecast is based rolls forward in time.

With time series forecasting, one-step forecasts may not be as relevant as multi-step forecasts. The rolling-origin procedure can be modified to use **multi-step errors** — e.g. if you care about good 4-step-ahead forecasts, evaluate the 4-step error at each rolling origin.

In practice (FPP3's example) an **expanding window** is built by starting with a small initial training set (`.init`) and increasing successive training sets by a fixed step (`.step = 1`), then averaging accuracy across all the resulting origins — and comparing this genuine out-of-sample accuracy against the (optimistic) in-sample residual accuracy.

Source: [FPP3 §5.10 Time series cross-validation](https://otexts.com/fpp3/tscv.html), *Forecasting: Principles and Practice* (3rd ed), Hyndman & Athanasopoulos; content hash `b4315021`. Lightly cleaned and abridged; derived from the original, not the original.
