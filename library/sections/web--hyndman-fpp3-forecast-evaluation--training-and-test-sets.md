---
title: Training and test sets — evaluating on genuine forecasts
source_kind: web
source_url: https://otexts.com/fpp3/accuracy.html
source_content_sha256: ce5f91f5c038754882dcf9b6823f6ff31ac6e6f5519ec43e6f1862f14a4775da
source_authors: [Rob J Hyndman, George Athanasopoulos]
source_date: 2021-01-01
ingested: 2026-07-16
ingested_by: scholar
topics: [forecast-evaluation, financial-forecasting, testing]
status: current
---

Abstract: Forecast accuracy can only be judged on **new data not used to fit the model** — the size of in-sample residuals is not a reliable indication of true forecast-error size. The standard method splits the series into a **training set** (estimate parameters) and a later **test set** (evaluate accuracy), where the test set is typically ~20% of the sample and at least as long as the maximum forecast horizon. Three warnings that matter directly for a trading system: a model that fits the training data well will not necessarily forecast well; a perfect fit is always obtainable with enough parameters; and **over-fitting is just as bad as failing to identify a systematic pattern**. This is the foundational discipline behind every out-of-sample backtest.

## Training and test sets

It is important to evaluate forecast accuracy using genuine forecasts. Consequently, the size of the residuals is not a reliable indication of how large true forecast errors are likely to be. The accuracy of forecasts can only be determined by considering how well a model performs on new data that were not used when fitting the model.

When choosing models, it is common practice to separate the available data into two portions, **training** and **test** data, where the training data is used to estimate any parameters of a forecasting method and the test data is used to evaluate its accuracy. Because the test data is not used in determining the forecasts, it should provide a reliable indication of how well the model is likely to forecast on new data.

The size of the test set is typically about 20% of the total sample, although this value depends on how long the sample is and how far ahead you want to forecast. The test set should ideally be **at least as large as the maximum forecast horizon** required. The following points should be noted:

- A model which fits the training data well will not necessarily forecast well.
- A perfect fit can always be obtained by using a model with enough parameters.
- **Over-fitting a model to data is just as bad as failing to identify a systematic pattern in the data.**

Some references describe the test set as the "hold-out set" because these data are "held out" of the data used for fitting. Other references call the training set the "in-sample data" and the test set the "out-of-sample data."

Source: [FPP3 §5.8 Evaluating point forecast accuracy](https://otexts.com/fpp3/accuracy.html), *Forecasting: Principles and Practice* (3rd ed), Hyndman & Athanasopoulos; content hash `ce5f91f5`. Lightly cleaned and abridged; derived from the original, not the original.
