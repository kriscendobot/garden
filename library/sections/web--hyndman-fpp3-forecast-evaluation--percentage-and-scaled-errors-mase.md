---
title: Percentage errors and scaled errors (MAPE, sMAPE, MASE, RMSSE)
source_kind: web
source_url: https://otexts.com/fpp3/accuracy.html
source_content_sha256: ce5f91f5c038754882dcf9b6823f6ff31ac6e6f5519ec43e6f1862f14a4775da
source_authors: [Rob J Hyndman, George Athanasopoulos]
source_date: 2021-01-01
ingested: 2026-07-16
ingested_by: scholar
topics: [forecast-evaluation, financial-forecasting]
status: current
---

Abstract: Unit-free accuracy measures for comparing across series. **Percentage errors** (MAPE, sMAPE) are simple but flawed: undefined/infinite when `y_t = 0`, unstable near zero, assume a meaningful zero point, and penalize asymmetrically — Hyndman & Koehler (2006) recommend against sMAPE. **Scaled errors** (Hyndman & Koehler 2006) are the recommended alternative: divide each error by the training-set MAE of a **naive** (or seasonal-naive) forecast, giving **MASE** = mean(|q_j|) and **RMSSE** = √mean(q_j²). The key property for skill assessment: a scaled error **< 1 means the forecast beats the average one-step naive forecast**, > 1 means it is worse — MASE turns "beats the naive baseline" into a single readable number.

## Percentage errors

The percentage error is `p_t = 100 e_t / y_t`. Percentage errors are unit-free and so are frequently used to compare across data sets. The most common measure is the **mean absolute percentage error: MAPE** = mean(|p_t|).

Percentage-error measures are **infinite or undefined if `y_t = 0`** and have extreme values when any `y_t` is near zero; they also assume the unit of measurement has a meaningful zero (a percentage error is meaningless for temperature on Fahrenheit/Celsius). They put a heavier penalty on negative than positive errors, which led to the "symmetric" **sMAPE** = mean(200|y_t − ŷ_t| / (y_t + ŷ_t)) used in the M3 competition. But if `y_t` is near zero `ŷ_t` usually is too, so sMAPE still divides by a near-zero number (unstable) and can even be negative. **Hyndman & Koehler (2006) recommend that sMAPE not be used.**

## Scaled errors

Scaled errors (Hyndman & Koehler 2006) scale the errors by the **training MAE from a simple forecast method**. For a non-seasonal series using naive forecasts:

`q_j = e_j / [ (1/(T−1)) · Σ_{t=2}^T |y_t − y_{t−1}| ]`

Because numerator and denominator are both on the original data's scale, `q_j` is scale-independent. **A scaled error is < 1 if it comes from a better forecast than the average one-step naive forecast computed on the training data, and > 1 if worse.** For seasonal series the denominator uses seasonal-naive errors `|y_t − y_{t−m}|`.

- **MASE** = mean(|q_j|)
- **RMSSE** = √mean(q_j²), with `q²_j = e²_j / [ (1/(T−m)) · Σ (y_t − y_{t−m})² ]`, taking `m = 1` for non-seasonal data.

Source: [FPP3 §5.8 Evaluating point forecast accuracy](https://otexts.com/fpp3/accuracy.html), *Forecasting: Principles and Practice* (3rd ed), Hyndman & Athanasopoulos; content hash `ce5f91f5`. Lightly cleaned and abridged; derived from the original, not the original.
