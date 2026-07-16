---
title: Rolling out-of-sample evaluation against the historical mean
source: "A Comprehensive Look at the Empirical Performance of Equity Premium Prediction"
source_kind: paper
source_authors: [Ivo Welch, Amit Goyal]
source_year: 2008
source_venue: "Review of Financial Studies 21(4):1455-1508"
source_url: https://doi.org/10.1093/rfs/hhm014
source_mirror_url: https://www.hec.unil.ch/agoyal/docs/Predictability_RFS.pdf
source_pdf_sha256: 57ad3636290682b93dc52a2baabc9440d84ed76b2736a08a8ba7a014c6df5b7b
source_fetched_via: wayback
ingested: 2026-07-16
ingested_by: scholar
topics: [forecast-evaluation, financial-forecasting]
status: current
---

Abstract: The paper makes the prevailing historical mean the null forecast and measures a predictor's rolling out-of-sample improvement with R2_OOS = 1 - MSE(model)/MSE(mean). Positive R2_OOS is therefore a plain operational requirement: the conditional forecast must reduce squared error versus simply forecasting the equity premium as it has averaged so far.

At each forecast date the alternative OLS regression and the historical-mean benchmark use only data available then. Welch and Goyal compare their rolling error vectors with R2_OOS, adjusted R2_OOS, RMSE differences, and McCracken's MSE-F statistic. Because the conditional regression nests the unconditional benchmark, ordinary asymptotic critical values are inappropriate. Their bootstrap imposes no predictability, preserves predictor autocorrelation and residual cross-correlation, and yields one-sided critical values for the claim that the conditional forecast is better.

The paper treats out-of-sample performance as a diagnostic of specification stability, not as an automatic replacement for in-sample evidence. A stable, correctly specified regression has less-powerful OOS tests than its in-sample OLS test. But a researcher who is not entitled to assume stability needs the diagnostic: a model can look significant in sample precisely because its relation changed. The authors also vary the initial estimation and evaluation periods, and use cumulative relative squared-error plots, so a favorable total is not mistaken for persistent usefulness.

Source: Welch and Goyal 2008, Section 2, doi:10.1093/rfs/hhm014; author-page PDF sha256 `57ad3636`.
