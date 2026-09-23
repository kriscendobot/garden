---
title: MSPE adjustment and the practical one-sided test
source: "Approximately Normal Tests for Equal Predictive Accuracy in Nested Models"
source_kind: paper
source_authors: [Todd E. Clark, Kenneth D. West]
source_year: 2007
source_venue: "Journal of Econometrics 138(1):291-311 (2007); ingested from NBER Technical Working Paper 326 (August 2006)"
source_url: https://doi.org/10.1016/j.jeconom.2006.05.023
source_pdf_sha256: 69d6c6c90399b12ebc33bf683b564506745f95943a57cefac9ebddf4ffa90362
ingested: 2026-07-17
ingested_by: scholar
topics: [forecast-evaluation, financial-forecasting]
status: current
---

Abstract: Clark and West remove the larger model's estimated-zero-coefficient penalty by adding the squared fitted-forecast gap back to the raw loss differential. Regress the adjusted per-period differential on a constant and use a one-sided t statistic for a positive mean, with a usual standard error for one-step forecasts and a serial-correlation-consistent one for overlapping horizons.

For forecast origin `t`, define squared errors from the small and large models as `e_1,t+1^2` and `e_2,t+1^2`. The adjusted loss differential is:

`f_t+1 = e_1,t+1^2 - [e_2,t+1^2 - (yhat_1,t+1 - yhat_2,t+1)^2]`.

Its sample mean is `MSPE_1 - (MSPE_2 - adjustment)`. The subtraction inside the bracket removes the upward MSPE component caused by fitting the larger model's coefficients that are zero under the null. Algebraically it is also `2 e_1,t+1 (e_1,t+1 - e_2,t+1)`, which connects it to encompassing tests. The authors prefer the adjusted-MSPE interpretation: it corrects the comparison's measurement target rather than replacing it with a different contest.

The implementation is deliberately simple. Regress `f_t+1` on a constant, test whether that constant is positive, and reject only in the direction that says the larger nested model has lower adjusted MSPE. For one-step errors the ordinary least-squares standard error is proposed; for autocorrelated multi-step errors, use an autocorrelation-consistent standard error. A positive rejection says the added variables improve the specified forecast objective after the fitting-noise correction. It does not establish economic value, return-direction skill, or superiority over alternatives considered elsewhere.

Source: Clark and West, section 2 and equations (3.7)-(3.9), working-paper version: [NBER Technical Working Paper 326 (August 2006)](https://www.nber.org/system/files/working_papers/t0326/t0326.pdf), published version DOI [10.1016/j.jeconom.2006.05.023](https://doi.org/10.1016/j.jeconom.2006.05.023), sha256 `69d6c6c90399`.
