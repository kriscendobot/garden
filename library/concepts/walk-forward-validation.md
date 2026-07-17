---
id: walk-forward-validation
aliases: [walk-forward, walk-forward backtest, rolling forecasting origin, rolling forecast origin, time series cross-validation, tscv, expanding window, out-of-sample backtest, backtest, rolling-origin evaluation]
topics: [forecast-evaluation, financial-forecasting, testing]
---

# walk-forward-validation

The time-series-correct way to estimate a forecasting model's true accuracy: repeatedly fit on data up to time *t*, forecast *t+1…t+h*, roll *t* forward, and average the errors over all origins — **so no future observation is ever used to construct a forecast**. Equivalent names: *rolling forecasting origin*, *time series cross-validation* (Hyndman & Athanasopoulos), *walk-forward backtest*. Two window shapes: an **expanding window** (train on all history so far — the default) or a **rolling fixed window** (train on a fixed-length recent slice — a bet that old data is non-representative). It replaces plain k-fold cross-validation, which is invalid for time series because it leaks future into past. This is the backbone of any trustworthy trading backtest: the estimate of live performance is only as honest as the out-of-sample protocol producing it. For a trading system, the walk-forward loop should also record the *policy's* realized P&L net of costs at each origin, not just the forecast error.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [time-series-cross-validation](../sections/web--hyndman-fpp3-forecast-evaluation--time-series-cross-validation.md) | The canonical definition: a series of one-observation test sets, training only on prior data, averaged over origins; the multi-step and expanding-window variants. |
| [training-and-test-sets](../sections/web--hyndman-fpp3-forecast-evaluation--training-and-test-sets.md) | The simple single-split precursor and why in-sample fit is not a reliable accuracy indicator. |
| [papers--corsi-simple-long-memory-model-realized-volatility-2009--out-of-sample-forecast-performance](../sections/papers--corsi-simple-long-memory-model-realized-volatility-2009--out-of-sample-forecast-performance.md) | Corsi's HAR-RV out-of-sample test: daily re-estimation on a rolling 1000-observation window, scored by RMSE/MAE and Mincer-Zarnowitz R2 at one-day/one-week/two-week horizons -- a worked volatility walk-forward. |
| [Welch & Goyal rolling out-of-sample benchmark](../sections/papers--welch-comprehensive-look-equity-premium-prediction-2008--rolling-out-of-sample-historical-mean-benchmark.md) | Rolling equity-premium forecasts use only data then available and must reduce MSE relative to the prevailing historical mean. |

## See also

- [[look-ahead-bias]] — the failure walk-forward is designed to prevent.
- [[mean-absolute-scaled-error]] — the naive-relative metric to average over the rolling origins.
- [[data-snooping-bias]] — walk-forward alone does not fix multiple-testing across many models.
