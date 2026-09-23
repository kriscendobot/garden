---
source_kind: web
source_url: https://otexts.com/fpp3/
source_authors: [Rob J Hyndman, George Athanasopoulos]
source_date: 2021-01-01
source_content_sha256: ce5f91f5c038754882dcf9b6823f6ff31ac6e6f5519ec43e6f1862f14a4775da
retrieved: 2026-07-16
ingested: 2026-07-16
ingested_by: scholar
section_count: 4
status: current
notes: |
  Freely-published online textbook (OTexts). This source page captures the
  forecast-EVALUATION cluster of FPP3 (chapter 5.8 "Evaluating point forecast
  accuracy" and 5.10 "Time series cross-validation") — the finbot-critical
  material on out-of-sample discipline, error metrics, naive baselines, and
  walk-forward backtesting. Two chapter URLs / content hashes back these
  sections: §5.8 https://otexts.com/fpp3/accuracy.html (sha256 ce5f91f5c038…)
  and §5.10 https://otexts.com/fpp3/tscv.html (sha256 b43150210f1b…). The
  book is continuously updated online; source_date is the 3rd-edition baseline.
  Remaining FPP3 chapters (ARIMA §9, exponential smoothing §8, VAR/NN §12,
  what-can-be-forecast §1.1) are deferred to the follow-on
  scholar-ingest-financial-forecasting-corpus job. Idempotency anchor is the
  content hash, not a git SHA (web source).
---

Abstract: *Forecasting: Principles and Practice* (3rd ed) by Rob J Hyndman and George Athanasopoulos is the canonical modern, freely-available reference for applied time-series forecasting and — most valuably for finbot — for **forecast evaluation**. This source page ingests its evaluation cluster: how to split training/test sets and why in-sample fit misleads; the point-forecast error metrics (MAE, RMSE, MAPE/sMAPE and their pitfalls, and the recommended scale-free **MASE/RMSSE** that measure skill relative to a naive baseline); and **time series cross-validation** (rolling forecasting origin / expanding window), the correct form of a walk-forward backtest that never lets future data leak into a forecast. Together these are the backbone of the anti-overfitting discipline any trading/forecasting system must adopt before trusting a model.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [training-and-test-sets](../sections/web--hyndman-fpp3-forecast-evaluation--training-and-test-sets.md) | forecast-evaluation, financial-forecasting, testing | current |
| [forecast-errors-and-scale-dependent-measures](../sections/web--hyndman-fpp3-forecast-evaluation--forecast-errors-and-scale-dependent-measures.md) | forecast-evaluation, financial-forecasting | current |
| [percentage-and-scaled-errors-mase](../sections/web--hyndman-fpp3-forecast-evaluation--percentage-and-scaled-errors-mase.md) | forecast-evaluation, financial-forecasting | current |
| [time-series-cross-validation](../sections/web--hyndman-fpp3-forecast-evaluation--time-series-cross-validation.md) | forecast-evaluation, financial-forecasting, testing | current |
