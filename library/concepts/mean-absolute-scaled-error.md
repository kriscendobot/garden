---
id: mean-absolute-scaled-error
aliases: [MASE, mean absolute scaled error, scaled error, RMSSE, root mean squared scaled error, MAE, RMSE, MAPE, sMAPE, forecast skill, naive baseline, skill score, QLIKE]
topics: [forecast-evaluation, financial-forecasting]
---

# mean-absolute-scaled-error

A scale-free forecast-accuracy metric (Hyndman & Koehler 2006) that measures skill **relative to a naive baseline**: divide each forecast error by the training-set mean absolute error of a naive (or seasonal-naive) one-step forecast, then average the absolute scaled errors — **MASE < 1 means the forecast beats the naive baseline; > 1 means it is worse**. RMSSE is the squared-error analogue. MASE/RMSSE are preferred over percentage errors (MAPE, sMAPE), which are undefined/unstable near zero and penalize asymmetrically (Hyndman & Koehler recommend against sMAPE). Scale-dependent measures (MAE = mean|e|, RMSE = √mean e²) are fine within one series but cannot compare across series; note that minimizing MAE targets the median while minimizing RMSE targets the mean. **The general principle for any forecasting system: report skill relative to a naive baseline, not raw error.** For *volatility* forecasts specifically, the latent-target analogue is a proper loss such as **QLIKE** or MSE evaluated against a variance proxy (squared returns or realized variance), compared to a random-walk-variance / EWMA baseline (Patton 2011).

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [percentage-and-scaled-errors-mase](../sections/web--hyndman-fpp3-forecast-evaluation--percentage-and-scaled-errors-mase.md) | Defines MAPE/sMAPE and their pitfalls, and the scaled errors MASE/RMSSE that measure skill relative to the naive baseline. |
| [forecast-errors-and-scale-dependent-measures](../sections/web--hyndman-fpp3-forecast-evaluation--forecast-errors-and-scale-dependent-measures.md) | Defines forecast error, MAE, RMSE, and the median-vs-mean consequence of the loss you minimize. |
| [papers--andersen-modeling-forecasting-realized-volatility-2003--long-memory-var-beats-garch-out-of-sample](../sections/papers--andersen-modeling-forecasting-realized-volatility-2003--long-memory-var-beats-garch-out-of-sample.md) | No universal volatility-loss function; ABDL evaluate forecasts with Mincer-Zarnowitz regressions against the low-noise realized measure (baseline-relative skill for vol). |

## See also

- [[walk-forward-validation]] — the protocol over which these metrics are averaged.
- [[data-snooping-bias]] — a good MASE found after many trials may still be luck; deflate/correct.
