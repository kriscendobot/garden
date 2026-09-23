---
title: Volatility Forecast Comparison Using Imperfect Volatility Proxies (IBM application: QLIKE distinguishes forecasts)
source: "Volatility Forecast Comparison Using Imperfect Volatility Proxies"
source_kind: paper
source_authors: [Andrew J. Patton]
source_year: 2011
source_venue: "Journal of Econometrics 160(1):246-256"
source_url: https://doi.org/10.1016/j.jeconom.2010.03.034
source_pdf_sha256: 2b85bc30f188dc19d0ac7dbfe854929148d27c42e3f73d2b16605558daf60cee
ingested: 2026-07-16
ingested_by: scholar
topics: [forecast-evaluation, financial-forecasting]
status: current
---

Abstract: In the paper's IBM illustration, forecasts from a 60-day rolling-window estimator and RiskMetrics are compared over 1994-2003 with intraday realized variance. The QLIKE family significantly favors the rolling-window forecast for several asymmetry choices, while MSE does not reject equal predictive accuracy. The result is not a universal victory for one model. It demonstrates that evaluation loss can change a conclusion and that QLIKE can retain discriminating power when MSE is dominated by a few large observations.

## Design of the comparison

The application forecasts IBM open-to-close daily return variance. It compares two simple methods: a recent 60-day rolling-window estimate and the RiskMetrics recursion. The evaluation sample contains 2,500 observations from January 1994 through December 2003. Realized variance from intraday returns supplies a much less noisy ex-post proxy than a squared daily return, though it remains an imperfect proxy in the paper's theory.

The comparison uses losses from the robust family, including MSE and QLIKE, and tests average loss differences for equal predictive accuracy. This is the right shape for a production experiment: preserve time ordering, keep both models fixed before each forecast, score all dates with the same loss, and attach uncertainty to the average difference.

## The evaluation conclusion

The QLIKE specification favors the rolling-window forecast, with statistically significant loss differences in the reported comparison. Under MSE, the point estimate also favors that method but the difference is not statistically distinguishable from zero. Patton attributes the contrast to MSE's greater sensitivity to a few extreme observations, which leaves it with less power in this sample.

This does not license a blanket claim that a rolling 60-day estimator beats RiskMetrics. It is a worked example of a more general discipline: a model ranking is conditional on the target, proxy, loss, sample, and test. Record all five when comparing a finbot volatility model against its baseline.

Source: Andrew J. Patton, *Volatility Forecast Comparison Using Imperfect Volatility Proxies*, section 4, doi:10.1016/j.jeconom.2010.03.034; open author PDF sha256 `2b85bc30`.
