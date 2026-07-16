# Topic: financial-forecasting

> Abstract: Forecasting financial and market time series — the methods, their reach, and their limits. Spans classical time-series (ARIMA/SARIMA, exponential smoothing, state-space/Kalman), volatility models (ARCH/GARCH/GJR-GARCH/EGARCH, realized-volatility/HAR), econometric/factor models (Fama-French, VAR/VECM, cointegration), and machine-learning forecasters (gradient-boosted trees, LSTM/temporal-CNN, Transformers), together with what the efficient-market literature holds is and is not forecastable. The load-bearing empirical fact running through the topic: **conditional volatility is strongly forecastable (clustering, persistence, leverage), while the direction of returns at tradeable horizons is largely not** — which is why risk-forecasting-and-sizing systems (like the garden's [finbot](../../projects/finbot/README.md)) are on firmer ground than return-alpha predictors. The *how-to-judge-a-forecast* axis is split into its own topic, [`forecast-evaluation`](forecast-evaluation.md), because the evaluation discipline is the highest-value and most method-independent part of the subject. Seeded 2026-07-16 from the finbot literature survey; currently anchored on the FPP3 evaluation cluster with the classical-model and volatility-model sources queued for follow-on ingest.

## Sections

| Section | Source | One-line abstract |
|---------|--------|-------------------|
| [web--hyndman-fpp3-forecast-evaluation--training-and-test-sets](../sections/web--hyndman-fpp3-forecast-evaluation--training-and-test-sets.md) | FPP3 §5.8 (Hyndman & Athanasopoulos) | Genuine out-of-sample evaluation is the only reliable accuracy test; in-sample fit and over-parameterization mislead. |
| [web--hyndman-fpp3-forecast-evaluation--time-series-cross-validation](../sections/web--hyndman-fpp3-forecast-evaluation--time-series-cross-validation.md) | FPP3 §5.10 (Hyndman & Athanasopoulos) | Walk-forward / rolling forecasting origin — the correct backtest form for a time series; no future data ever leaks into a forecast. |

## See also

- [`forecast-evaluation`](forecast-evaluation.md) — how to judge the forecasts these methods produce (the anti-overfitting discipline).
- Concepts: [[garch-volatility-models]], [[efficient-market-hypothesis]], [[walk-forward-validation]].
- Project: [finbot](../../projects/finbot/README.md) — the garden's volatility-forecasting / vol-targeting trading agent; see its [literature review](../../projects/finbot/financial-forecasting-literature-review.md).
