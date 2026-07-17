---
title: Exchange-rate example and the forecast-comparison contract
source: "Comparing Predictive Accuracy"
source_kind: paper
source_authors: [Francis X. Diebold, Roberto S. Mariano]
source_year: 1995
source_venue: "Journal of Business & Economic Statistics 13(3):253-263"
source_url: https://doi.org/10.1080/07350015.1995.10524599
source_pdf_sha256: 93aadf7294c50788584384b4806f6bf7d58b959da550405ea6db431d7330bcd5
ingested: 2026-07-17
ingested_by: scholar
topics: [forecast-evaluation, financial-forecasting]
status: current
---

Abstract: The paper's empirical illustration compares two forecasts of the three-month change in the dollar/Dutch-guilder spot exchange rate — the random walk's "no change" forecast and the forecast implied by the three-month forward rate — under absolute-error loss. Because the forecasts are three-step-ahead, the loss differential is (correctly) two-dependent, so only `S1` with truncation lag two applies; it yields `S1 = −1.3`, `p = 0.19`, so the equal-accuracy null is *not* rejected: the forward rate is not a statistically significantly worse predictor than the random walk. The famous "the random walk wins" is, on this sample, not statistically significant — the point of having a test. The conclusion sets out the comparison contract and the test's own boundaries.

**The example.** The series is the three-month change in the nominal dollar/guilder end-of-month spot rate, monthly from 1977.01 to 1991.12. The random-walk forecast is constant at zero; the forward-market forecast (three-month forward minus spot) moves over time; both are dwarfed by the actual change. The loss differential (forward minus random walk, absolute error) shows no obvious nonstationarity, and its sample autocorrelation function decays quickly, with sizable significant autocorrelations at lags 1 and 2 and nowhere else — a Box–Pierce test rejects joint-zero autocorrelations at lags 1–15 (51.12, highly significant) but not at lags 3–15 (12.79, insignificant), confirming two-dependence. `F`, MGN, and MR are inapplicable because their maintained assumptions are explicitly violated, so the test is `S1` at truncation lag two: `S1 = −1.3`, `p = 0.19`. Do not reject equal expected absolute error.

**The comparison contract (section 5).** Comparison of forecast accuracy is *one* of many diagnostics for comparing models, not the only one. Superiority of one model on forecast accuracy does not imply the other model's forecasts carry no additional information — the message of the forecast-combination and forecast-encompassing literatures (Clemen 1989; Chong and Hendry 1986; Fair and Shiller 1990). The authors close by placing the article in a larger program: doing model selection, estimation, prediction, and evaluation *under the relevant loss function, whatever it is* — this article addresses evaluation.

**Placement in this corpus.** Diebold–Mariano is the **pairwise ancestor** of the multiple-model corrections the [[data-snooping-bias]] page collects: White's Reality Check (2000) and Hansen's SPA (2005) generalize the two-forecast comparison to "the best of `N` searched models beats the benchmark" while accounting for the search (see [Hansen and Lunde 2005](papers--hansen-lunde-forecast-comparison-volatility-models-2005--spa-corrects-the-330-model-search.md)), and the Model Confidence Set returns the set statistically indistinguishable from the best. DM alone tests exactly two forecasts and applies no search correction — using it to pick a winner out of many models is itself a data-snooping error. It also supplies precisely the significance test that [Meese and Rogoff 1983](papers--meese-rogoff-exchange-rate-models-seventies-1983--random-walk-benchmark-survives-the-horse-race.md)'s point-forecast horse race lacked; here it is applied to the same random-walk-versus-forward question and finds the apparent random-walk win statistically insignificant. Finally, the loss-agnosticism keeps the corpus's core distinction intact: run DM on a variance-forecast loss ([QLIKE](papers--patton-volatility-forecast-comparison-imperfect-proxies-2011--robust-loss-functions-and-qlike.md)) and it speaks to relative *risk-forecast* quality; run it on a return or direction-of-change loss and it speaks to relative *directional* quality — a significant DM result about one is not evidence about the other.

Source: Diebold and Mariano 1995, section 4 (empirical example) and section 5 (conclusions), canonical DOI [10.1080/07350015.1995.10524599](https://doi.org/10.1080/07350015.1995.10524599); readable PDF [author copy (F. Diebold, U. Penn)](https://www.sas.upenn.edu/~fdiebold/papers/paper68/pa.dm.pdf), sha256 `93aadf7294c5`.
