---
title: Forecast errors and scale-dependent measures (MAE, RMSE)
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

Abstract: A forecast **error** is the difference between an observed value and its forecast, `e_{T+h} = y_{T+h} − ŷ_{T+h|T}` — the unpredictable part of an observation, computed on the **test set** (unlike residuals, which are computed on the training set from one-step forecasts). The two most common scale-dependent accuracy measures are **MAE** = mean(|e|) and **RMSE** = √mean(e²). They live on the data's own scale, so they cannot compare across series of different units. A key modeling consequence: minimizing MAE yields forecasts of the **median**, while minimizing RMSE yields forecasts of the **mean** — the loss you optimize determines the point forecast you get.

## Forecast errors

A forecast "error" is the difference between an observed value and its forecast. Here "error" does not mean a mistake, it means the unpredictable part of an observation. It can be written as `e_{T+h} = y_{T+h} − ŷ_{T+h|T}`, where the training data is `{y_1,…,y_T}` and the test data is `{y_{T+1}, y_{T+2},…}`.

Forecast errors differ from residuals in two ways. First, residuals are calculated on the **training set** while forecast errors are calculated on the **test set**. Second, residuals are based on **one-step** forecasts while forecast errors can involve **multi-step** forecasts.

## Scale-dependent errors

The forecast errors are on the same scale as the data. Accuracy measures based only on `e_t` are therefore **scale-dependent** and cannot be used to compare series that involve different units. The two most commonly used are:

- **Mean absolute error: MAE** = mean(|e_t|)
- **Root mean squared error: RMSE** = √mean(e_t²)

When comparing forecast methods applied to a single series (or several series with the same units), MAE is popular as it is easy to understand and compute. A forecast method that minimises the MAE leads to forecasts of the **median**, while minimising the RMSE leads to forecasts of the **mean**. Consequently RMSE is also widely used, despite being harder to interpret.

Source: [FPP3 §5.8 Evaluating point forecast accuracy](https://otexts.com/fpp3/accuracy.html), *Forecasting: Principles and Practice* (3rd ed), Hyndman & Athanasopoulos; content hash `ce5f91f5`. Lightly cleaned and abridged; derived from the original, not the original.
